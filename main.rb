# main.rb, for the Ruby Ray Tracer, by Aaron Fritz. 7/2/2016.

# Ruby is kind of fun! But slow like vanilla Python.

require_relative "cameras"
require_relative "rays"
require_relative "vectors"
require_relative "worlds"

def main()
	screen_width = 1280
	screen_height = 720
	sphere_count = 8
	cuboid_count = 8
	sphere_light_count = 1
	cuboid_light_count = 1
	world_radius = 8.0
	zoom = 1.25
	out_filename = "output.ppm"

	eye = Vec3.new(4.0, 4.0, 12.0)
	focus = Vec3.new(0.0, 0.0, 0.0)
	aspect = screen_width.to_f() / screen_height.to_f()
	camera = Camera.look_at(eye, focus, aspect, zoom)

	world = World.random(
		sphere_count, 
		cuboid_count, 
		sphere_light_count, 
		cuboid_light_count, 
		world_radius)

	colors = Array.new(screen_width * screen_height)

	for y in 0..(screen_height - 1)
		print (y + 1), " / ", screen_height, "\n"
		yy = (y.to_f() + 0.5) / screen_height.to_f()
		for x in 0..(screen_width - 1)
			xx = (x.to_f() + 0.5) / screen_width.to_f()
			direction = camera.image_direction(xx, yy)
			ray = Ray.new(camera.eye, direction, Ray::INITIAL_DEPTH)
			index = x + (y * screen_width)
			colors[index] = world.ray_trace(ray).clamped()
		end
	end

	out_file = File.new(out_filename, "w")
	comment = "# This is from the Ruby Ray Tracer, by Aaron Fritz."
	out_file.print "P3", "\n", comment, "\n", screen_width, " ", screen_height, "\n", 255, "\n"

	for y in 0..(screen_height - 1)
		for x in 0..(screen_width - 1)
			index = x + (y * screen_width)
			color = colors[index]
			r = (color.x * 255.0).to_i()
			g = (color.y * 255.0).to_i()
			b = (color.z * 255.0).to_i()
			out_file.print r, " ", g, " ", b, " "
		end
		out_file.print "\n"
	end

	out_file.close()
end

if __FILE__ == $0 then
	main()
end
