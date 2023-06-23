FlxBaseKeyList = class:extend()

FlxBaseKeyList.ANY = nil
FlxBaseKeyList.NONE = nil

function FlxBaseKeyList:new(status, keyManager)
    self.status = status
    self.keyManager = keyManager
end

function FlxBaseKeyList:check(keyCode)
    return self.keyManager:checkStatus(keyCode, self.status)
end

function FlxBaseKeyList:get_ANY()
    for i, key in self.keyManager._keyListArray do
        if key ~= nil and self:check(key.ID) then
            return true
        end
    end
    return false
end 

function FlxBaseKeyList:get_NONE()
    for i, key in self.keyManager._keyListArray do
        if key ~= nil and self:check(key.ID) then
            return false
        end
    end
    return true
end