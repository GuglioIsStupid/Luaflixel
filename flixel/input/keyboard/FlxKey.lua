FlxKey = class:extend()

FlxKey.ANY = -2
FlxKey.NONE = -1

-- love2d key scan codes, must be lowercase scan codes

FlxKey.A = "a"
FlxKey.B = "b"
FlxKey.C = "c"
FlxKey.D = "d"
FlxKey.E = "e"
FlxKey.F = "f"
FlxKey.G = "g"
FlxKey.H = "h"
FlxKey.I = "i"
FlxKey.J = "j"
FlxKey.K = "k"
FlxKey.L = "l"
FlxKey.M = "m"
FlxKey.N = "n"
FlxKey.O = "o"
FlxKey.P = "p"
FlxKey.Q = "q"
FlxKey.R = "r"
FlxKey.S = "s"
FlxKey.T = "t"
FlxKey.U = "u"
FlxKey.V = "v"
FlxKey.W = "w"
FlxKey.X = "x"
FlxKey.Y = "y"
FlxKey.Z = "z"

FlxKey.ZERO = "0"
FlxKey.ONE = "1"
FlxKey.TWO = "2"
FlxKey.THREE = "3"
FlxKey.FOUR = "4"
FlxKey.FIVE = "5"
FlxKey.SIX = "6"
FlxKey.SEVEN = "7"
FlxKey.EIGHT = "8"
FlxKey.NINE = "9"

FlxKey.PAGEUP = "pageup"
FlxKey.PAGEDOWN = "pagedown"
FlxKey.HOME = "home"
FlxKey.END = "end"
FlxKey.INSERT = "insert"
FlxKey.ESCAPE = "escape"
FlxKey.MINUS = "-"
FlxKey.PLUS = "="
FlxKey.DELETE = "delete"
FlxKey.LBRACKET = "["
FlxKey.RBRACKET = "]"
FlxKey.BACKSLASH = "\\"
FlxKey.CAPSLOCK = "capslock"
FlxKey.SCROLL_LOCK = "scrolllock"
FlxKey.NUMLOCK = "numlock"
FlxKey.SEMICOLON = ";"
FlxKey.QUOTE = "'"
FlxKey.ENTER = "return"
FlxKey.SHIFT = "lshift"
FlxKey.COMMA = ","
FlxKey.PERIOD = "."
FlxKey.SLASH = "/"
FlxKey.GRAVEACCENT = "`"
FlxKey.CONTROL = "lctrl"
FlxKey.ALT = "lalt"
FlxKey.SPACE = "space"
FlxKey.UP = "up"
FlxKey.DOWN = "down"
FlxKey.LEFT = "left"
FlxKey.RIGHT = "right"
FlxKey.TAB = "tab"
FlxKey.WINDOWS = "lgui"
FlxKey.MENU = "menu"
FlxKey.PRINTSCREEN = "printscreen"
FlxKey.BREAK = "pause"
FlxKey.F1 = "f1"
FlxKey.F2 = "f2"
FlxKey.F3 = "f3"
FlxKey.F4 = "f4"
FlxKey.F5 = "f5"
FlxKey.F6 = "f6"
FlxKey.F7 = "f7"
FlxKey.F8 = "f8"
FlxKey.F9 = "f9"
FlxKey.F10 = "f10"
FlxKey.F11 = "f11"
FlxKey.F12 = "f12"
FlxKey.NUMPADZERO = "kp0"
FlxKey.NUMPADONE = "kp1"
FlxKey.NUMPADTWO = "kp2"
FlxKey.NUMPADTHREE = "kp3"
FlxKey.NUMPADFOUR = "kp4"
FlxKey.NUMPADFIVE = "kp5"
FlxKey.NUMPADSIX = "kp6"
FlxKey.NUMPADSEVEN = "kp7"
FlxKey.NUMPADEIGHT = "kp8"
FlxKey.NUMPADNINE = "kp9"
FlxKey.NUMPADMINUS = "kp-"
FlxKey.NUMPADPLUS = "kp+"
FlxKey.NUMPADMULTIPLY = "kp*"
FlxKey.NUMPADSLASH = "kp/"
FlxKey.NUMPADDECIMAL = "kp."

FlxKey.fromStringMap = {
    
}

function FlxKey:fromString(s)
   --[[
    s = s.toUpperCase();
		return fromStringMap.exists(s) ? fromStringMap.get(s) : NONE;
   ]]
   return FlxKey.NONE
end

function FlxKey:toString()
    return ""
end