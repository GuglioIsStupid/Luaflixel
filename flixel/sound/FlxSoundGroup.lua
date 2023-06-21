FlxSoundGroup = class:extend()

FlxSoundGroup.sounds = {}

FlxSoundGroup.volume = nil

function FlxSoundGroup:new(volume)
    self.volume = volume or 1
    return self
end

function FlxSoundGroup:add(sound)
    if table.indexOf(self.sounds, sound) < 0 then
        table.push(self.sounds, sound)
        return true
    end
    return false
end

function FlxSoundGroup:remove(sound)
    if self.sounds.indexOf(sound) >= 0 then
        return self.sounds:remove(sound)
    end
    return false
end

function FlxSoundGroup:pause()
    for i, sound in ipairs(self.sounds) do
        sound:pause()
    end
end

function FlxSoundGroup:resume()
    for i, sound in ipairs(self.sounds) do
        sound:resume()
    end
end

function FlxSoundGroup:set_volume(volume)
    self.volume = volume
    for i, sound in ipairs(self.sounds) do
        sound:updateTransform()
    end
    return self.volume
end