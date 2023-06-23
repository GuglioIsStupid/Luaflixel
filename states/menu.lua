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

    img2 = FlxSprite(0, 0, "todd.png")
    img2:setFrames(
        img2:getSparrowAtlas(
            "todd.xml"
        )
    )
    img2:addByPrefix("idle", "idle")
    menu:add(img2)
    img2:play("idle")

    img.y = 100
    img2.y = 200
    img2.x = 600
end

function menu:update(elapsed)
end