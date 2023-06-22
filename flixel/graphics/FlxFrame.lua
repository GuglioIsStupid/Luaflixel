FlxFrame = IFlxDestroyable:extend()

function FlxFrame:sort(frames, prefixLength, postfixLength)
    local frames = frames or {}
    local prefixLength = prefixLength or 0
    local postfixLength = postfixLength or 0

    -- sort by name
    frames = table.sort(frames, function(a, b)
        local aName = a.name
        local bName = b.name

        if aName == nil and bName == nil then
            return false
        end

        if aName == nil then
            return true
        end

        if bName == nil then
            return false
        end

        local aPrefix = string.sub(aName, 0, prefixLength)
        local bPrefix = string.sub(bName, 0, prefixLength)

        if aPrefix ~= bPrefix then
            return aPrefix < bPrefix
        end

        local aPostfix = string.sub(aName, #aName - postfixLength, #aName)
        local bPostfix = string.sub(bName, #bName - postfixLength, #bName)

        if aPostfix ~= bPostfix then
            return aPostfix < bPostfix
        end

        return aName < bName
    end)
end