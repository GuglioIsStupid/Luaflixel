menu = FlxState:extend()

function menu:create()
    self.super.create(self)
    sound = FlxG.sound.load("sound.mp3")
    --FlxG.sound:play(sound)
    print("menu:create()")
    img = FlxSprite(0, 0, "todd.png")
    img:setFrames(
        img:getSparrowAtlas(
            "todd.xml"
        )
    )
    img:addByPrefix("idle", "idle")
    menu:add(img)
    img:play("idle")
end

function menu:update(elapsed)
    self.super.update(self)

    img:update(elapsed)
end