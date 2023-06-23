FlxSprite = FlxObject:extend()

FlxSprite.defaultAntialiasing = false

FlxSprite.animation = FlxAnimationController()
FlxSprite.framePixels = nil
FlxSprite.useFramePixels = false
FlxSprite.antialiasing = FlxSprite.defaultAntialiasing
FlxSprite.dirty = true
FlxSprite.pixels = nil

FlxSprite.frame = 1
FlxSprite.frameWidth = 0
FlxSprite.frameHeight = 0
FlxSprite.numFrames = 0
FlxSprite.frames = nil

FlxSprite.graphic = nil
FlxSprite.bakedRotationAngle = 0
FlxSprite.alpha = 1.0

FlxSprite.facing = FlxDirectionFlags.RIGHT
FlxSprite.flipX = false
FlxSprite.flipY = false

FlxSprite.origin = FlxPoint()
FlxSprite.offset = FlxPoint()
FlxSprite.scale = FlxPoint(1,1)
FlxSprite.shear = FlxPoint()

FlxSprite.blend = "normal"

FlxSprite.color = 0xffffff
FlxSprite.colorTransform = nil
FlxSprite.useColorTransform = false

-- function to convert the colour to rgb
local function toRGB(color)
    local r = bit.band(bit.rshift(color, 16), 0xff)
    local g = bit.band(bit.rshift(color, 8), 0xff)
    local b = bit.band(color, 0xff)
    return r, g, b
end

FlxSprite.clipRect = nil

FlxSprite.shader = nil

FlxSprite._frameGraphic = nil

FlxSprite._facingHorizontalMult = 1
FlxSprite._facingVerticalMult = 1

FlxSprite._flashPoint = nil
FlxSprite._flashRect = nil
FlxSprite._flashRect2 = nil
FlxSprite._flashPointZero = nil
FlxSprite._matrix = nil
FlxSprite._halfSize = nil
FlxSprite._scaledOrigin = nil

FlxSprite.sinAngle = 0
FlxSprite.cosAngle = 1
FlxSprite._angleChanged = true

FlxSprite._facingFlip = {x=false, y=false}

FlxSprite.width = 0
FlxSprite.height = 0

function FlxSprite:new(x,y,SimpleGraphic)
    self.super:new(x,y)

    self.useFramePixels = FlxG.renderBlit
    self.animation = FlxAnimationController(self)
    if SimpleGraphic ~= nil then
        return self:loadGraphic(SimpleGraphic)
    end
end

function FlxSprite:loadGraphic(graphic, animated, frameWidth, frameHeight, unique, key)
    local animated = animated or false
    local frameWidth = frameWidth or 0
    local frameHeight = frameHeight or 0
    local unique = unique or false
    local graph = FlxG.bitmap:add(graphic, unique, key)
    if graph == nil then
        return
    end

    if frameWidth == 0 then
        frameWidth = animated and graph.height or graph.width
        self.frameWidth = (frameWidth > graph.width) and graph.width or frameWidth
    elseif (frameWidth > graph.width) then
        print("[WARNING] Frame width is larger than image width: " .. frameWidth .. " > " .. graph.width)
        self.frameWidth = graph.width
    end

    if frameHeight == 0 then
        frameHeight = animated and graph.height or graph.height
        self.frameHeight = (frameHeight > graph.height) and graph.height or frameHeight
    elseif (frameHeight > graph.height) then
        print("[WARNING] Frame height is larger than image height: " .. frameHeight .. " > " .. graph.height)
        self.frameHeight = graph.height
    end

    self.width = self.frameWidth
    self.height = self.frameHeight

    if animated then
        -- blehhhhhhhh
    else
        --self.frames = FlxTileFrames.fromGraphic(graph, FlxPoint:get(frameWidth, frameHeight))
    end

    self.graphic = graph

    return self
end

function FlxSprite:getSparrowAtlas(atlas)
    return FlxAnimationController:getFramesFromSparrow(self.graphic, love.filesystem.read(atlas))
end

function FlxSprite:setFrames(Frames, saveAnimations)
    local saveAnimations = true
    if saveAnimations then
        local animations = self.animation._animations
        local reverse = false
        local index = 0
        local frameIndex = self.animation.frameIndex
        local currName = nil
        
        if self.animation.curAnim ~= nil then
            reverse = self.animation.curAnim.reversed
            index = self.animation.curAnim.index
            currName = self.animation.curAnim.name
        end

        self.animation._animations = nil
        self.frames = Frames
        self.frame = self.frames.frames[frameIndex]

        if currName ~= nil then
            self.animation:play(currName, false, reverse, index)
        end
    else
        self.frames = Frames
    end

    return self
end

function FlxSprite:getCamera()
    return nil -- temporary
end

function FlxSprite:getCurrentFrame()
    if self.animation._curAnim ~= nil then
        return self.animation._curAnim.frames[math.floor(self.animation._curAnim.curFrame)]
    end
end

function FlxSprite:addByPrefix(name, prefix, frameRate, looped, flipX, flipY)
    self.animation:addByPrefix(name, prefix, frameRate, looped, flipX, flipY)
end

function FlxSprite:update(elapsed)
    self.super:update(elapsed)
    self.animation:update(elapsed)
end

function FlxSprite:draw()
    if self.exists and self.alive and self.graphic.bitmap and (self.alpha > 0 or self.scale.x > 0 or self.scale.y > 0) then
        local cam = self:getCamera() or FlxG.camera
        local x, y = self:getScreenPosition(cam)
        local r = math.rad(self.angle)
        local frame = self:getCurrentFrame()
        local sx, sy = self.scale.x, self.scale.y
        local ox, oy = self.origin.x, self.origin.y
        local kx, ky = self.shear.x, self.shear.y

        local colorR, colorB, colorG = toRGB(self.color)
        love.graphics.setColor(colorR, colorB, colorG, self.alpha)

        local min, mag, anisotropy = self.graphic.bitmap:getFilter()
        local mode = self.antialiasing and "linear" or "nearest"
        self.graphic.bitmap:setFilter(mode, mode, anisotropy)

        if self.flipX then sx = -sx end
        if self.flipY then sy = -sy end

        x = x + ox - self.offset.x
        y = y + oy - self.offset.y

        if frame then
            ox = ox + frame.offset.x
            oy = oy + frame.offset.y
        end
        if not frame then
            love.graphics.draw(self.graphic.bitmap, x, y, r, sx, sy, ox, oy, kx, ky)
        else
            love.graphics.draw(self.graphic.bitmap, frame.quad, x, y, r, sx, sy, ox, oy, kx, ky)
        end
    end
end

function FlxSprite:play(AnimName, Force, Reversed, Frame)
    if self.animation._curAnim ~= nil then
        self.animation:play(AnimName, Force, Reversed, Frame)
    end
end