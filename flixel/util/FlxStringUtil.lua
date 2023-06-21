FlxStringUtil = class:extend()

function FlxStringUtil.getDebugString(LabelValuePairs)
    local output = "("
    for pair in pairs(LabelValuePairs) do
        output = output .. (pair.label .. ": ")
        local value = pair.value
        if (value:is(Float)) then
            value = FlxMath.roundDecimal(value, FlxG.debugger.precision)
        end
        output = output .. (value .. " | ")
        pair.put() -- free for recycling
    end
    -- remove the | of the last item, we don't want that at the end
    output = output:sub(0, output.length - 2):trim()
    return (output .. ")")
end