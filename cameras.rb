require_relative "vectors"

class Camera
	def initialize(eye, forward, right, up)
		@eye = eye
		@forward = forward
		@right = right
		@up = up
	end

	def self.global_up()
		return Vec3.new(0.0, 1.0, 0.0)
	end

	def self.look_at(eye, focus, aspect, zoom)
		forward = focus.subtract(eye).normalized().scale_by_m(zoom)
		right = forward.cross(Camera.global_up()).normalized().scale_by_m(aspect)
		up = right.cross(forward).normalized()
		return Camera.new(eye, forward, right, up)
	end

	def eye()
		return @eye
	end

	def forward()
		return @forward
	end

	def right()
		return @right
	end

	def up()
		return @up
	end

	def image_direction(xx, yy)
		right_component = @right.scale_by_m((2.0 * xx) - 1.0)
		up_component = @up.scale_by_m((2.0 * yy) - 1.0)
		return @forward.add(right_component.subtract(up_component)).normalized()
	end
end

if __FILE__ == $0 then
	eye = Vec3.new(1.0, 2.0, 3.0)
	focus = Vec3.zero()
	aspect = 1.5
	zoom = 1.25
	c = Camera.look_at(eye, focus, aspect, zoom)
	puts c.eye.x, c.eye.y, c.eye.z
	puts c.forward.x, c.forward.y, c.forward.z
	puts c.right.x, c.right.y, c.right.z
	puts c.up.x, c.up.y, c.up.z
end
