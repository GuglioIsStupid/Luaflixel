FlxSprite = FlxObject:extend()

FlxSprite.defaultAntialiasing = false

FlxSprite.animation = nil -- TODO: FlxAnimation
FlxSprite.framePixels = nil
FlxSprite.useFramePixels = false
FlxSprite.antialiasing = FlxSprite.defaultAntialiasing
FlxSprite.dirty = true
FlxSprite.pixels = nil

FlxSprite.frame = 0
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

FlxSprite.blend = "normal"

FlxSprite.color = 0xffffff
FlxSprite.colorTransform = nil
FlxSprite.useColorTransform = false

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

function FlxSprite:new(x,y,SimpleGraphic)
    self.super:new(x,y)

    self.useFramePixels = FlxG.renderBlit
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

    if animated then
        -- blehhhhhhhh
    else
        --self.frames = FlxTileFrames.fromGraphic(graph, FlxPoint:get(frameWidth, frameHeight))
    end

    self.graphic = graph

    return self
end

function FlxSprite:draw()
    -- draw image
    love.graphics.draw(self.graphic.bitmap, self.x, self.y, self.angle, self.scale.x, self.scale.y, self.origin.x, self.origin.y)
end