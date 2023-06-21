FlxSound = FlxBasic:extend()

FlxSound.x = 0
FlxSound.y = 0

FlxSound.persist = false

FlxSound.name = nil
FlxSound.artist = nil
FlxSound.amplitude = nil
FlxSound.amplitudeLeft = nil
FlxSound.amplitudeRight = nil

FlxSound.autoDestroy = false

FlxSound.onComplete = function() end

FlxSound.pan = 0

FlxSound.playing = false
FlxSound.volume = 1
FlxSound.pitch = 1

FlxSound.time = 0
FlxSound.length = 0

FlxSound.group = FlxSoundGroup

FlxSound.looped = false

FlxSound.loopTime = 0

FlxSound.endTime = nil

FlxSound.fadeTween = nil

FlxSound._sound = nil

FlxSound._paused = false
FlxSound._volume = 1
FlxSound._time = 0

FlxSound._length = 0
FlxSound._pitch = 1
FlxSound._volumeAdjust = 1
FlxSound._target = nil

FlxSound._radius = 0

FlxSound._proximityPan = false

FlxSound._alreadyPaused = false

function FlxSound:new()
    self.super.new(self)
    self:reset()

    return self
end

function FlxSound:reset()
    self:destroy()

    self.x = 0
    self.y = 0

    self._time = 0
    self._paused = false
    self._volume = 1
    self._volumeAdjust = 1
    self.looped = false
    self.loopTime = 0
    self.endTime = 0
    self._target = nil
    self._radius = 0
    self._proximityPan = false
    self.visible = false
    self.amplitude = 0
    self.amplitudeLeft = 0
    self.amplitudeRight = 0
    self.autoDestroy = false
end

function FlxSound:destroy()
    self.exists = false
    self.active = false
    self._target = nil
    self.name = nil
    self.artist = nil

    if (self._sound ~= nil) then
        self._sound = nil
    end

    self.onComplete = function() end

    self.super:destroy()
end

function FlxSound:update(elapsed)
    if not self.playing then
        return
    end

    self._time = self._sound:tell("seconds") * 1000

    local radialMultiplier = 1

    if (self.target ~= nil) then
        local targetPosition = self._target.getPosition()
        radialMultiplier = targetPosition.distanceTo(FlxPoint.weak(self.x, self.y)) / self._radius
        targetPosition.put()
        radialMultiplier = 1 - FlxMath.bound(radialMultiplier, 0, 1)

        if (self._proximityPan) then
            local d = (self.x - self._target.x) / self._radius
        end
    end

    self._volumeAdjust = radialMultiplier
    self:updateTransform()

    if self.endTime ~= nil and self._time >= self.endTime then
        self:stop()
    end
end

function FlxSound:kill()
    self.super.kill(self)
    self:cleanup(false)
end

function FlxSound:loadEmbedded(EmbeddedSound, Looped, AutoDestroy, OnComplete)
    if EmbeddedSound == nil then return self end

    self:cleanup(true)

    self._sound = love.audio.newSource(EmbeddedSound, "static")

    return self:init(Looped, AutoDestroy, OnComplete)
end

function FlxSound:init(Looped, AutoDestroy, OnComplete)
    local Looped = Looped or false
    local AutoDestroy = AutoDestroy or false
    local OnComplete = OnComplete or function() end

    self.looped = Looped
    self.autoDestroy = AutoDestroy
    self:updateTransform()
    self.exists = true
    self.onComplete = OnComplete
    self.pitch = 1
    self._length = (self._sound == nil) and 0 or self._sound:getDuration("seconds") * 1000
    self.endTime = self._length
    self.sound = self._sound
    return self
end

function FlxSound:play(ForceRestart, StartTime, EndTime)
    if not self.exists then return self end

    if FourceRestart then
        self:cleanup(false, true)
    elseif self.playing then
        return self
    end

    if (self.paused) then
        self:resume()
    else
        self:startSound(StartTime)
    end

    self.endTime = EndTime
    return self
end

function FlxSound:resume()
    if not self.playing then return self end

    self._time = self._sound:tell("seconds") * 1000
    self._paused = true
    self:cleanup(false, true)
    return self
end

function FlxSound:stop()
    self:cleanup(self.autoDestroy, true)
end

function FlxSound:updateTransform()
    self.volume = (FlxG.sound.muted and 0 or 1) * FlxG.sound.volume * (self.group ~= nil and self.group.volume or 1) * self._volume * self._volumeAdjust

    if (self._sound ~= nil) then
        self._sound:setVolume(self.volume)
        self._sound:setPitch(self._pitch)
    end
end

function FlxSound:startSound(StartTime)
    if self._sound == nil then return end

    self._time = StartTime or 0
    self._sound:seek(self._time / 1000, "seconds")
    self._sound:setPitch(self._pitch)
    self._sound:setVolume(self.volume)
    self._sound:play()

    self.exists = true
    self.active = true
end

function FlxSound:stopped(_) 
    if self.onComplete ~= nil then self.onComplete() end

    if self.looped then
        self:cleanup(false)
        play(false, self.loopTime, self.endTime)
    else
        self:cleanup(self.autoDestroy)
    end
end

function FlxSound:cleanup(destroySound, resetPosition)
    local resetPosition = resetPosition or true

    if destroySound then
        self:reset()
        return
    end

    self.active = false

    if resetPosition then
        if self._sound ~= nil then
            self._sound:stop()
            self._sound:play()
            self._time = 0
            self._paused = false
        end
    end
end

function FlxSound:onFocus()
    if not self._alreadyPaused then
        self:resume()
    end
end

function FlxSound:onFocusList()
    self._alreadyPaused = self._paused
    self:pause()
end

function FlxSound:set_group(group)
    if self.group ~= group then
        local oldGroup = self.group
        self.group = group

        if oldGroup ~= nil then
            oldGroup:remove(self)
        end

        if group ~= nil then
            group:add(self)
        end

        self:updateTransform()
    end

    return group
end

function FlxSound:get_playing()
    return self._sound:isPlaying()
end

function FlxSound:get_volume()
    return self._volume
end

function FlxSound:set_volume(Volume)
    self._volume = FlxMath.bound(Volume, 0, 1)
    self:updateTransform()
    return Volume
end

function FlxSound:get_pitch()
    return self._pitch
end

function FlxSound:set_pitch(Pitch)
    self._pitch = Pitch or 1
    self:updateTransform()
    return Pitch
end

function FlxSound:get_time()
    return self._time
end

function FlxSound:set_time(time)
    if self.playing then
        self:cleanup(false, true)
        self:startSound(time)
    end
    return self._time == time
end

function FlxSound:get_length()
    return self._length
end

function FlxSound:toString()
    return FlxStringUtil.getDebugString({
        self.playing,
        self.time,
        self.length,
        self.volume
    })
end