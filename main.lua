function love.load()
    require "modules.overrides"
    class = require 'libs.classic'
    parseXml = require 'libs.xmlparser'
    require "openfl"
    require "flixel"

    require "states.menu"

    -- switch to the menu state
    FlxG:init("LuaFlixel Tests", 1280, 720)
    
    FlxG:switchState(menu)
end

function love.update(dt)
    FlxG:update(dt)
end

function love.keypressed(key)
    if key == "-" then
        if FlxG.sound.muted then
            FlxG.sound.volume = FlxG.sound.lastVolume
            FlxG.sound.muted = false
        end
        FlxG.sound.volume = FlxG.sound.volume - 0.1
        FlxG.soundTray:show(false)
    elseif key == "=" then
        if FlxG.sound.muted then
            FlxG.sound.volume = FlxG.sound.lastVolume
            FlxG.sound.muted = false
        end
        FlxG.sound.volume = FlxG.sound.volume + 0.1
        FlxG.soundTray:show(true)
    elseif key == "0" then
        if not FlxG.sound.muted then
            FlxG.sound.lastVolume = FlxG.sound.volume
            FlxG.sound.volume = 0
            FlxG.sound.muted = true
        else
            FlxG.sound.volume = FlxG.sound.lastVolume
            FlxG.sound.muted = false
        end
        FlxG.soundTray:show(FlxG.sound.muted)
    end
    
end

function love.draw()
    FlxG:draw()
    -- print lua memory usage (in mb)
    love.graphics.print("Lua Memory: " .. collectgarbage("count") / 1024 .. "mb" .. 
    "\nGraphics Memory: " .. math.floor(love.graphics.getStats().texturememory / 1048576) .. "mb" ..
    "\nImages Loaded: " .. love.graphics.getStats().images, 0, 0)
end