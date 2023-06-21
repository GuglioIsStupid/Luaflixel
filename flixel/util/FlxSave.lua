FlxSave = IFlxDestroyable:extend()

FlxSave.invalidChars = "[ ~%&\\;:\"',<>?#]+"

function FlxSave:hasInvalidChars(str)
    return self.invalidChars:match(str) ~= nil
end

function FlxSave:new() end