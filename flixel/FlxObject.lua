FlxObject = FlxBasic:extend()

FlxObject.pixelPerfectPosition = false
FlxObject.SEPERATE_BIAS = 4
FlxObject.LEFT = FlxDirectionFlags.LEFT
FlxObject.RIGHT = FlxDirectionFlags.RIGHT
FlxObject.UP = FlxDirectionFlags.UP
FlxObject.DOWN = FlxDirectionFlags.DOWN
FlxObject.NONE = FlxDirectionFlags.NONE
FlxObject.CEILING = FlxDirectionFlags.CEILING
FlxObject.FLOOR = FlxDirectionFlags.FLOOR
FlxObject.WALL = FlxDirectionFlags.WALL
FlxObject.ANY = FlxDirectionFlags.ANY

FlxObject._firstSeperatedFlxRect = FlxRect:get()
FlxObject._secondSeperatedFlxRect = FlxRect:get()

function FlxObject:seperate(object1, object2)
    local separatedX = self:separateX(object1, object2)
    local separatedY = self:separateY(object1, object2)
    return separatedX or separatedY
end

function FlxObject:updateTouchingFlags(Object1, Object2)
    local touchingX = self:updateTouchingFlagsX(Object1, Object2)
    local touchingY = self:updateTouchingFlagsY(Object1, Object2)
    return touchingX or touchingY
end

function FlxObject:allowCollisionDrag(type, object1, object2)
    return object2.active and object2.moves and
        (type == FlxObject.CEILING or type == FlxObject.FLOOR or type == FlxObject.WALL) and
        (object2.immovable or object2.mass > object1.mass)
end

function FlxObject:computeOverlapX(object1, object2, checkMaxOverlap)
    local checkMaxOverlap = checkMaxOverlap or true

    local overlap = 0
    local obj1delta = object1.x - object1.last.x
    local obj2delta = object2.x - object2.last.x

    if obj1delta ~= obj2delta then
        local obj1deltaAbs = math.abs(obj1delta)
        local obj2deltaAbs = math.abs(obj2delta)

        local obj1rect = FlxObject._firstSeperatedFlxRect:set(
            object1.x - ((obj1delta > 0) and obj1delta or 0),
            object1.last.y,
            object1.width + ((obj1delta > 0) and obj1delta or -obj1delta),
            object1.height
        )
        local obj2rect = FlxObject._secondSeperatedFlxRect:set(
            object2.x - ((obj2delta > 0) and obj2delta or 0),
            object2.last.y,
            object2.width + ((obj2delta > 0) and obj2delta or -obj2delta),
            object2.height
        )

        if ((obj1rect.x + obj1rect.width > obj2rect.x))
            and ((obj1rect.x < obj2rect.x + obj2rect.width))
            and ((obj1rect.y + obj1rect.height > obj2rect.y))
            and ((obj1rect.y < obj2rect.y + obj2rect.height)) then
            local maxOverlap = 0

            if (obj1delta > obj2delta) then 
                overlap = object1.x + object1.width - object2.x
                if ((checkMaxOverlap) and (overlap > maxOverlap))
                    or ((object1.allowCollisions and FlxDirectionFlags.RIGHT) == 0)
                    or ((object2.allowCollisions and FlxDirectionFlags.LEFT) == 0) then
                    overlap = 0
                else
                    object1.touching = object1.touching or FlxDirectionFlags.RIGHT
                    object2.touching = object2.touching or FlxDirectionFlags.LEFT
                end
            elseif (obj1delta < obj2delta) then
                overlap = object1.x - object2.width - object2.x
                if ((checkMaxOverlap) and (-overlap > maxOverlap))
                    or ((object1.allowCollisions and FlxDirectionFlags.LEFT) == 0)
                    or ((object2.allowCollisions and FlxDirectionFlags.RIGHT) == 0) then
                    overlap = 0
                else
                    object1.touching = object1.touching or FlxDirectionFlags.LEFT
                    object2.touching = object2.touching or FlxDirectionFlags.RIGHT
                end
            else
                object1.touching = object1.touching or FlxDirectionFlags.LEFT
                object2.touching = object2.touching or FlxDirectionFlags.RIGHT
            end
            
        end
    end

    return overlap
end

