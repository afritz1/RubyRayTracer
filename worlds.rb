require_relative "intersections"
require_relative "lights"
require_relative "materials"
require_relative "rays"
require_relative "shapes"
require_relative "vectors"

class World
	def initialize(spheres, cuboids, sphere_lights, cuboid_lights, background)
		@spheres = spheres
		@cuboids = cuboids
		@sphere_lights = sphere_lights
		@cuboid_lights = cuboid_lights
		@background = background
	end

	def self.random(sphere_count, cuboid_count, sphere_light_count, cuboid_light_count, world_radius)
		spheres = []
		cuboids = []
		sphere_lights = []
		cuboid_lights = []

		sphere_count.times {
			material = Material.new(Vec3.rand_color())
			point = Vec3.rand_point_in_sphere(world_radius)
			radius = 0.5 + rand()
			spheres.push(Sphere.new(material, point, radius))
		}

		cuboid_count.times {
			material = Material.new(Vec3.rand_color())
			point = Vec3.rand_point_in_sphere(world_radius)
			width = 0.5 + rand()
			height = 0.5 + rand()
			depth = 0.5 + rand()
			cuboids.push(Cuboid.new(material, point, width, height, depth))
		}

		sphere_light_count.times {
			material = Material.new(Vec3.rand_color())
			point = Vec3.rand_point_in_sphere(world_radius)
			radius = 0.5 + rand()
			sphere_lights.push(SphereLight.new(material, point, radius))
		}

		cuboid_light_count.times {
			material = Material.new(Vec3.rand_color())
			point = Vec3.rand_point_in_sphere(world_radius)
			width = 0.5 + rand()
			height = 0.5 + rand()
			depth = 0.5 + rand()
			cuboid_lights.push(CuboidLight.new(material, point, width, height, depth))		
		}

		background = Vec3.rand_color()
		return World.new(spheres, cuboids, sphere_lights, cuboid_lights, background)
	end

	def spheres()
		return @spheres
	end

	def cuboids()
		return @cuboids
	end

	def sphere_lights()
		return @sphere_lights
	end

	def cuboid_lights()
		return @cuboid_lights
	end

	def nearest_shape(ray)		
		nearest_try = Intersection.empty()
		current_try = Intersection.empty()

		for sphere in @spheres			
			current_try = sphere.intersect(ray)
			if current_try.t < nearest_try.t then
				nearest_try = current_try
			end
		end

		for cuboid in @cuboids
			current_try = cuboid.intersect(ray)
			if current_try.t < nearest_try.t then
				nearest_try = current_try
			end
		end

		return nearest_try
	end

	def nearest_light(ray)	
		nearest_try = Intersection.empty()
		current_try = Intersection.empty()

		for sphere_light in @sphere_lights
			current_try = sphere_light.intersect(ray)
			if current_try.t < nearest_try.t then
				nearest_try = current_try
			end
		end

		for cuboid_light in @cuboid_lights
			current_try = cuboid_light.intersect(ray)
			if current_try.t < nearest_try.t then
				nearest_try = current_try
			end
		end

		return nearest_try
	end

	def nearest_hit(ray)
		shapes_try = self.nearest_shape(ray)
		lights_try = self.nearest_light(ray)
		return (shapes_try.t <= lights_try.t) ? shapes_try : lights_try
	end

	def phong_at(intersection, ray)
		hit_point = ray.point_at(intersection.t)
		view = ray.direction.negate()
		local_normal = (intersection.normal.dot(view) > 0.0) ? 
			intersection.normal : intersection.normal.negate()
					
		ambient = 0.35
		diffuse = intersection.material.color

		color = diffuse.scale_by_v(@background).scale_by_m(ambient)

		for sphere_light in @sphere_lights
			light_radius = sphere_light.sphere.radius
			light_point = sphere_light.sphere.point.
				add(Vec3.rand_point_in_sphere(light_radius))
			light_direction = light_point.subtract(hit_point).normalized()
			hit_point_eps = hit_point.add(local_normal.scale_by_m(Vec3::EPSILON))
			light_ray = Ray.new(hit_point_eps, light_direction, Ray::INITIAL_DEPTH)
			light_try = sphere_light.intersect(light_ray)
			shapes_try = self.nearest_shape(light_ray)

			if light_try.t < shapes_try.t then
				light_color = sphere_light.sphere.material.color
				ln_dot = light_direction.dot(local_normal)
				intensity = [0.0, ln_dot].max
				color = color.add(diffuse.scale_by_v(light_color).scale_by_m(intensity))
			end
		end

		for cuboid_light in @cuboid_lights
			light_width = cuboid_light.cuboid.width
			light_height = cuboid_light.cuboid.height
			light_depth = cuboid_light.cuboid.depth
			light_point = cuboid_light.cuboid.point.
				add(Vec3.rand_point_in_cuboid(light_width, light_height, light_depth))
			light_direction = light_point.subtract(hit_point).normalized()
			hit_point_eps = hit_point.add(local_normal.scale_by_m(Vec3::EPSILON))
			light_ray = Ray.new(hit_point_eps, light_direction, Ray::INITIAL_DEPTH)
			light_try = cuboid_light.intersect(light_ray)
			shapes_try = self.nearest_shape(light_ray)

			if light_try.t < shapes_try.t then
				light_color = cuboid_light.cuboid.material.color
				ln_dot = light_direction.dot(local_normal)
				intensity = [0.0, ln_dot].max
				color = color.add(diffuse.scale_by_v(light_color).scale_by_m(intensity))
			end
		end

		return color
	end

	def ray_trace(ray)
		nearest_try = self.nearest_hit(ray)

		if nearest_try.t < Intersection::T_MAX then
			if !nearest_try.is_light then
				return self.phong_at(nearest_try, ray)
			else
				return nearest_try.material.color
			end
		else
			return @background
		end
	end
end

if __FILE__ == $0 then
	w = World.random(5, 6, 1, 2, 10.0)
	puts w.spheres.length
	puts w.cuboids.length
	puts w.sphere_lights.length
	puts w.cuboid_lights.length

	r = Ray.new(Vec3.zero(), Vec3.rand_point_in_sphere(1.0).normalized(), Ray::INITIAL_DEPTH)

	color = w.ray_trace(r)
	puts color.x, color.y, color.z
end
