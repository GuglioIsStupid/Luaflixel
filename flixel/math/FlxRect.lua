FlxRect = IFlxPooled:extend()

FlxRect.pool = FlxPool:new(FlxRect)
FlxRect._pool = FlxPool:new(FlxRect)

function FlxRect:get(X, Y, W, H)
    local rect = self._pool:get():set(X, Y, W, H)
    rect._inPool = false
    return rect
end

function FlxRect:set(X, Y, W, H)
    self.x = X or 0
    self.y = Y or 0
    self.width = W or 0
    self.height = H or 0
    return self
end

function FlxRect:new(X, Y, W, H)
    self:set(X, Y, W, H)
    return self
end