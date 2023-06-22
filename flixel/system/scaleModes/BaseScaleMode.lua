BaseScaleMode = class:extend()

BaseScaleMode.deviceSize = nil
BaseScaleMode.gameSize = nil
BaseScaleMode.scale = nil
BaseScaleMode.offset = FlxPoint()

BaseScaleMode.horizontalAlign = CENTER
BaseScaleMode.verticalAlign = CENTER

function BaseScaleMode:new()
    self.deviceSize = FlxPoint:get()
    self.gameSize = FlxPoint:get()
    self.scale = FlxPoint:get()
    self.offset = FlxPoint:get()

    return self
end

function BaseScaleMode:onMeasure(w,h)
    FlxG.width = FlxG.initialWidth
    FlxG.height = FlxG.initialHeight

    self:updateGameSize(w, h)
    self:updateDeviceSize(w, h)
    self:updateScaleOffset()
    self:updateGamePosition()
end

function BaseScaleMode:updateGameSize(w,h)
end

function BaseScaleMode:updateDeviceSize(w,h)
end

function BaseScaleMode:updateScaleOffset()
    --self:updateOffsetX()
    --self:updateOffsetY()
end

function BaseScaleMode:updateOffsetX()
    if BaseScaleMode.offset.x == FlxHorizontalAlign.LEFT then
        BaseScaleMode.offset.x = 0
    elseif BaseScaleMode.offset.x == FlxHorizontalAlign.CENTER then
        BaseScaleMode.offset.x = math.ceil((self.deviceSize.x - self.gameSize.x) / 2)
    elseif BaseScaleMode.offset.x == FlxHorizontalAlign.RIGHT then
        BaseScaleMode.offset.x = self.deviceSize.x - self.gameSize.x
    end
end

function BaseScaleMode:updateOffsetY()
    if BaseScaleMode.offset.y == FlxVerticalAlign.TOP then
        BaseScaleMode.offset.y = 0
    elseif BaseScaleMode.offset.y == FlxVerticalAlign.CENTER then
        BaseScaleMode.offset.y = math.ceil((self.deviceSize.y - self.gameSize.y) / 2)
    elseif BaseScaleMode.offset.y == FlxVerticalAlign.BOTTOM then
        BaseScaleMode.offset.y = self.deviceSize.y - self.gameSize.y
    end
end

function BaseScaleMode:updateGamePosition()
    if (FlxG.game == nil) then
        return
    end

    FlxG.game.x = self.offset.x
    FlxG.game.y = self.offset.y
end

function set_horizontalAlign(value)
    BaseScaleMode.horizontalAlign = value
    if (self.offset ~= nil) then
        self:updateOffsetX()
        self:updateGamePosition()
    end

    return value
end

function set_verticalAlign(value)
    BaseScaleMode.verticalAlign = value
    if (self.offset ~= nil) then
        self:updateOffsetY()
        self:updateGamePosition()
    end

    return value
end