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

function love.draw()
    FlxG:draw()
end