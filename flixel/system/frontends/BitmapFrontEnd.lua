BitmapFrontEnd = class:extend()

BitmapFrontEnd.maxTextureSize = nil

BitmapFrontEnd.whitePixel = nil
BitmapFrontEnd._cache = {
    keys = function() return {} end,
}
BitmapFrontEnd._lastUniqueKeyIndex = 0

function BitmapFrontEnd:new()
    self:reset()

    return self
end

function BitmapFrontEnd:onAssetsReload(_)
    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        if (obj ~= nil and obj.canBeDumped) then
            obj.onAssetsReload()
        end
    end
end

function BitmapFrontEnd:onContext()
    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        if (obj ~= nil and obj.onContext) then
            obj.onContext()
        end
    end
end

function BitmapFrontEnd:dumpCache()
    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        if (obj ~= nil and obj.canBeDumped) then
            obj:dump()
        end
    end
end

function BitmapFrontEnd:undumpCache()
    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        if (obj ~= nil and obj.canBeDumped) then
            obj:undump()
        end
    end
end

function BitmapFrontEnd:checkCache(Key)
    return self.get(Key) ~= nil
end

function BitmapFrontEnd:create(w,h,color,unique,key)
    local unique = unique or false
    return FlxGraphic:fromRectangle(w, h, color, unique, key)
end

function BitmapFrontEnd:add(Graphic, Unique, Key)
    if Graphic.type == "FlxGraphic" then
        return FlxGraphic.fromGraphic(Graphic, Unique, Key)
    elseif Graphic.type == "BitmapData" then
        return FlxGraphic.fromBitmapData(Graphic, Unique, Key)
    end

    return FlxGraphic.fromAssetKey(tostring(Graphic), Unique, Key)
end

function BitmapFrontEnd:addGraphic(graphic)
    self._cache.set(graphic.key, graphic)
    return graphic
end

function BitmapFrontEnd:get(Key)
    return self._cache.get(Key)
end

function BitmapFrontEnd:findKeyForBitmap(bmd)
    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        if (obj ~= nil and obj.bitmap == bmd) then
            return key
        end
    end
    return nil
end

function BitmapFrontEnd:getKeyForClass(source)
    return tostring(source)
end

function BitmapFrontEnd:generateKey(systemKey, userKey, unique)
    local unique = unique or false
    local key = userKey

    if (unique or key == nil) then
        key = self:getUniqueKey(key)
    end

    return key
end

function BitmapFrontEnd:getUniqueKey(baseKey)
    local baseKey = baseKey or "pixels"

    if (self:checkCache(baseKey)) then return baseKey end
    local i = self._lastUniqueKeyIndex
    local uniqueKey = ""
    while (self:checkCache(uniqueKey)) do
        i = i + 1
        uniqueKey = baseKey .. i
    end

    self._lastUniqueKeyIndex = i
    return uniqueKey
end

function BitmapFrontEnd:getKeyWithSpacesAndBorders(baseKey, frameSize, frameSpacing, frameBorder, region)
    local result = baseKey

    if (region ~= nil) then
        result = result .. "_Region:" .. region.x .. "_" .. region.y .. "_" .. region.width .. "_" .. region.height
    end

    if (frameSize ~= nil) then
        result = result .. "_FrameSize:" .. frameSize.x .. "_" .. frameSize.y
    end

    if (frameSpacing ~= nil) then
        result = result .. "_Spaces:" .. frameSpacing.x .. "_" .. frameSpacing.y
    end

    if (frameBorder ~= nil) then
        result = result .. "_Border:" .. frameBorder.x .. "_" .. frameBorder.y
    end

    return result
end

function BitmapFrontEnd:remove(graphic)
    if graphic ~= nil then
        self:removeKey(graphic.key)
        graphic:destroy()
    end
end

function BitmapFrontEnd:removeByKey(key)
    if key ~= nil then
        local obj = self:get(key)
        self:removeKey(key)

        if obj ~= nil then
            obj:destroy()
        end
    end
end

function BitmapFrontEnd:removeIfNoUse(graphic)
    if graphic ~= nil then
        if graphic.useCount <= 0 and not graphic.persist then
            self:remove(graphic)
        end
    end
end

function BitmapFrontEnd:clearCache()
    if (self._cache == nil) then
        self._cache = {
            keys = function() return {} end,
        }
        return
    end

    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        if (obj ~= nil and not obj.persist and obj.useCount <= 0) then
            self:removeKey(key)
            obj:destroy()
        end
    end
end

function BitmapFrontEnd:removeKey(key)
    self._cache.remove(key)
end

function BitmapFrontEnd:reset()
    if (self._cache == nil) then
        self._cache = {
            keys = function() return {} end,
        }
        return
    end

    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        self:removeKey(key)

        if obj ~= nil then
            obj:destroy()
        end
    end
end

function BitmapFrontEnd:clearUnused()
    for i, key in ipairs(self._cache.keys()) do
        local obj = self._cache.get(key)
        if (obj ~= nil and not obj.persist and obj.destroyOnNoUse) then
            self:removeByKey(key)
        end
    end
end

function BitmapFrontEnd:get_maxTextureSize()
    --- use love2d's max texture size
    return love.graphics.getSystemLimits().texturesize
end

function BitmapFrontEnd:get_whitePixel()
    if self._whitePixel == nil then
        local bd = BitmapData:new(10, 10, true, FlxColor.WHITE)
        local graphic = FlxG.bitmap.add(bd, true, "whitePixels")
        graphic.persist = true
        self._whitePixel = graphic.imageFrame.frame
    end

    return self._whitePixel
end

function BitmapFrontEnd:keys()
    return self._cache.keys()
end