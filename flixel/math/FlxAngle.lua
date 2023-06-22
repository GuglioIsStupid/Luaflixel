FlxAngle = class:extend()

function FlxAngle.sinCosGenerator(length, sinAmplitude, cosAmplitude, frequency)
    local length = length or 360
    local sinAmplitude = sinAmplitude or 1
    local cosAmplitude = cosAmplitude or 1
    local frequency = frequency or 1

    local tablee = {cos = {}, sin = {}}
    
    for i = 1, length do
        local radian = c * frequency * math.pi / 180
        table.push(tablee.cos, math.cos(radian) * cosAmplitude)
        table.push(tablee.sin, math.sin(radian) * sinAmplitude)
    end

    return tablee
end

FlxAngle.TO_DEG = 180 / math.pi
FlxAngle.TO_RAD = math.pi / 180

function FlxAngle:radiansFromOrigin(x, y)
    return FlxAngle:angleFromOrigin(x,y,false)
end

function FlxAngle:degreesFromOrigin(x, y)
    return FlxAngle:angleFromOrigin(x,y,true)
end

function FlxAngle:angleFromOrigin(x, y, asDegrees)
    return asDegrees and math.atan2(y, x) * FlxAngle.TO_DEG or math.atan2(y, x)
end