FlxSoundTray = FlxGroup:extend()

FlxSoundTray.active = true
FlxSoundTray._timer = 1
FlxSoundTray._bars  = nil
FlxSoundTray._width = 80
FlxSoundTray.height = 30
FlxSoundTray._defaultScale = 2

FlxSoundTray.volumeUpSound = "flixel/sounds/beep"
FlxSoundTray.volumeDownSound = "flixel/sounds/beep"
FlxSoundTray.silent = false

function FlxSoundTray:init()
    self.super.new(self)

    self.visible = false
    self.scaleX = self._defaultScale
    self.scaleY = self._defaultScale

    local tmp = FlxSprite()
    tmp:makeGraphic(self._width, 30, 0x7F000000)
    tmp:screenCenter("X")
    self:add(tmp)

    --local text = FlxText() -- TODO: FlxText

    local bx, by = 10, 14
    self._bars = {}

    for i = 1, 10 do
        tmp = FlxSprite():makeGraphic(4, i, 0xFFFFFFFF)
        tmp.x = bx + FlxG.width * 0.5 - self._width * 0.5
        tmp.y = by
        bx = bx + 6
        by = by - 1
        self:add(tmp)
        self._bars[i] = tmp
    end

    self.y = -30

    return self
end

function FlxSoundTray:update(MS)
    self.super.update(self, love.timer.getDelta())
    if self._timer > 0 then 
        self._timer = self._timer - (MS) * 4
    elseif self.y >= -self.height then
        self.y = self.y - (MS) * self.height * 0.5

        if self.y < -self.height then
            self.visible = false
            self.active = false
        end
    end
end

function FlxSoundTray:show(up)
    local up = up == nil and false or up
    if not self.silent then
        -- sound
    end

    self._timer = 1
    self.y = 0
    self.visible = true
    self.active = true

    local globalVolume = math.round(FlxG.sound.volume * 10)

    if FlxG.sound.muted then globalVolume = 0 end

    for i = 1, #self._bars do
        if i <= globalVolume then
            self._bars[i].alpha = 1
        else
            self._bars[i].alpha = 0.5
        end
    end
end

function FlxSoundTray:screenCenter()
    self.scaleX = self._defaultScale
    self.scaleY = self._defaultScale

    self.x = (0.5 * (FlxG.width - self._width * self._defaultScale) - FlxG.game.x)
end

function FlxSoundTray:draw()
    print(self.x, self.y)
    love.graphics.translate(self.x, -self.y)
    self.super.draw(self)
    love.graphics.translate(-self.x, -self.y)
end