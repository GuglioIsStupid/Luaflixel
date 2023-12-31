RatioScaleMode = BaseScaleMode:extend()

RatioScaleMode.fillScreen = nil

function RatioScaleMode:new(fillScreen)
    self.super.new(self)
    self.fillScreen = fillScreen or false

    return self
end

function RatioScaleMode:updateGameSize(w, h)
    local ratio = FlxG.width / FlxG.height
    local realRatio = w / h

    local scaleY = realRatio < ratio
    if (self.fillScreen) then
        scaleY = not scaleY
    end
end