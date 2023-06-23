-- UNUSED!!!! (For now...)

FlxInputState = {
    JUST_RELEASED = -1,
    RELEASED = 0,
    PRESSED = 1,
    JUST_PRESSED = 2
}

FlxInput = IFlxInput:extend()

FlxInput.ID = nil

FlxInput.justReleased = false
FlxInput.released = false
FlxInput.justPressed = false
FlxInput.pressed = false

FlxInput.current = FlxInputState.RELEASED
FlxInput.last = FlxInputState.RELEASED

function FlxInput:new(ID)
    self.ID = ID or 0

    return self
end

function FlxInput:press()
    self.last = self.current
    self.current = self.pressed and FlxInputState.PRESSED or FlxInputState.JUST_PRESSED
end

function FlxInput:released()
    self.last = self.current
    self.current = self.released and FlxInputState.JUST_RELEASED or FlxInputState.RELEASED
end

function FlxInput:update()
    if self.last == FlxInputState.JUST_RELEASED and self.current == FlxInputState.JUST_RELEASED then
        self.current = FlxInputState.RELEASED
    elseif self.last == FlxInputState.JUST_PRESSED and self.current == FlxInputState.JUST_PRESSED then
        self.current = FlxInputState.PRESSED
    end

    self.last = self.current
end

function FlxInput:reset()
    self.current = FlxInputState.RELEASED
    self.last = FlxInputState.RELEASED
end

function FlxInput:hasState(state)
    if state == FlxInputState.JUST_RELEASED then
        return self.justReleased
    elseif state == FlxInputState.RELEASED then
        return self.released
    elseif state == FlxInputState.PRESSED then
        return self.pressed
    elseif state == FlxInputState.JUST_PRESSED then
        return self.justPressed
    end
end

function FlxInput:get_justReleased()
    return self.current == FlxInputState.JUST_RELEASED
end

function FlxInput:get_released()
    return self.current == FlxInputState.RELEASED or self.justReleased
end

function FlxInput:get_justPressed()
    return self.current == FlxInputState.JUST_PRESSED
end

function FlxInput:get_pressed()
    return self.current == FlxInputState.PRESSED or self.justPressed
end

