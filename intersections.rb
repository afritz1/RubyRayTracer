require_relative "materials"
require_relative "vectors"

class Intersection
	T_MAX = 1.0e50

	def initialize(t, normal, material, is_light)
		@t = t
		@normal = normal
		@material = material
		@is_light = is_light
	end

	def self.empty()
		return Intersection.new(Intersection::T_MAX, nil, nil, false)
	end

	def t()
		return @t
	end

	def normal()
		return @normal
	end

	def material()
		return @material
	end

	def is_light()
		return @is_light
	end

	def is_light=(value)
		@is_light = value
	end
end

if __FILE__ == $0 then
	i = Intersection.empty()
	puts i.t
	puts i.normal.x, i.normal.y, i.normal.z
	puts i.is_light
end
