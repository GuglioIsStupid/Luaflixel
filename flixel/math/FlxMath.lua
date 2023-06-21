FlxMath = class:extend()

function FlxMath.RoundDecimal(number, percision)
    local mult = 10^(percision or 0)
    return math.floor(number * mult + 0.5) / mult
end