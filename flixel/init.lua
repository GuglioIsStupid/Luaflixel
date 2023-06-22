-- load all files in the flixel folder

path = (...):gsub('%.init$', '') .. "."

require (path .. "util.FlxSignal")

FlxKeys = {
    MINUS = "-",
    NUMPADMINUS = "-",
    PLUS = "+",
    NUMPADPLUS = "+",
    ZERO = "0",
    NUMPADZERO = "num0"
}
require (path .. "util.FlxDestroy")
require (path .. "FlxBasic")
require (path .. "FlxCamera")
require (path .. "group.FlxGroup")
require (path .. "math.FlxAngle")
require (path .. "util.FlxDirection")
require (path .. "util.FlxDirectionFlags")
require (path .. "util.FlxPool")
require (path .. "math.FlxRect")
require (path .. "math.FlxPoint")
require (path .. "math.FlxMath")
require (path .. "FlxObject")
require (path .. "graphics.FlxGraphic")
require (path .. "FlxSprite")

require (path .. "system.frontends.InputFrontEnd")
require (path .. "system.frontends.BitmapFrontEnd")
require (path .. "system.frontends.CameraFrontEnd")

require (path .. "sound.FlxSound")
require (path .. "sound.FlxSoundGroup")
require (path .. "system.frontends.SoundFrontEnd")

require (path .. "util.FlxStringUtil")

require (path .. "util.FlxSave")
--require (path .. "util.FlxPath")

require (path .. "FlxState")
require (path .. "system.FlxVersion")
require (path .. "system.scaleModes.BaseScaleMode")
require (path .. "system.scaleModes.RatioScaleMode")

require (path .. "FlxG")