require_relative "intersections"
require_relative "materials"
require_relative "rays"
require_relative "vectors"

class Sphere
	def initialize(material, point, radius)
		@material = material
		@point = point
		@radius = radius
	end

	def material()
		return @material
	end
	
	def point()
		return @point
	end

	def radius()
		return @radius
	end

	def intersect(ray)
		radius_recip = 1.0 / @radius
		radius_squared = @radius * @radius
		diff = @point.subtract(ray.point)
		b = diff.dot(ray.direction)
		determinant = (b * b) - diff.dot(diff) + radius_squared
		if (determinant < 0.0) then
			return Intersection.empty()
		else
			det_sqrt = Math.sqrt(determinant)
			b1 = b - det_sqrt
			b2 = b + det_sqrt
			t = (b1 > Vec3::EPSILON) ? b1 : ((b2 > Vec3::EPSILON) ? b2 : Intersection::T_MAX)
			normal = ray.point_at(t).subtract(@point).scale_by_m(radius_recip)
			return Intersection.new(t, normal, self.material, false)
		end
	end
end

class Cuboid
	def initialize(material, point, width, height, depth)
		@material = material
		@point = point
		@width = width
		@height = height
		@depth = depth
	end

	def material()
		return @material
	end
	
	def point()
		return @point
	end

	def width()
		return @width
	end

	def height()
		return @height
	end

	def depth()
		return @depth
	end

	def intersect(ray)
        tMin = 0.0
        tMax = 0.0

        nMinX = 0.0
        nMinY = 0.0
        nMinZ = 0.0

        nMaxX = 0.0
        nMaxY = 0.0
        nMaxZ = 0.0

        tX1 = (@point.x - @width - ray.point.x) / ray.direction.x
        tX2 = (@point.x + @width - ray.point.x) / ray.direction.x

        tY1 = (@point.y - @height - ray.point.y) / ray.direction.y
        tY2 = (@point.y + @height - ray.point.y) / ray.direction.y

        tZ1 = (@point.z - @depth - ray.point.z) / ray.direction.z
        tZ2 = (@point.z + @depth - ray.point.z) / ray.direction.z

        if tX1 < tX2 then
            tMin = tX1
            tMax = tX2
            nMinX = (-width)
            nMaxX = width
        else
            tMin = tX2
            tMax = tX1
            nMinX = width
            nMaxX = (-width)
		end

        if tY1 < tY2 then
            if tY1 > tMin then
                tMin = tY1
                nMinX = 0.0
                nMinY = (-height)
			end
            if tY2 < tMax then
                tMax = tY2
                nMaxX = 0.0
                nMaxY = height
			end
        else
            if tY2 > tMin then
                tMin = tY2
                nMinX = 0.0
                nMinY = height
			end
            if tY1 < tMax then
                tMax = tY1
                nMaxX = 0.0
                nMaxY = (-height)
			end
		end

        if tZ1 < tZ2 then
            if tZ1 > tMin then
                tMin = tZ1
                nMinX = 0.0
                nMinY = 0.0
                nMinZ = (-depth)
			end
            if tZ2 < tMax then
                tMax = tZ2
                nMaxX = 0.0
                nMaxY = 0.0
                nMaxZ = depth
			end
        else
            if tZ2 > tMin then
                tMin = tZ2
                nMinX = 0.0
                nMinY = 0.0
                nMinZ = depth
			end
            if tZ1 < tMax then
                tMax = tZ1
                nMaxX = 0.0
                nMaxY = 0.0
                nMaxZ = (-depth)
			end
		end

        if (tMax < 0.0) || (tMin > tMax) then
            return Intersection.empty()
        else
            if tMin < 0.0 then
                tMin = tMax
                nMinX = nMaxX
                nMinY = nMaxY
                nMinZ = nMaxZ
			end
            t = tMin
            normal = Vec3.new(nMinX, nMinY, nMinZ).normalized()
            return Intersection.new(t, normal, material, false)
		end
	end
end

if __FILE__ == $0 then
	material = nil
	point = Vec3.zero()
	radius = 0.5
	width = 0.3
	height = 0.6
	depth = 0.9
	s = Sphere.new(material, point, radius)
	c = Cuboid.new(material, point, width, height, depth)
	puts s.point.x, s.point.y, s.point.z
	puts s.radius
	puts c.point.x, c.point.y, c.point.z
	puts c.width, c.height, c.depth

	r = Ray.new(point, Vec3.new(0.3, 0.2, 0.1).normalized(), Ray::INITIAL_DEPTH)
	i1 = s.intersect(r)
	i2 = c.intersect(r)
	puts i1.t
	puts i1.is_light
	puts i2.t
	puts i2.is_light
end
