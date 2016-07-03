class Vec3
	EPSILON = 1.0e-6

	def initialize(x, y, z)
		@x = x
		@y = y
		@z = z
	end

	def self.zero()
		return Vec3.new(0.0, 0.0, 0.0)
	end

	def self.rand_color()
		return Vec3.new(rand(), rand(), rand())
	end

	def self.rand_point_in_sphere(radius)
		x = (2.0 * rand()) - 1.0
		y = (2.0 * rand()) - 1.0
		z = (2.0 * rand()) - 1.0
		return Vec3.new(x, y, z).normalized().scale_by_m(radius)
	end

	def self.rand_point_in_cuboid(width, height, depth)
		w = width * ((2.0 * rand()) - 1.0)
		h = height * ((2.0 * rand()) - 1.0)
		d = depth * ((2.0 * rand()) - 1.0)
		return Vec3.new(w, h, d)
	end

	def self.rand_hemisphere_direction(normal)
		dir = Vec3.new(rand(), rand(), rand()).normalized()
		return (dir.dot(normal) >= 0.0) ? dir : dir.negate()
	end

	def x()
		return @x
	end

	def y()
		return @y
	end

	def z()
		return @z
	end

	def dot(v)
		return (@x * v.x) + (@y * v.y) + (@z * v.z)
	end

	def cross(v)
		x = (@y * v.z) - (v.y * @z)
		y = (v.x * @z) - (@x * v.z)
		z = (@x * v.y) - (v.x * @y)
		return Vec3.new(x, y, z)
	end

	def length_squared()
		return (@x * @x) + (@y * @y) + (@z * @z)
	end

	def length()
		return Math.sqrt(self.length_squared())
	end

	def normalized()
		len_recip = 1.0 / self.length()
		return Vec3.new(@x * len_recip, @y * len_recip, @z * len_recip)
	end

	def add(v)
		return Vec3.new(@x + v.x, @y + v.y, @z + v.z)
	end

	def subtract(v)
		return Vec3.new(@x - v.x, @y - v.y, @z - v.z)
	end

	def negate()
		return Vec3.new(-@x, -@y, -@z)
	end

	def scale_by_m(m)
		return Vec3.new(@x * m, @y * m, @z * m)
	end

	def scale_by_v(v)
		return Vec3.new(@x * v.x, @y * v.y, @z * v.z)
	end
	
	def reflect(normal)
		return normal.scale_by_m(self.dot(n) * 2.0).subtract(self)
	end

	def lerp(v, percent)
		diff = v.subtract(self)
		return self.add(diff.scale_by_m(percent))
	end

	def clamped()
		x = (@x > 1.0) ? 1.0 : ((@x < 0.0) ? 0.0 : @x)
		y = (@y > 1.0) ? 1.0 : ((@y < 0.0) ? 0.0 : @y)
		z = (@z > 1.0) ? 1.0 : ((@z < 0.0) ? 0.0 : @z)
		return Vec3.new(x, y, z)
	end
end

if __FILE__ == $0 then
	v = Vec3.new(1.0, 2.0, 3.0)
	puts v.x, v.y, v.z
end
