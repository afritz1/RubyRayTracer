require_relative "vectors"

class Ray
	INITIAL_DEPTH = 0

	def initialize(point, direction, depth)
		@point = point
		@direction = direction
		@depth = depth
	end
	
	def point()
		return @point
	end

	def direction()
		return @direction
	end

	def depth()
		return @depth
	end

	def point_at(distance)
		return @point.add(@direction.scale_by_m(distance))
	end
end

if __FILE__ == $0 then
	point = Vec3.new(1.2, 3.4, 5.6)
	direction = Vec3.new(0.3, 0.6, 0.4).normalized()
	depth = Ray::INITIAL_DEPTH
	r = Ray.new(point, direction, depth)
	puts r.point.x, r.point.y, r.point.z
	puts r.direction.x, r.direction.y, r.direction.z
	puts r.depth
end
