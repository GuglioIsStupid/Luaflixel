menu = FlxState:extend()

function menu:create()
    sound = FlxG.sound.load("sound.mp3")
    --FlxG.sound:play(sound)
    print("menu:create()")
    img = FlxSprite(0, 0, "burger.jpg")
    menu:add(img)
end

function menu:update()
    self.super.update(self)
end