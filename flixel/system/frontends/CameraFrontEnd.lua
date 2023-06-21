CameraFrontEnd = class:extend()

CameraFrontEnd.list = {}

CameraFrontEnd.defaults = {}

CameraFrontEnd.bgColor = 0xff000000

CameraFrontEnd.cameraAdded = FlxTypedSignal:new()
CameraFrontEnd.cameraRemoved = FlxTypedSignal:new()
CameraFrontEnd.cameraResized = FlxTypedSignal:new()

CameraFrontEnd.useBufferLocking = false

CameraFrontEnd._cameraRect = Rectangle()

function CameraFrontEnd:add(NewCamera, DefaultDrawTarget)
    local DefaultDrawTarget = DefaultDrawTarget or true
    FlxG.game.addChildAt(NewCamera.flashSprite, FlxG.game.getChildAtIndex(FlxG.game._inputContainer))

    table.push(self.list, NewCamera)
    if DefaultDrawTarget then
        table.push(self.defaults, NewCamera)
    end

    NewCamera.ID = #self.list
    cameraAdded:dispatch(NewCamera)
    return NewCamera
end

function CameraFrontEnd:remove(Camera, Destroy)
    local index = table.indexOf(self.list, Camera)

    if Camera ~= nil and index ~= -1 then
        FlxG.game.removeChild(Camera.flashSprite)
        table.splice(self.list, index, 1)
        self.defaults.remove(Camera)
    else
        print("[WARNING] CameraFrontEnd:remove() - The camera you attempted to remove is not a part of the game.")
        return
    end

    if (FlxG.renderTile) then
        for i = 1, #self.list do
            self.list[i].ID = i
        end
    end

    if Destroy then Camera:destroy() end

    cameraRemoved:dispatch(Camera)
end

function CameraFrontEnd:setDefaultDrawTarget(camera, value)
    if not self.list:contains(camera) then
        print("[WARNING] CameraFrontEnd:setDefaultDrawTarget() - The specified camera is not part of the game.")
        return
    end

    local index = table.indexOf(self.defaults, camera)

    if (calue and index == -1) then
        table.push(self.defaults, camera)
    elseif not value then
        table.splice(self.defaults, index, 1)
    end
end

function CameraFrontEnd:reset(NewCamera) 
    while #self.list > 0 do
        self:remove(self.list[1])
    end

    if NewCamera == nil then
        NewCamera = FlxCamera:new(0,0,FlxG.width,FlxG.height)
    end
    FlxG.camera = self:add(NewCamera)
    NewCamera.ID = 0

    FlxCamera._defaultCameras = self.defaults
end

function CameraFrontEnd:flash(Color, Duration, onComplete, Force)
    local Color = Color or FlxColor.WHITE
    local Duration = Duration or 1
    local onComplete = onComplete or function() end
    local Force = Force or false
    for i, camera in ipairs(self.list) do
        camera:flash(Color, Duration, onComplete, Force)
    end
end

function CameraFrontEnd:fade(Color, Duration, fadeIn, onComplete, Force)
    local Color = Color or FlxColor.BLACK
    local Duration = Duration or 1
    local fadeIn = fadeIn or false
    local onComplete = onComplete or function() end
    local Force = Force or false
    for i, camera in ipairs(self.list) do
        camera:fade(Color, Duration, fadeIn, onComplete, Force)
    end
end

function CameraFrontEnd:shake(Intensity, Duration, onComplete, Force, Axes)
    local Intensity = Intensity or 0.05
    local Duration = Duration or 0.5
    local onComplete = onComplete or function() end
    local Force = Force or true
    local Axes = Axes or FlxCamera.SHAKE_BOTH_AXES
    for i, camera in ipairs(self.list) do
        camera:shake(Intensity, Duration, onComplete, Force, Axes)
    end
end

function CameraFrontEnd:lock()
    for i, camera in ipairs(self.list) do
        if (camera == nil or not camera.exists or not camera.visible) then 
            return
        end

        if FlxG.renderBlit then
            camera:checkResize()
            if self.useBufferLocking then
                camera.buffer:lock()
            end
        end

        if FlxG.renderTile then 
            camera:clearDrawStack()
            camera.canvas.graphics:clear()
        end

        if FlxG.renderBlit then
            camera:fill(camera.bgColor, camera.useBgAlphaBlending)
            camera.screen.dirty = true
        else
            camera.fill(camera.bgColor.to24Bit(), camera.useBgAlphaBlending, camera.bgColor.alphaFloat)
        end
    end
end

function CameraFrontEnd:render()
    if FlxG.renderTile then
        for i, camera in ipairs(self.list) do
           if camera ~= nil and camera.exists and camera.visible then
                camera:render()
            end
        end
    end
end

function CameraFrontEnd:unlock()
    for i, camera in ipairs(self.list) do
        if camera ~= nil and camera.exists and camera.visible then
            if camera == nil or not camera.exists or not camera.visible then
                return
            end

            camera:drawFX()

            if FlxG.renderBlit then
                if self.useBufferLocking then
                    camera.buffer:unlock()
                end

                camera.screen.dirty = true
            end
        end
    end
end

function CameraFrontEnd:resize()
    for i, camera in ipairs(self.list) do
        camera:onResize()
    end
end

function CameraFrontEnd:get_bgColor()
    return (FlxG.camera == nil) and FlxColor.BLACK or FlxG.camera.bgColor
end

function CameraFrontEnd:set_bgColor(Color)
    for i, camera in ipairs(self.list) do
        camera.bgColor = Color
    end

    return Color
end