function FlxObject:separateX(object1, object2)
    local immovable1 = object1.immovable
    local immovable2 = object2.immovable
    if immovable1 and immovable2 then
        return false
    end

    if object1.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end
    if object2.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end

    local overlap = self:computeOverlapX(object1, object2, false)
    if overlap ~= 0 then
        local delta1 = object1.x - object1.last.x
        local delta2 = object2.x - object2.last.x
        local vel1 = object1.velocity.x
        local vel2 = object2.velocity.x
        local mass1 = object1.mass
        local mass2 = object2.mass
        local massSum = mass1 + mass2
        local elastisity1 = object1.elastisity
        local elastisity2 = object2.elastisity

        if not immovable1 and not immovable2 then
            object1.x = object1.x - overlap /2
            object2.x = object2.x + overlap /2

            local momentum = mass1 * vel1 + mass2 * vel2
            local newVel1 = (momentum + elastisity1 * mass2 * (vel2-vel1)) / massSum
            local newVel2 = (momentum + elastisity2 * mass1 * (vel1-vel2)) / massSum

            object1.velocity.x = newVel1
            object2.velocity.x = newVel2
        elseif not immovable1 then
            object1.x = object1.x - overlap
            object1.velocity.x = vel2 - vel1 * elastisity2
        elseif not immovable2 then
            object2.x = object2.x + overlap
            object2.velocity.x = vel1 - vel2 * elastisity1
        end

        if (FlxObject:allowCollisionDrag(object1.collisionYDrag, object1, object2) and delta1 > delta2) then
            object1.y = object1.y + (object2.y - object2.last.y)
        elseif (FlxObject:allowCollisionDrag(object2.collisionYDrag, object2, object1) and delta2 > delta1) then
            object2.y = object2.y + (object1.y - object1.last.y)
        end

        return true
    end

    return false
end

function FlxObject:updateTouchingFlagsX(object1, object2)
    if object1.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end
    if object2.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end

    return FlxObject:computeOverlapX(object1, object2, true) ~= 0
end

function FlxObject:computeOverlapY(object1, object2, checkMaxOverlap)
    local checkMaxOverlap = checkMaxOverlap or true

    local overlap = 0
    local obj1delta = object1.y - object1.last.y
    local obj2delta = object2.y - object2.last.y

    if (obj1delta ~= obj2delta) then
        local obj1deltaAbs = math.abs(obj1delta)
        local obj2deltaAbs = math.abs(obj2delta)

        local obj1rect = FlxObject._firstSeperatedFlxRect:set(
            object1.last.x,
            object1.y - ((obj1delta > 0) and obj1delta or 0),
            object1.width,
            object1.height + ((obj1delta > 0) and obj1delta or -obj1delta)
        )
        local obj2rect = FlxObject._secondSeperatedFlxRect:set(
            object2.last.x,
            object2.y - ((obj2delta > 0) and obj2delta or 0),
            object2.width,
            object2.height + ((obj2delta > 0) and obj2delta or -obj2delta)
        )

        if ((obj1rect.x + obj1rect.width > obj2rect.x))
            and ((obj1rect.x < obj2rect.x + obj2rect.width))
            and ((obj1rect.y + obj1rect.height > obj2rect.y))
            and ((obj1rect.y < obj2rect.y + obj2rect.height)) then
            local maxOverlap = 0

            if (obj1delta > obj2delta) then 
                overlap = object1.y + object1.height - object2.y
                if ((checkMaxOverlap) and (overlap > maxOverlap))
                    or ((object1.allowCollisions and FlxDirectionFlags.DOWN) == 0)
                    or ((object2.allowCollisions and FlxDirectionFlags.UP) == 0) then
                    overlap = 0
                else
                    object1.touching = object1.touching or FlxDirectionFlags.DOWN
                    object2.touching = object2.touching or FlxDirectionFlags.UP
                end
            elseif (obj1delta < obj2delta) then
                overlap = object1.y - object2.height - object2.y
                if ((checkMaxOverlap) and (-overlap > maxOverlap))
                    or ((object1.allowCollisions and FlxDirectionFlags.UP) == 0)
                    or ((object2.allowCollisions and FlxDirectionFlags.DOWN) == 0) then
                    overlap = 0
                else
                    object1.touching = object1.touching or FlxDirectionFlags.UP
                    object2.touching = object2.touching or FlxDirectionFlags.DOWN
                end
            else
                object1.touching = object1.touching or FlxDirectionFlags.UP
                object2.touching = object2.touching or FlxDirectionFlags.DOWN
            end
            
        end
    end

    return overlap
end

