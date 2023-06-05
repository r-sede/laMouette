local Util = {}

Util.toZeroIndex = function(arr)
    local res = {}
    local i
    for i = 0, #arr do
        res[i] = arr[i + 1]
    end
    return res
end


Util.clamp = function(val, min, max)
    return math.min(math.max(val, min), max)
end

Util.round = function(val)
    local floor = math.floor(val)
    if (val % 1 >= 0.5) then
        return floor + 1
    end
    return floor
end

Util.lerp = function(a, b, t)
    return a + (b - a) * t
end



Util.isCollide = function(rect1, rect2)
    return rect1.x < rect2.x + rect2.width and rect1.x + rect1.width > rect2.x and rect1.y < rect2.y + rect2.height and
            rect1.height + rect1.y > rect2.y
end

Util.distance = function(x1, y1, x2, y2)
    return math.abs(math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2))
end

Util.isCollideRec = function(x1, y1, width1, height1, x2, y2, width2, height2)
    -- print(x1, y1, width1, height1, x2, y2, width2, height2)
    return x1 < x2 + width2 and x1 + width1 > x2 and y1 < y2 + height2 and height1 + y1 > y2
end

return Util