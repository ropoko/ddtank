local Utils = {}

function Utils:has_collision(x1, y1, w1, h1, x2, y2, w2, h2)
	return (
		x2 < x1 + w1 and
		x1 < x2 + w2 and
		y1 < y2 + h2 and
		y2 < y1 + h1
	)
end

return Utils
