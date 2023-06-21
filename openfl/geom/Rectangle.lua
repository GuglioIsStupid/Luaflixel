Rectangle = class:extend()

function Rectangle:new(x,y,w,h)
    self.x = x or 0
    self.y = y or 0
    self.width = w or 0
    self.height = h or 0
end

function Rectangle:clone()
    return Rectangle:new(self.x, self.y, self.width, self.height)
end

function Rectangle:contains(x,y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Rectangle:containsPoint(point)
    return self:contains(point.x, point.y)
end

function Rectangle:containsRect(rect)
    if (rect.width <= 0 or rect.height <= 0) then
        return rect.x > self.x and rect.y > self.y and rect.x + rect.width < self.x + self.width and rect.y + rect.height < self.y + self.height
    else
        return rect.x >= self.x and rect.y >= self.y and rect.x + rect.width <= self.x + self.width and rect.y + rect.height <= self.y + self.height
    end
end

function Rectangle:copyFrom(sourceRect)
    self.x = sourceRect.x
    self.y = sourceRect.y
    self.width = sourceRect.width
    self.height = sourceRect.height
end

function Rectangle:equals(toCompare)
    if (toCompare == self) then return true
    else
        return toCompare ~= nil and toCompare.x == self.x and toCompare.y == self.y and toCompare.width == self.width and toCompare.height == self.height
    end
end

function Rectangle:inflate(dx, dy)
    self.x = self.x - dx
    self.width = self.width + dx * 2
    self.y = self.y - dy
    self.height = self.height + dy * 2
end

function Rectangle:inflatePoint(point)
    self:inflate(point.x, point.y)
end

function Rectangle:intersection(toIntersect)
    local x0 = x < toIntersect.x and toIntersect or x
    local x1 = x + width > toIntersect.x + toIntersect.width and toIntersect.x + toIntersect.width or x + width
    
    if (x1 <= x0) then
        return Rectangle:new(0, 0, 0, 0)
    end

    local y0 = y < toIntersect.y and toIntersect or y
    local y1 = y + height > toIntersect.y + toIntersect.height and toIntersect.y + toIntersect.height or y + height

    if (y1 <= y0) then
        return Rectangle:new(0, 0, 0, 0)
    end

    return Rectangle:new(x0, y0, x1 - x0, y1 - y0)
end

function Rectangle:intersects(toIntersect)
    local x0 = x < toIntersect.x and toIntersect or x
    local x1 = x + width > toIntersect.x + toIntersect.width and toIntersect.x + toIntersect.width or x + width
    
    if (x1 <= x0) then
        return false
    end

    local y0 = y < toIntersect.y and toIntersect or y
    local y1 = y + height > toIntersect.y + toIntersect.height and toIntersect.y + toIntersect.height or y + height

    return y1 > y0
end

function Rectangle:isEmpty()
    return (self.width <= 0 or self.height <= 0)
end

function Rectangle:offset(dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
end

function Rectangle:offsetPoint(point)
    self.x = self.x + point.x
    self.y = self.y + point.y
end

function Rectangle:setEmpty()
    self.x = 0
    self.y = 0
    self.width = 0
    self.height = 0
end

function Rectangle:setTo(xa, ya, widtha, heighta)
    self.x = xa
    self.y = ya
    self.width = widtha
    self.height = heighta
end

function Rectangle:toString()
    return '(x=' .. self.x .. ', y=' .. self.y .. ', width=' .. self.width .. ', height=' .. self.height .. ')'
end

function Rectangle:union(toUnion)
    if (self.width == 0 or self.height == 0) then
        return toUnion:clone()
    elseif (toUnion.width == 0 or toUnion.height == 0) then
        return self:clone()
    end

    local x0 = self.x > toUnion.x and toUnion.x or self.x
    local x1 = self.x + self.width < toUnion.x + toUnion.width and toUnion.x + toUnion.width or self.x + self.width
    local y0 = self.y > toUnion.y and toUnion.y or self.y
    local y1 = self.y + self.height < toUnion.y + toUnion.height and toUnion.y + toUnion.height or self.y + self.height

    return Rectangle:new(x0, y0, x1 - x0, y1 - y0)
end

function Rectangle:__contract(x,y,w,h)
    if (self.width == 0 and self.height == 0) then
        return
    end

    local offsetX = 0
    local offsetY = 0
    local offsetRight = 0
    local offsetBottom = 0
    
    if (self.x < x) then offsetX = x - self.x end
    if (self.y < y) then offsetY = y - self.y end
    if (self.x + self.width > x + w) then offsetRight = (x + w) - (self.x + self.width) end
    if (self.y + self.height > y + h) then offsetBottom = (y + h) - (self.y + self.height) end

    self.x = self.x + offsetX
    self.y = self.y + offsetY
    self.width = self.width + offsetRight - offsetX
    self.height = self.height + offsetBottom - offsetY
end

function Rectangle:__expand(x,y,w,h)
    if (self.width == 0 and self.height == 0) then
        self.x = x
        self.y = y
        self.width = w
        self.height = h
        return
    end

    local cacheRight = self.x + self.width
    local cacheBottom = self.y + self.height

    if (self.x > x) then
        self.x = x
        self.width = cacheRight - x
    end

    if (self.y > y) then
        self.y = y
        self.height = cacheBottom - y
    end

    if (cacheRight < x + w) then
        self.width = x + w - self.x
    end

    if (cacheBottom < y + h) then
        self.height = y + h - self.y
    end
end

function Rectangle:transform(rect, matrix)
    local tx0 = matrix.a * rect.x + matrix.c * rect.y
    local tx1 = tx0
    local ty0 = matrix.b * rect.x + matrix.d * rect.y
    local ty1 = ty0

    local tx = matrix.a * (rect.x + rect.width) + matrix.c * rect.y
    local ty = matrix.b * (rect.x + rect.width) + matrix.d * rect.y

    if (tx < tx0) then tx0 = tx end
    if (ty < ty0) then ty0 = ty end
    if (tx > tx1) then tx1 = tx end
    if (ty > ty1) then ty1 = ty end

    tx = matrix.a * (rect.x + rect.width) + matrix.c * (rect.y + rect.height)
    ty = matrix.b * (rect.x + rect.width) + matrix.d * (rect.y + rect.height)

    if (tx < tx0) then tx0 = tx end
    if (ty < ty0) then ty0 = ty end
    if (tx > tx1) then tx1 = tx end
    if (ty > ty1) then ty1 = ty end

    tx = matrix.a * rect.x + matrix.c * (rect.y + rect.height)
    ty = matrix.b * rect.x + matrix.d * (rect.y + rect.height)

    if (tx < tx0) then tx0 = tx end
    if (ty < ty0) then ty0 = ty end
    if (tx > tx1) then tx1 = tx end
    if (ty > ty1) then ty1 = ty end

    rect:setTo(tx0 + matrix.tx, ty0 + matrix.ty, tx1 - tx0, ty1 - ty0)
end

function Rectangle:get_bottom()
    return self.y + self.height
end

function Rectangle:set_bottom(value)
    self.height = value - self.y
end

function Rectangle:get_bottomRight()
    return Point:new(self.x + self.width, self.y + self.height)
end

function Rectangle:set_bottomRight(point)
    self.width = point.x - self.x
    self.height = point.y - self.y
    return point:clone()
end

function Rectangle:get_left()
    return self.x
end

function Rectangle:set_left(value)
    self.width = self.width - value - self.x
    self.x = value
    return value
end

function Rectangle:get_right()
    return self.x + self.width
end

function Rectangle:set_right(value)
    self.width = value - self.x
    return value
end

function Rectangle:get_size()
    return Point:new(self.width, self.height)
end

function Rectangle:set_size(point)
    self.width = point.x
    self.height = point.y
    return point:clone()
end

function Rectangle:get_top()
    return self.y
end

function Rectangle:set_top(value)
    self.height = self.height - value - self.y
    self.y = value
    return value
end

function Rectangle:get_topLeft()
    return Point:new(self.x, self.y)
end

function Rectangle:set_topLeft(point)
    self.x = point.x
    self.y = point.y
    return point:clone()
end

function Rectangle:__tostring()
    return string.format("[Rectangle] (x:%.2f, y:%.2f, width:%.2f, height:%.2f)", self.x, self.y, self.width, self.height)
end