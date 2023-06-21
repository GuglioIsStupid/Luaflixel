FlxBasic = IFlxDestroyable:extend()

FlxBasic.activeCount = 0
FlxBasic.visibleCount = 0

FlxBasic.idEnumurator = 0
FlxBasic.ID = FlxBasic.idEnumurator + 1

FlxBasic.active = true
FlxBasic.visible = true
FlxBasic.alive = true
FlxBasic.exists = true
FlxBasic.camera = nil
FlxBasic.cameras = {}

FlxBasic.flixelType = nil

FlxBasic._cameras = {}

function FlxBasic:new() end

function FlxBasic:destroy()
    self.exists = false
    self._cameras = nil
end

function FlxBasic:kill()
    self.alive = false
    self.exists = false
end

function FlxBasic:revive()
    self.alive = true
    self.exists = true
end

function FlxBasic:update(dt) end

function FlxBasic:draw() end

function FlxBasic:toString()
    return FlxStringUtil.getDebugString({
        self.active,
        self.visible,
        self.alive,
        self.exists
    })
end

function FlxBasic:set_visible(v)
    self.visible = v
    return self.visible
end

function FlxBasic:set_active(v)
    self.active = v
    return self.active
end

function FlxBasic:set_exists(v)
    self.exists = v
    return self.exists
end

function FlxBasic:set_alive(v)
    self.alive = v
    return self.alive
end

function FlxBasic:get_camera()
    return (self._cameras == nil or #self._cameras == 0) and FlxCamera._defaultCameras[1] or self._cameras[1]
end

function FlxBasic:set_camera(camera)
    if self._cameras == nil then
        self._cameras = {camera}
    else
        self._cameras[1] = camera
    end
    return camera
end

function FlxBasic:get_cameras()
    return (self._cameras == nil) and FlxCamera._defaultCameras or self._cameras
end

function FlxBasic:setCameras(cameras)
    self._cameras = cameras
    return self._cameras
end

FlxType = {}
FlxType.NONE = 0
FlxType.OBJECT = 1
FlxType.GROUP = 2
FlxType.TILEMAP = 3
FlxType.SPRITEGROUP = 4

FlxBasic.flixelType = FlxType.NONE

IFlxBasic = FlxBasic:extend()
IFlxBasic.ID = FlxBasic.ID
IFlxBasic.active = FlxBasic.active
IFlxBasic.visible = FlxBasic.visible
IFlxBasic.alive = FlxBasic.alive
IFlxBasic.exists = FlxBasic.exists

function IFlxBasic:new() end

function IFlxBasic:draw() end
function IFlxBasic:update(dt) end
function IFlxBasic:destroy() end

function IFlxBasic:kill() end
function IFlxBasic:revive() end

function IFlxBasic:toString() end