require_relative "vectors"

class Material
	def initialize(color)
		@color = color
	end

	def color()
		return @color
	end
end

if __FILE__ == $0 then
	m = Material.new(Vec3.rand_color())
	puts m.color.x, m.color.y, m.color.z
end
