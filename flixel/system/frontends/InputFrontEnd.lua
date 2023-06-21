InputFrontEnd = class:extend()

InputFrontEnd.list = {}
InputFrontEnd.resetOnStateSwitch = true

function InputFrontEnd:add(Input)
    for i, input in ipairs(self.list) do
        if input == Input then
            return Input
        end
    end

    table.push(self.list, Input)
    return Input
end

function InputFrontEnd:remove(Input)
    for i, input in ipairs(self.list) do
        if input == Input then
            table.splice(self.list, i, 1)
            return true
        end
    end

    return false
end

function InputFrontEnd:replace(Old, New)
    local success = false
    for i, input in ipairs(self.list) do
        if input == Old then
            self.list[i] = New
            success = true
            break
        end
    end

    if success then
        return New
    end
    return nil
end

function InputFrontEnd:reset()
    for i, input in ipairs(self.list) do
        input:reset()
    end
end

--[[
    @:allow(flixel.FlxG)
    function new() {}
]]

function InputFrontEnd:new()
    return self
end
function InputFrontEnd:update()
    for i, input in ipairs(self.list) do
        input:update()
    end
end

function InputFrontEnd:onFocus()
    for i, input in ipairs(self.list) do
        input:onFocus()
    end
end

function InputFrontEnd:onFocusLost()
    for i, input in ipairs(self.list) do
        input:onFocusLost()
    end
end

function InputFrontEnd:onStateSwitch()
    if (self.resetOnStateSwitch) then
        self:reset()
    end
end

function InputFrontEnd:destroy()
    for i, input in ipairs(self.list) do
        input = FlxDestroyUtil.destroy(input)
    end
end