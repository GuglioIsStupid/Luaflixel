FlxDirectionFlags = FlxDirection:extend()

FlxDirectionFlags.LEFT = 0x0001
FlxDirectionFlags.RIGHT = 0x0010
FlxDirectionFlags.UP = 0x0100
FlxDirectionFlags.DOWN = 0x1000

FlxDirectionFlags.NONE = 0x0000

FlxDirectionFlags.CEILING = 0x0100
FlxDirectionFlags.FLOOR = 0x1000
FlxDirectionFlags.WALL = 0x0011

FlxDirectionFlags.ANY = 0x1111

FlxDirectionFlags.degrees = 0

function FlxDirectionFlags:get_degrees()
    --[[
        return switch (this) {
			case RIGHT: 0;
			case DOWN: 90;
			case UP: -90;
			case LEFT: 180;
			case f if (f == DOWN | RIGHT): 45;
			case f if (f == DOWN | LEFT): 135;
			case f if (f == UP | RIGHT): -45;
			case f if (f == UP | LEFT): -135;
			default: 0;
		}
    ]]

    if self == FlxDirectionFlags.RIGHT then
        return 0
    elseif self == FlxDirectionFlags.DOWN then
        return 90
    elseif self == FlxDirectionFlags.UP then
        return -90
    elseif self == FlxDirectionFlags.LEFT then
        return 180
    elseif self == FlxDirectionFlags.DOWN and FlxDirectionFlags.RIGHT then
        return 45
    elseif self == FlxDirectionFlags.DOWN and FlxDirectionFlags.LEFT then
        return 135
    elseif self == FlxDirectionFlags.UP and FlxDirectionFlags.RIGHT then
        return -45
    elseif self == FlxDirectionFlags.UP and FlxDirectionFlags.LEFT then
        return -135
    else
        return 0
    end
end

FlxDirectionFlags.radians = 0

function FlxDirectionFlags:get_radians()
    return self.degrees * FlxAngle.TO_RAD
end

function FlxDirectionFlags:has(dir)
    return self and dir == self
end

function FlxDirectionFlags:hasAny(dir)
    return self and dir and self ~= 0
end

function FlxDirectionFlags:with(dir)
    return self or dir
end

function FlxDirectionFlags:without(dir)
    return self and dir and self ~= 0 and self ~= dir
end

function FlxDirectionFlags:toString()
    if self == FlxDirectionFlags.NONE then
        return "NONE"
    end

    local str = ""
    if self:has(FlxDirectionFlags.LEFT) then
        str = str .. " | L"
    end
    if self:has(FlxDirectionFlags.RIGHT) then
        str = str .. " | R"
    end
    if self:has(FlxDirectionFlags.UP) then
        str = str .. " | U"
    end
    if self:has(FlxDirectionFlags.DOWN) then
        str = str .. " | D"
    end

    return string.sub(str, 3)
end