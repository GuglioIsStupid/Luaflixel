FlxGraphic = IFlxDestroyable:extend()
FlxGraphic.cache = {}

function FlxGraphic:createGraphic(bitmap, key, unique, cache)
    local bitmap = bitmap or nil
    local graphic = nil

    --if cache then
        -- blehh not rn
    --else
        graphic = FlxGraphic(nil, bitmap)
        graphic.width = graphic.bitmap:getWidth()
        graphic.height = graphic.bitmap:getHeight()
    --end

    return graphic
end

function FlxGraphic:new(key, bitmap, persist)
    self.key = key or ""
    self.persist = persist or false
    self.bitmap = bitmap or nil
end

function FlxGraphic:fromGraphic(Source, Unique, Key)
    local Key = Key or nil
    local Unique = Unique or false
    local img

    local key = FlxG.bitmap.generateKey(Source.key, Key, Unique)
    -- check if it exists in the cache
    if FlxGraphic.cache[key] ~= nil then
        img = FlxGraphic.cache[key]
    else
        img = love.graphics.newImage(Source)
        FlxGraphic.cache[key] = img
    end
    local graphic = FlxGraphic:createGraphic(img, key, Unique)
    graphic.unique = Unique
    graphic.assetsClass = Source.assetsClass
    graphic.assetsKey = Source.assetsKey
    return FlxG.bitmap:addGraphic(graphic)
end