require_relative "shapes"
require_relative "rays"
require_relative "vectors"

class SphereLight
	def initialize(material, point, radius)
		@sphere = Sphere.new(material, point, radius)
	end

	def sphere()
		return @sphere
	end

	def intersect(ray)
		intersection = @sphere.intersect(ray)
		intersection.is_light = true
		return intersection
	end
end

class CuboidLight
	def initialize(material, point, width, height, depth)
		@cuboid = Cuboid.new(material, point, width, height, depth)
	end
	
	def cuboid()
		return @cuboid
	end

	def intersect(ray)
		intersection = @cuboid.intersect(ray)
		intersection.is_light = true
		return intersection
	end
end

if __FILE__ == $0 then
	s = SphereLight.new(nil, Vec3.zero(), 1.0)
	c = CuboidLight.new(nil, Vec3.zero(), 0.5, 1.5, 2.5)
	puts s.sphere.point.x, s.sphere.point.y, s.sphere.point.z
	puts c.cuboid.point.x, c.cuboid.point.y, c.cuboid.point.z
	r = Ray.new(Vec3.zero(), Vec3.new(0.3, 0.4, 0.5).normalized(), Ray::INITIAL_DEPTH)
	i1 = s.intersect(r)
	i2 = c.intersect(r)
	puts i1.t
	puts i1.is_light
	puts i2.t
	puts i2.is_light
end
