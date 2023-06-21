FlxBasePoint = IFlxPooled:extend()
FlxBasePoint.pool = FlxPool:new(FlxBasePoint)

function FlxBasePoint:get(x, y)
    return FlxBasePoint:new(x or 0, y or 0)
end

function FlxBasePoint:set(x, y)
    self.x = x or 0
    self.y = y or 0
    return self
end

FlxPoint = FlxBasePoint:extend()
FlxPoint.EPSILON = 0.0000001
FlxPoint.EPSILON_SQUARED = FlxPoint.EPSILON * FlxPoint.EPSILON

FlxPoint._point1 = FlxPoint:new()
FlxPoint._point2 = FlxPoint:new()
FlxPoint._point3 = FlxPoint:new()

function FlxPoint:get(x,y)
    return FlxBasePoint:get(x or 0, y or 0)
end