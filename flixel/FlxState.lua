FlxState = FlxGroup:extend()

FlxState.persistentUpdate = false
FlxState.persistentDraw = true
FlxState.destroySubstates = true

-- The natural background color the cameras default to. In `AARRGGBB` format.
FlxState.bgColor = 0xff000000

FlxState.subState = nil

FlxState._requestedSubState = nil
FlxState._requestSubStateReset = false

FlxState.subStateOpened = nil
FlxState.subStateClosed = nil

FlxState._subStateOpened = nil
FlxState._subStateClosed = nil

function FlxState:create() end

function FlxState:draw()
    if (self.persistentDraw) then
        self.super:draw()
    end
    if (self.subState ~= nil) then
        self.subState:draw()
    end
end

function FlxState:openSubState(SubState)
    self._requestedSubReset = true
    self._requestedSubState = SubState
end

function FlxState:closeSubState()
    self._requestedSubReset = true
end

function FlxState:resetSubState()
    if (self.subState ~= nil) then
        if (self.subState.closeCallback ~= nil) then
            self.subState:closeCallback()
        end
        if (self._subStateClosed ~= nil) then
            self._subStateClosed:dispatch(self.subState)
        end
        if (self.destroySubStates) then
            self.subState:destroy()
        end
    end

    self.subState = self._requestedSubState
    self._requestedSubState = nil

    if (self.subState ~= nil) then
        if (not self.persistentUpdate) then
            FlxG.inputs:onStateSwitch()
        end

        self.subState._parentState = self

        if (not self.subState._created) then
            self.subState._created = true
            self.subState:create()
        end
        if (self.subState.openCallback ~= nil) then
            self.subState:openCallback()
        end
        if (self._subStateOpened ~= nil) then
            self._subStateOpened:dispatch(self.subState)
        end
    end
end

function FlxState:destroy()
    FlxDestroyUtil.destroy(self._subStateOpened)
    FlxDestroyUtil.destroy(self._subStateClosed)

    if (self.subState ~= nil) then
        self.subState:destroy()
        self.substate = nil
    end
    self.super:destroy()
end

function FlxState:switchTo(nextState)
    return true
end

function FlxState:startOutro(onOutroComplete)
    onOutroComplete()
end

function FlxState:onFocusLost() end
function FlxState:onFocus() end

function FlxState:onResize(w, h) end

function FlxState:tryUpdate(elapsed)
    self.super.update(self, elapsed)
    if (self.persistentUpdate or self.substate == nil) then
        self:update(elapsed)
    end

    if (self._requestedSubReset) then
        self:resetSubState()
        self._requestedSubReset = false
    end

    if (self.subState ~= nil) then
        self.subState:tryUpdate(elapsed)
    end
end

function FlxState:get_bgColor()
    return FlxG.cameras.bgColor
end

function FlxState:set_bgColor(v)
    FlxG.cameras.bgColor = v
end

function FlxState:get_subStateOpened()
    if (self._subStateOpened == nil) then
        self._subStateOpened = FlxSignal()
    end
    return self._subStateOpened
end

function FlxState:get_subStateClosed()
    if (self._subStateClosed == nil) then
        self._subStateClosed = FlxSignal()
    end
    return self._subStateClosed
end