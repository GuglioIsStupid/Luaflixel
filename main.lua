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
        FlxG.sound.volume = FlxG.sound.volume - 0.1
    end
    FlxG.soundTray:show(true)
end

function love.draw()
    FlxG:draw()
    -- print lua memory usage (in mb)
    love.graphics.print("Lua Memory: " .. collectgarbage("count") / 1024 .. "mb" .. 
    "\nGraphics Memory: " .. math.floor(love.graphics.getStats().texturememory / 1048576) .. "mb" ..
    "\nImages Loaded: " .. love.graphics.getStats().images, 0, 0)
end