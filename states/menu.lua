menu = FlxState:extend()

function menu:create()
    sound = FlxG.sound.load("sound.mp3")
    FlxG.sound:play(sound)
    print("menu:create()")
end

function menu:update()
    self.super.update(self)
    --print("menu:update()")
end