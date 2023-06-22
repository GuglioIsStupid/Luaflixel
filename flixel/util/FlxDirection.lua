FlxDirection = class:extend()

FlxDirection.LEFT = 0x0001
FlxDirection.RIGHT = 0x0010
FlxDirection.UP = 0x0100
FlxDirection.DOWN = 0x1000

function FlxDirection:toString()
    if self == FlxDirection.LEFT then
        return "L"
    elseif self == FlxDirection.RIGHT then
        return "R"
    elseif self == FlxDirection.UP then
        return "U"
    elseif self == FlxDirection.DOWN then
        return "D"
    end
end