function FlxObject:separateY(object1, object2)
    local immovable1 = object1.immovable
    local immovable2 = object2.immovable
    if immovable1 and immovable2 then
        return false
    end

    if object1.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end
    if object2.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end

    local overlap = self:computeOverlapY(object1, object2, false)
    if overlap ~= 0 then
        local delta1 = object1.y - object1.last.y
        local delta2 = object2.y - object2.last.y
        local vel1 = object1.velocity.y
        local vel2 = object2.velocity.y
        local mass1 = object1.mass
        local mass2 = object2.mass
        local massSum = mass1 + mass2
        local elastisity1 = object1.elastisity
        local elastisity2 = object2.elastisity

        if not immovable1 and not immovable2 then
            object1.y = object1.y - overlap /2
            object2.y = object2.y + overlap /2

            local momentum = mass1 * vel1 + mass2 * vel2
            local newVel1 = (momentum + elastisity1 * mass2 * (vel2-vel1)) / massSum
            local newVel2 = (momentum + elastisity2 * mass1 * (vel1-vel2)) / massSum

            object1.velocity.y = newVel1
            object2.velocity.y = newVel2
        elseif not immovable1 then
            object1.y = object1.y - overlap
            object1.velocity.y = vel2 - vel1 * elastisity2
            if object2.active and object2.moves and (vel1 > vel2) then
                object1.x = object1.x + (object2.x - object2.last.x)
            end
        elseif not immovable2 then
            object2.y = object2.y + overlap
            object2.velocity.y = vel1 - vel2 * elastisity1
            if object1.active and object1.moves and (vel1 < vel2) then
                object2.x = object2.x + (object1.x - object1.last.x)
            end
        end

        if (FlxObject:allowCollisionDrag(object1.collisionXDrag, object1, object2) and delta1 < delta2) then
            object1.x = object1.x + (object2.x - object2.last.x)
        elseif (FlxObject:allowCollisionDrag(object2.collisionXDrag, object2, object1) and delta1 > delta2) then
            object2.x = object2.x + (object1.x - object1.last.x)
        end

        return true
    end

    return false
end

function FlxObject:updateTouchingFlagsY(object1, object2)
    if object1.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end
    if object2.flixelType == FlxType.TILEMAP then
        --- blehhhhh
    end

    return FlxObject:computeOverlapY(object1, object2, true) ~= 0
end

function FlxObject:getScreenPosition(camera)
    local tx, ty = 0, 0
    if camera then
        tx, ty = camera:getPosition(0,0)
        tx = tx * self.scrollFactor.x
        ty = ty * self.scrollFactor.y
    end
    return self.x + tx, self.y + ty
end

FlxObject.x = 0
FlxObject.y = 0
FlxObject.width = 0
FlxObject.height = 0

FlxObject.pixelPerfectRender = nil
FlxObject.pixelPerfectPosition = true
FlxObject.angle = 0

FlxObject.moves = true
FlxObject.immovable = false

FlxObject.solid = false

FlxObject.scrollfactor = nil
FlxObject.velocity = nil
FlxObject.acceleration = nil
FlxObject.drag = nil
FlxObject.maxVelocity = nil
FlxObject.last = nil

FlxObject.mass = 1
FlxObject.elastisity = 0
FlxObject.angularVelocity = 0
FlxObject.angularAcceleration = 0
FlxObject.angularDrag = 0
FlxObject.maxAngular = 10000
FlxObject.health = 1

FlxObject.touching = FlxDirectionFlags.NONE
FlxObject.wasTouching = FlxDirectionFlags.NONE
FlxObject.allowCollisions = FlxDirectionFlags.ANY

FlxObject.collisionXDrag = FlxObject.IMMOVABLE
FlxObject.collisionYDrag = FlxObject.NEVER

FlxObject.path = nil
FlxObject._point = FlxPoint:get()
FlxObject._rect = FlxRect:get()

function FlxObject:new(x,y,w,h)
    self.super:new()
    self.x = x or 0
    self.y = y or 0
    self.width = w or 0
    self.height = h or 0

    self:initVars()
end

function FlxObject:initVars()
    self.flixelType = FlxType.OBJECT
    self.last = FlxPoint:get(self.x, self.y)
    self.scrollFactor = FlxPoint:get(1.0, 1.0)
    self.pixelPerfectPosition = FlxObject.defaultPixelPerfectPosition

    self:initMotionVars()
end

function FlxObject:initMotionVars()
    self.velocity = FlxPoint:get()
    self.acceleration = FlxPoint:get()
    self.drag = FlxPoint:get()
    self.maxVelocity = FlxPoint:get(10000, 10000)
end

function FlxObject:destroy()
    self.super:destroy()

    self.velocity = FlxDestroyUtil.put(self.velocity)
    self.acceleration = FlxDestroyUtil.put(self.acceleration)
    self.drag = FlxDestroyUtil.put(self.drag)
    self.maxVelocity = FlxDestroyUtil.put(self.maxVelocity)
    self.last = FlxDestroyUtil.put(self.last)
    self.scrollFactor = FlxDestroyUtil.put(self.scrollFactor)
    self._point = FlxDestroyUtil.put(self._point)
    self._rect = FlxDestroyUtil.put(self._rect)
end

function FlxObject:update(elapsed)
    --self.last.set(self.x, self.y)

    if (self.path ~= nil and self.path.active) then
        self.path:update(elapsed)
    end

    if self.moves then
        --self:updateMotion(elapsed)
    end

    self.wasTouching = self.touching    
    self.touching = FlxDirectionFlags.NONE
end

function FlxObject:draw()
end