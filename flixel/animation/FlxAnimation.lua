FlxAnimation = FlxBaseAnimation:extend()

FlxAnimation.frameRate = nil
FlxAnimation.curFrame = 1
FlxAnimation.numFrames = nil
FlxAnimation.frameDuration = 0
FlxAnimation.finished = true
FlxAnimation.paused = true
FlxAnimation.looped = true
FlxAnimation.loopPoint = 0
FlxAnimation.reversed = false
FlxAnimation.flipX = false
FlxAnimation.flipY = false
FlxAnimation.frames = nil
FlxAnimation._frameTimer = 0

function FlxAnimation:new(parent, name, frames, frameRate, looped, flipX, flipY)
    if name == nil then
        return
    end
    local frameRate = frameRate or 0
    local looped = looped or true
    local flipX = flipX or false
    local flipY = flipY or false

    self.super.new(self, parent, name)

    self.frameRate = frameRate
    self.frames = frames
    self.numFrames = #frames
    
    self.looped = looped
    self.flipX = flipX
    self.flipY = flipY

    self.parent = parent or self
end

function FlxAnimation:destroy()
    self.frames = nil
    self.name = nil
    self.super.destroy(self)
end

function FlxAnimation:play(Force, Reversed, Frame)
    local Frame = Frame or 0
    if not Force and not self.finished and self.reversed == Reversed then
        self.paused = false
        return
    end
    self.reversed = Reversed
    self.paused = false
    self._frameTimer = 0
    self.finished = self.frameDuration == 0
    self.numFrames = #self.frames
    local maxFrameIndex = self.numFrames - 1
    if Frame < 0 then
        curFrame = FlxG.random.int(0, maxFrameIndex)
    else
        if Frame > maxFrameIndex then
            Frame = maxFrameIndex
        end
        if self.reversed then
            Frame = maxFrameIndex - Frame
        end
        curFrame = Frame
    end
end

function FlxAnimation:restart()
    self:play(true, self.reversed)
end

function FlxAnimation:stop()
    self.finished = true
    self.paused = true
end

function FlxAnimation:reset()
    self:stop()
    self.curFrame = self.reversed and (self.numFrames - 1) or 0
end

function FlxAnimation:pause()
    self.paused = true
end

function FlxAnimation:reverse()
    self.reversed = not self.reversed
    if self.finished then
        self:play(true, self.reversed)
    end
end

function FlxAnimation:update(elapsed)
    --self.curFrame = self.curFrame + self.frameRate * elapsed

    if self.curFrame < self.numFrames then
        self.curFrame = self.curFrame + self.frameRate * elapsed
    else
        if self.looped then
            self.curFrame = 1
        end
    end
end

function FlxAnimation:getCurrentFrameDuration()
    local curFrameDuration = self.parent:getFrameDuration(self.curFrame)
    if curFrameDuration == 0 then
        curFrameDuration = self.frameDuration
    end
    return curFrameDuration
end

function FlxAnimation:clone(newParent)
    return FlxAnimation:new(newParent, self.name, self.frames, self.frameRate, self.looped, self.flipX, self.flipY)
end

function FlxAnimation:set_frameRate(value)
    self.frameRate = value
    self.frameDuration = (value > 0 and 1 / value or 0)
    return value
end