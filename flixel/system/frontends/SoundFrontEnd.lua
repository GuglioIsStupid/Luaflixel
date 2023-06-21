SoundFrontEnd = class:extend()

SoundFrontEnd.music = nil
SoundFrontEnd.muted = false

SoundFrontEnd.volumeHandler = nil

SoundFrontEnd.volumeUpKeys = {FlxKeys.PLUS, FlxKeys.NUMPADPLUS}
SoundFrontEnd.volumeDownKeys = {FlxKeys.MINUS, FlxKeys.NUMPADMINUS}
SoundFrontEnd.muteKeys = {FlxKeys.ZERO, FlxKeys.NUMPADZERO}

SoundFrontEnd.soundTrayEnabled = false

if SoundFrontEnd.soundTrayEnabled then
    SoundFrontEnd.soundTray = FlxSoundTray:new()

    function SoundFrontEnd:get_soundTray()
        return FlxG.game.soundTray
    end
end

SoundFrontEnd.defaultMusicGroup = FlxSoundGroup:new()
SoundFrontEnd.defaultSoundGroup = FlxSoundGroup:new()

SoundFrontEnd.list = FlxTypedGroup:new()

SoundFrontEnd.volume = 1

function SoundFrontEnd:playMusic(embeddedMusic, volume, looped, group)
    if self.music == nil then
        music = FlxSound:new()
    elseif self.music.active then
        self.music:stop()
    end

    music:loadEmbedded(embeddedMusic, looped)
    music.volume = volume or 1
    musuc.persist = true
    music.group = group or self.defaultMusicGroup
    music:play()
end

function SoundFrontEnd.load(embeddedSound, volume, looped, group, autoDestroy, autoPlay, onComplete, onLoad)
    local sound = love.audio.newSource(embeddedSound, "static")
    
    return sound
end

function SoundFrontEnd:loadHelper(sound, volume, group, autoPlay)
    local autoPlay = autoPlay or false

    if autoPlay then
        sound:play()
        print(type(sound))
    end
end

function SoundFrontEnd:play(embeddedSound, volume, looped, group, autoDestroy, onComplete)
    SoundFrontEnd:loadHelper(sound, volume, group, true)

    return sound
end

function SoundFrontEnd:new() return self end