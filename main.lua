function love.load()
    require "modules.overrides"
    print(table.indexOf)
    class = require 'libs.classic'
    require "openfl"
    require "flixel"

    require "states.menu"

    -- switch to the menu state
    FlxG.game = class:new()
    
    FlxG:switchState(menu)
end

function love.update(dt)
    FlxG:update(dt)
end

function love.draw()

end