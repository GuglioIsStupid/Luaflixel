FlxAnimationController = IFlxDestroyable:extend()
FlxAnimationController.frameIndex = -1
FlxAnimationController.frameName = nil
FlxAnimationController.name = nil
FlxAnimationController.paused = nil
FlxAnimationController.finished = nil
FlxAnimationController.numFrames = nil

FlxAnimationController.callback = nil
FlxAnimationController.finishCallback = nil

FlxAnimationController._sprite = nil
FlxAnimationController._curAnim = FlxAnimation()

FlxAnimationController._animations = nil

function FlxAnimationController:new(sprite)
    self._sprite = sprite
    return self
end

function FlxAnimationController:update(elapsed)
    if self._curAnim ~= nil then
        self._curAnim:update(elapsed)
    elseif (self._prerotated ~= nil) then
        self._prerotated.angle = self._sprite.angle
    end
end

function FlxAnimationController:destroy()
    --self:destroyAnimated()
    self._animations = nil
    self.callback = nil
    self._sprite = nil
end

function FlxAnimationController:getFramesFromSparrow(graphic, data)
    local frames = {
        frames = {},
        graphic = graphic,
    }

    local sw, sh = graphic.bitmap:getDimensions()
    for _, c in ipairs(parseXml(data).TextureAtlas.children) do
        if c.name == "SubTexture" then
            table.insert(frames.frames,
                FlxAnimationController:newFrame(
                    c.attrs.name,
                    tonumber(c.attrs.x), tonumber(c.attrs.y),
                    tonumber(c.attrs.width), tonumber(c.attrs.height),
                    sw, sh,
                    tonumber(c.attrs.frameX), tonumber(c.attrs.frameY),
                    tonumber(c.attrs.frameWidth), tonumber(c.attrs.frameHeight)
                )
            )
        end
    end

    return frames
end

function FlxAnimationController:newFrame(name,x,y,w,h,sw,sh,ox,oy,ow,oh)
    local aw, ah = x + w, y + h
    return {
		name = name,
		quad = love.graphics.newQuad(x, y, aw > sw and w - (aw - sw) or w,
			ah > sh and h - (ah - sh) or h, sw, sh),
		width = ow == nil and w or ow,
		height = oh == nil and h or oh,
		offset = { x = ox == nil and 0 or ox, y = oy == nil and 0 or oy }
	}
end

function FlxAnimationController:getFrameDuration(index)
    return self._curAnim.frameDuration or 0
end

function FlxAnimationController:addByPrefix(name, prefix, frameRate, looped, flipX, flipY)
    local frameRate = frameRate or 30
    local looped = looped or true
    local flipX = flipX or false
    local flipY = flipY or false
    local frames = {}
    -- get all frames that start with prefix
    for _, f in ipairs(self._sprite.frames.frames) do
        if string.startsWith(f.name, prefix) then
            table.insert(frames, f)
        end
    end
    local anim = FlxAnimation(self, name, frames, frameRate, looped, flipX, flipY)

    if self._animations == nil then
        self._animations = {}
    end
    self._animations[name] = anim
end

function FlxAnimationController:findByPrefix(prefix)
    local AnimFrames = {}
    for i, frame in ipairs(self._sprite.frames.frames) do
        if (frame.name ~= nil and string.startsWith(frame.name, prefix)) then
            table.push(AnimFrames, frame)
        end
    end

    return AnimFrames
end

function FlxAnimationController:byPrefixHelper(AnimFrames, Prefix)
    local AddTo = {}
    local name = AnimFrames[1].name
    local postIndex = string.find(name, ".", #Prefix)
    local postFix = string.sub(name, postIndex == -1 and #name or postIndex, #name)

    table.sort(AnimFrames, function(a, b)
        return a.name < b.name
    end)

    for i, animFrame in ipairs(AnimFrames) do
        table.insert(AddTo, animFrame)
    end

    return AddTo
end

function FlxAnimationController:play(AnimName, Force, Reversed, Frame)
    local Force = Force or false
    local Reversed = Reversed or false
    local Frame = Frame or 1

    if AnimName == nil then
        if self._curAnim ~= nil then
            self._curAnim:stop()
        end
        self._curAnim = nil
    end

    self.finished = false
    self.paused = false

    if AnimName == nil or self._animations[AnimName] == nil then
        return
    end

    local oldFlipX = false
    local oldFlipY = false

    if self._curAnim ~= nil and AnimName ~= self._curAnim.name then
        oldFlipX = self._curAnim.flipX
        oldFlipY = self._curAnim.flipY
        self._curAnim:stop()
    end
    self._curAnim = self._animations[AnimName]
    self._curAnim:play(Force, Reversed, Frame)

    if oldFlipX ~= self._curAnim.flipX or oldFlipY ~= self._curAnim.flipY then
        self._sprite.dirty = true
    end
end