FlxKeyManager = IFlxInputManager:extend()

FlxKeyManager.enabled = true
FlxKeyManager.preventDefaultKeys = {}
FlxKeyManager.pressed = nil
FlxKeyManager.justPressed = nil
FlxKeyManager.released = nil
FlxKeyManager.justReleased = nil

FlxKeyManager._keyListArray = {}
FlxKeyManager._keyListMap = {}

function FlxKeyManager:anyPressed(KeyArray)
    return self:CheckKeyArrayState(KeyArray, FlxInputState.PRESSED)
end

function FlxKeyManager:firstPressed()
    for i, key in ipairs(self._keyListArray) do
        if key ~= nil and key.pressed then
            return key.ID
        end
    end
    return -1
end

function FlxKeyManager:firstJustPressed()
    for i, key in ipairs(self._keyListArray) do
        if key ~= nil and key.justPressed then
            return key.ID
        end
    end
    return -1
end

function FlxKeyManager:firstJustReleased()
    for i, key in ipairs(self._keyListArray) do
        if key ~= nil and key.justReleased then
            return key.ID
        end
    end
    return -1
end

function FlxKeyManager:checkStatus(KeyCode, Status)
    if KeyCode == FlxKey.ANY then
        if Status == FlxInputState.PRESSED then
            return self.pressed.ANY
        elseif Status == FlxInputState.JUST_PRESSED then
            return self.justPressed.ANY
        elseif Status == FlxInputState.RELEASED then
            return self.released.ANY
        elseif Status == FlxInputState.JUST_RELEASED then
            return self.justReleased.ANY
        end
    end

    if KeyCode == FlxKey.NONE then
        if Status == FlxInputState.PRESSED then
            return self.pressed.NONE
        elseif Status == FlxInputState.JUST_PRESSED then
            return self.justPressed.NONE
        elseif Status == FlxInputState.RELEASED then
            return self.released.NONE
        elseif Status == FlxInputState.JUST_RELEASED then
            return self.justReleased.NONE
        end
    end

    if self._keyListMap[KeyCode] == nil then
        return false
    end

    return self:checkStatusUnsafe(KeyCode, Status)
end 

function FlxKeyManager:checkStatusUnsafe(KeyCode, Status)
    return self:getKey(KeyCode):hasState(Status)
end

function FlxKeyManager:getIsDown()
    local keysDown = {}

    for i, key in ipairs(self._keyListArray) do
        if key ~= nil and key.pressed then
            table.insert(keysDown, key.ID)
        end
    end

    return keysDown
end

function FlxKeyManager:destroy()
    _keyListArray = {}
    _keyListMap = {}
end

function FlxKeyManager:reset()
    for i, key in ipairs(self._keyListArray) do
        if key ~= nil then
            key:release()
        end
    end
end

function FlxKeyManager:new(createKeyList)
    self.pressed = createKeyList(FlxInputState.PRESSED, self)
    self.released = createKeyList(FlxInputState.RELEASED, self)
    self.justPressed = createKeyList(FlxInputState.JUST_PRESSED, self)
    self.justReleased = createKeyList(FlxInputState.JUST_RELEASED, self)
end

function FlxKeyManager:update()
    for i, key in ipairs(self._keyListArray) do
        if key ~= nil then
            key:update()
        end
    end
end

function FlxKeyManager:checkKeyArrayState(KeyArray, State)
    if KeyArray == nil then
        return false
    end
    for i, key in ipairs(KeyArray) do
        if self:checkStatus(key, State) then
            return true
        end
    end
    return false
end

function FlxKeyManager:onKeyUp(k)
    local c = self:resolveKeyCode(k)
    self:handlePreventDefaultKeys(c, k)

    if self.enabled then
        self:updateKeyStates(c, false)
    end
end

function FlxKeyManager:onKeyDown(k)
    local c = resolveKeyCode(k)
    self:handlePreventDefaultKeys(c, k)

    if self.enabled then
        self:updateKeyStates(c, true)
    end
end

function FlxKeyManager:handlePreventDefaultKeys(keyCode, k)
    local key = self:getKey(keyCode)
    if key ~= nil and self.preventDefaultKeys ~= nil and table.indexOf(self.preventDefaultKeys, key.ID) ~= -1 then
        
    end
end

function FlxKeyManager:inKeyArray(KeyArray, key)
    if KeyArray == nil then
        return false
    else
        local code = self:resolveKeyCode(key)
        for i, key in ipairs(KeyArray) do
            if key == code or key == FlxKey.ANY then
                return true
            end
        end
    end
    return false
end

function FlxKeyManager:resolveKeyCode(key)
    return key
end

function FlxKeyManager:updateKeyStates(KeyCode, Down)
    local key = self:getKey(KeyCode)

    if key ~= nil then
        if Down then
            key:press()
        else
            key:release()
        end
    end
end

function FlxKeyManager:onFocus() end
function FlxKeyManager:onFocusLost() self:reset() end

function FlxKeyManager:getKey(KeyCode)
    return self._keyListMap[KeyCode]
end