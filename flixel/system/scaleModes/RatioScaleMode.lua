RatioScaleMode = BaseScaleMode:extend()

RatioScaleMode.fillScreen = nil

function RatioScaleMode:new(fillScreen)
    self.super.new(self)
    self.fillScreen = fillScreen or false
end

function RatioScaleMode:updateGameSize(w, h)
    local ratio = FlxG.width / FlxG.height
    local realRatio = w / h

    local scaleY = realRatio < ratio
    if (self.fillScreen) then
        scaleY = not scaleY
    end
    
    if (self.scaleY) then
        self.gameSize.x = w
        self.gameSize.y = math.floor(w / ratio)
    else
        self.gameSize.x = math.floor(h * ratio)
        self.gameSize.y = h
    end
end