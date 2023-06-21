FlxPool = class:extend()

FlxPool.length = 0
FlxPool._pool = {}
FlxPool._class = nil

FlxPool._count = 0

function FlxPool:new(classObj)
    self._class = classObj

    return self
end

function FlxPool:get()
    if (self._count == 0) then
        return self._class:extend()
    end
    return self._pool[self._count - 1]
end

function FlxPool:put(obj)
    if (obj ~= nil) then
        local i = table.indexOf(self._pool, obj)
        if (i == -1 or i >= self._count) then
            obj:destroy()
            self._count = self._count + 1
            self._pool[self._count] = obj
        end
    end
end

function FlxPool:putUnsafe(obj)
    if obj ~= nil then
        obj:destroy()
        self._pool[self._count + 1] = obj
    end
end

function FlxPool:preAllocate(numObjects)
    while (numObjects - 1 > 0) do
        self._pool[self._count + 1] = self._class:new()
    end
end

function FlxPool:clear()
    self._count = 0
    local oldPool = self._pool
    self._pool = {}
    return oldPool
end

function FlxPool:get_length()
    return self._count
end

IFlxPooled = IFlxDestroyable:extend()
function IFlxPooled:put() end

IFlxPool = IFlxDestroyable:extend()
function IFlxPool:preAllocate(numObjects) end
function IFlxPool:clear() end