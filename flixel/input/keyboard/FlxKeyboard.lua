FlxKeyboard = FlxKeyManager:extend()

FlxKeyboard._nativeCorrection = nil

FlxKeyInput = FlxInput:extend()

function FlxKeyboard:new()
    self.super.new(self, FlxKeyList)

    self.preventDefaultKeys = {}

    for i, code in ipairs(FlxKey.fromStringMap) do 
        if code ~= FlxKey.ANY and code ~= FlxKey.NONE then
            local input = FlxKeyInput(code)
            table.push(self._keyListArray, input)
            table.set(self._keyListMap, code, input)
        end
    end

    self._nativeCorrection = {}

    table.set(self._nativeCorrection, "0_64", FlxKey.INSERT)
    table.set(self._nativeCorrection, "0_65", FlxKey.END)
    table.set(self._nativeCorrection, "0_67", FlxKey.PAGEDOWN)
    table.set(self._nativeCorrection, "0_69", FlxKey.NONE)
    table.set(self._nativeCorrection, "0_73", FlxKey.PAGEUP)
    table.set(self._nativeCorrection, "0_266", FlxKey.DELETE)
    table.set(self._nativeCorrection, "123_222", FlxKey.LBRACKET)
    table.set(self._nativeCorrection, "125_187", FlxKey.RBRACKET)
    table.set(self._nativeCorrection, "126_233", FlxKey.GRAVEACCENT)

    table.set(self._nativeCorrection, "0_80", FlxKey.F1)
    table.set(self._nativeCorrection, "0_81", FlxKey.F2)
    table.set(self._nativeCorrection, "0_82", FlxKey.F3)
    table.set(self._nativeCorrection, "0_83", FlxKey.F4)
    table.set(self._nativeCorrection, "0_84", FlxKey.F5)
    table.set(self._nativeCorrection, "0_85", FlxKey.F6)
    table.set(self._nativeCorrection, "0_86", FlxKey.F7)
    table.set(self._nativeCorrection, "0_87", FlxKey.F8)
    table.set(self._nativeCorrection, "0_88", FlxKey.F9)
    table.set(self._nativeCorrection, "0_89", FlxKey.F10)
    table.set(self._nativeCorrection, "0_90", FlxKey.F11)

    table.set(self._nativeCorrection, "48_224", FlxKey.ZERO)
    table.set(self._nativeCorrection, "49_38", FlxKey.ONE)
    table.set(self._nativeCorrection, "50_233", FlxKey.TWO)
    table.set(self._nativeCorrection, "51_34", FlxKey.THREE)
    table.set(self._nativeCorrection, "52_222", FlxKey.FOUR)
    table.set(self._nativeCorrection, "53_40", FlxKey.FIVE)
    table.set(self._nativeCorrection, "54_189", FlxKey.SIX)
    table.set(self._nativeCorrection, "55_232", FlxKey.SEVEN)
    table.set(self._nativeCorrection, "56_95", FlxKey.EIGHT)
    table.set(self._nativeCorrection, "57_231", FlxKey.NINE)

    table.set(self._nativeCorrection, "48_64", FlxKey.NUMPADZERO)
    table.set(self._nativeCorrection, "49_65", FlxKey.NUMPADONE)
    table.set(self._nativeCorrection, "50_66", FlxKey.NUMPADTWO)
    table.set(self._nativeCorrection, "51_67", FlxKey.NUMPADTHREE)
    table.set(self._nativeCorrection, "52_68", FlxKey.NUMPADFOUR)
    table.set(self._nativeCorrection, "53_69", FlxKey.NUMPADFIVE)
    table.set(self._nativeCorrection, "54_70", FlxKey.NUMPADSIX)
    table.set(self._nativeCorrection, "55_71", FlxKey.NUMPADSEVEN)
    table.set(self._nativeCorrection, "56_72", FlxKey.NUMPADEIGHT)
    table.set(self._nativeCorrection, "57_73", FlxKey.NUMPADNINE)

    table.set(self._nativeCorrection, "43_75", FlxKey.NUMPADPLUS)
    table.set(self._nativeCorrection, "45_77", FlxKey.NUMPADMINUS)
    table.set(self._nativeCorrection, "47_79", FlxKey.SLASH)
    table.set(self._nativeCorrection, "46_78", FlxKey.NUMPADPERIOD)
    table.set(self._nativeCorrection, "42_74", FlxKey.NUMPADMULTIPLY)
end

function FlxKeyboard:onKeyUp(key)
    self.super.onKeyUp(self, key)
end

function FlxKeyboard:onKeyDown(key)
    self.super.onKeyDown(self, key)
end

function FlxKeyboard:resolveKeyCode(key)
    return key
end

function FlxKeyboard:record()
    local data = nil

    for i, key in self._keyListArray do
        if key == nil or key.released then
            --continue
            break
        end

        if data == nil then
            data = {}
        end

        table.push(data, key.code)
    end
end