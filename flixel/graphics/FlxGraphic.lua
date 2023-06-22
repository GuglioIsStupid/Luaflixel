FlxGraphic = IFlxDestroyable:extend()

function FlxGraphic:fromGraphic(Source, Unique, Key)
    if not unique then return Source end

    local key = FlxG.bitmap.generateKey(Source.key, Key, Unique)
    local graphic = FlxGraphic:createGraphic(love.graphics.newImage(Source), key, Unique)
    graphic.unique = Unique
    graphic.assetsClass = Source.assetsClass
    graphic.assetsKey = Source.assetsKey
    return FlxG.bitmap:addGraphic(graphic)
end

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

    local key = FlxG.bitmap.generateKey(Source.key, Key, Unique)
    local graphic = FlxGraphic:createGraphic(love.graphics.newImage(Source), key, Unique)
    graphic.unique = Unique
    graphic.assetsClass = Source.assetsClass
    graphic.assetsKey = Source.assetsKey
    return FlxG.bitmap:addGraphic(graphic)
end