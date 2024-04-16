--typedef FlxGroup = FlxTypedGroup<FlxBasic>

FlxTypedGroup = FlxBasic:extend()
FlxGroup = FlxTypedGroup

function FlxGroup:overlaps(Callback, Group, X, Y, InScreenSpace, Camera)
    local result = false
    if (Group ~= nil) then
        local i = 0
        local l = Group.length
        local basic = nil

        while (i < l) do
            basic = Group.members[i]

            if (basic ~= nil and Callback(basic, X, Y, InScreenSpace, Camera)) then
                result = true
                break
            end
            i = i + 1
        end
    end
end

function FlxGroup:resolveGroup(ObjectOrGroup)
    local group = nil
    if (ObjectOrGroup ~= nil) then
        if (ObjectOrGroup.flixelType == GROUP) then
            group = ObjectOrGroup
        elseif (ObjectOrGroup.flixelType == SPRITEGROUP) then
            local spriteGroup = ObjectOrGroup
            group = spriteGroup.group
        end
    end
end

FlxGroup.members = {}
FlxGroup.maxSize = 0 -- no max limit
FlxGroup.length = 0

FlxGroup.memberAdded = nil
FlxGroup.memberRemoved = nil

FlxGroup._memberAdded = nil
FlxGroup._memberRemoved = nil

FlxGroup._marker = 0

function FlxGroup:new(MaxSize)
    local MaxSize = MaxSize or 0
    self.super.new()

    self.members = {}
    self.maxSize = math.floor(math.abs(MaxSize))
    self.flixelType = GROUP

    self.visible = true

    return self
end

function FlxGroup:destroy()
    self.super.destroy()

    FlxDestroyUtil.destroy(self._memberAdded)
    FlxDestroyUtil.destroy(self._memberRemoved)

    if (self.members ~= nil) then
        local i = 0
        local basic = nil

        while (i < self.length) do
            basic = self.members[i]

            if (basic ~= nil) then
                basic:destroy()
            end
            i = i + 1
        end

        self.members = nil
    end
end

function FlxGroup:update(elapsed)
    local i = 0
    local basic = nil

    for i = 0, #self.members do
        basic = self.members[i]
        if (basic ~= nil and basic.exists and basic.visible) then
            basic:update(elapsed)
        end
    end
end

function FlxGroup:draw()
    if not self.visible then return false end
    local i = 0
    local basic = nil

    local oldDefaultCameras = FlxCamera._defaultCameras
    if (self.cameras ~= nil) then
        FlxCamera._defaultCameras = self.cameras
    end
    for i = 0, #self.members do
        basic = self.members[i]
        if (basic ~= nil and basic.exists and basic.visible) then
            basic:draw()
        end
    end
end

function FlxGroup:add(Object)
    if (Object == nil) then
        print("[WARNING] Cannot add a `nil` object to a FlxGroup.")
        return nil
    end

    if (table.indexOf(self.members, Object) >= 0) then
        return Object
    end

    local index = self:getFirstNull()
    if index ~= -1 then
        self.members[index] = Object

        if (index >= self.length) then
            self.length = index + 1
        end

        if (self._memberAdded ~= nil) then
            self._memberAdded:dispatch(Object)
        end

        return Object
    end

    if (self.maxSize > 0 and self.length >= self.maxSize) then
        return Object
    end
    
    table.push(self.members, Object)
    self.length = self.length + 1

    if (self._memberAdded ~= nil) then
        self._memberAdded:dispatch(Object)
    end
    return Object
end

function FlxGroup:insert(position, object)
    if object == nil then
        print("[WARNING] Cannot add a `nil` object to a FlxGroup.")
        return nil
    end

    if table.indexOf(self.members, object) >= 0 then
        return object
    end

    if (position > self.length and self.members[position] == nil) then
        self.members[position] = object

        if (self._memberAdded ~= nil) then
            self._memberAdded:dispatch(object)
        end

        return object
    end

    if (self.maxSize > 0 and self.length >= self.maxSize) then
        return object
    end

    self.members:insert(position, object)
    self.length = self.length + 1

    if (self_memberAdded ~= nil) then
        self._memberAdded:dispatch(object)
    end

    return object
end

function FlxGroup:recycle(ObjectClass, ObjectFactory, Force, Revive)
    local Force = Force or false
    local Revive = Revive or false

    local basic = nil

    if (self.maxSize) > 0 then
        if (self.length < self.maxSize) then
            return FlxGroup:recycleCreateObject(ObjectClass, ObjectFactory)
        else
            basic = self.members[self._marker]

            self._marker = self._marker + 1

            if (self._marker >= self.maxSize) then
                self._marker = 0
            end

            if (Revive) then
                basic:revive()
            end

            return basic
        end
    else
        basic = FlxGroup:getFirstAvailable(ObjectClass, Force)

        if (basic ~= nil) then
            if Revive then
                basic:revive()
            end
            return basic
        end

        return FlxGroup:recycleCreateObject(ObjectClass, ObjectFactory)
    end
end

function FlxGroup:recycleCreateObject(ObjectClass, ObjectFactory)
    local object = nil

    if (ObjectFactory ~= nil) then
        object = ObjectFactory()
        self:add(object)
    elseif (ObjectClass ~= nil) then
        object = ObjectClass:new()
        self:add(object)
    end

    return object
end

function FlxGroup:remove(Object, Splice)
    if (self.members == nil) then
        return nil
    end

    local index = table.indexOf(self.members, Object)

    if (index < 0) then
        return nil
    end

    if (Splice) then
        table.splice(self.members, index, 1)
        self.length = self.length - 1
    else
        self.members[index] = nil
    end

    if (self._memberRemoved ~= nil) then
        self._memberRemoved:dispatch(Object)
    end

    return Object
end

function FlxGroup:replace(OldObject, NewObject)
    local index = table.indexOf(self.members, OldObject)
    if index < 0 then
        return nil
    end

    self.members[index] = NewObject

    if (self._memberRemoved ~= nil) then
        self._memberRemoved:dispatch(OldObject)
    end
    if (self._memberAdded ~= nil) then
        self._memberAdded:dispatch(NewObject)
    end

    return NewObject
end

function FlxGroup:sort(Function, Order)
    local Order = Order or FlxSort.ASCENDING

    self.members:sort(Function.bind(Order))
end

function FlxGroup:getFirstAvailable(ObjectClass, Force)
    local Force = Force or false

    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and not basic.exists and (ObjectClass == nil or basic:is(ObjectClass))) then
            if (Force and basic.class ~= ObjectClass) then
                i = i + 1
                goto continue
            end

            return basic
        end

        ::continue::
        i = i + 1
    end

    return nil
end

function FlxGroup:getFirstNull()
    local i = 0

    while (i < self.length) do
        if (self.members[i] == nil) then
            return i
        end
        i = i + 1
    end

    return -1
end

function FlxGroup:getFirstExisting()
    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and basic.exists) then
            return basic
        end
        i = i + 1
    end

    return nil
end

function FlxGroup:getFirstAlive()
    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and basic.exists and basic.alive) then
            return basic
        end
        i = i + 1
    end

    return nil
end

function FlxGroup:getFirstDead()
    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and not basic.alive) then
            return basic
        end
        i = i + 1
    end

    return nil
end

function FlxGroup:countLiving()
    local i = 0
    local count = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil) then
            if (count < 0) then
                count = 0
            end
            if (basic.exists and basic.alive) then
                count = count + 1
            end
        end
        i = i + 1
    end

    return count
end

function FlxGroup:countDead()
    local i = 0
    local count = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil) then
            if (count < 0) then
                count = 0
            end
            if (not basic.alive) then
                count = count + 1
            end
        end
        i = i + 1
    end

    return count
end

function FlxGroup:getRandom(StartIndex, Length)
    local StartIndex = StartIndex or 0
    local Length = Length or 0

    if (startIndex < 0) then
        startIndex = 0
    end
    if (Length <= 0) then
        Length = self.length
    end

    return FlxG.random.getObject(members, StartIndex, Length)
end

function FlxGroup:clear()
    local length = 0

    if (self._memberRemoved ~= nil) then
        for i = 0, self.length - 1 do
            if (self.members[i] ~= nil) then
                self._memberRemoved:dispatch(self.members[i])
            end
        end
    end

    FlxArrayUtil.clearArray(self.members)
end

function FlxGroup:kill()
    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and basic.exists) then
            basic:kill()
        end
        i = i + 1
    end

    self.super.kill(self)
end

function FlxGroup:revive()
    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and not basic.exists) then
            basic:revive()
        end
        i = i + 1
    end

    self.super.revive(self)
end

function FlxGroup:iterator(filter)
    return FlxTypedGroupIterator:new(self.members, filter)
end

function FlxGroup:forEach(Function, Recurse)
    local Recurse = Recurse or false

    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil) then
            if (Recurse) then
                local group = resolveGroup(basic)

                if (group ~= nil) then
                    group:forEach(Function, Recurse)
                end
            end

            Function(basic)
        end
        i = i + 1
    end
end

function FlxGroup:forEachAlive(Function, Recurse)
    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and basic.exists and basic.alive) then
            if (Recurse) then
                local group = resolveGroup(basic)

                if (group ~= nil) then
                    group:forEachAlive(Function, Recurse)
                end
            end

            Function(basic)
        end
        i = i + 1
    end
end

function FlxGroup:forEachDead(Function, Recurse)
    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and not basic.alive) then
            if (Recurse) then
                local group = resolveGroup(basic)

                if (group ~= nil) then
                    group:forEachDead(Function, Recurse)
                end
            end

            Function(basic)
        end
        i = i + 1
    end
end

function FlxGroup:forEachExists(Function, Recurse)
    local Recurse = Recurse or false

    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and basic.exists) then
            if (Recurse) then
                local group = resolveGroup(basic)

                if (group ~= nil) then
                    group:forEachExists(Function, Recurse)
                end
            end

            Function(basic)
        end
        i = i + 1
    end
end

function FlxGroup:forEachOfType(ObjectClass, Function, Recurse)
    local Recurse = Recurse or false

    local i = 0
    local basic = nil

    while (i < self.length) do
        basic = self.members[i]

        if (basic ~= nil and basic:is(ObjectClass)) then
            if (Recurse) then
                local group = resolveGroup(basic)

                if (group ~= nil) then
                    group:forEachExists(Function, Recurse)
                end
            end

            Function(basic)
        end
        i = i + 1
    end
end

function FlxGroup:set_maxSize(Size)
    self.maxSize = math.abs(Size)

    if (self._marker >= self.maxSize) then
        self._marker = 0
    end

    if (self.maxSize == 0 or self.members == nil or self.maxSize >= self.length) then
        return self.maxSize
    end

    local i = self.maxSize
    local l = self.length
    local basic = nil

    while (i < l) do
        basic = self.members[i]

        if (basic ~= nil) then
            if (self._memberRemoved ~= nil) then
                self._memberRemoved:dispatch(basic)
            end

            basic:destroy()
        end
        i = i + 1
    end

    FlxArrayUtil.setLength(self.members, self.maxSize)
    self.length = #self.members

    return self.maxSize
end

function FlxGroup:get_memberAdded()
    if (self._memberAdded == nil) then
        self._memberAdded = FlxTypedSignal:new()
    end

    return self._memberAdded
end

function FlxGroup:get_memberRemoved()
    if (self._memberRemoved == nil) then
        self._memberRemoved = FlxTypedSignal:new()
    end

    return self._memberRemoved
end

FlxTypedGroupIterator = class:extend()
FlxTypedGroupIterator._groupMembers = {}
FlxTypedGroupIterator._filter = nil
FlxTypedGroupIterator._cursor = 0
FlxTypedGroupIterator._length = 0

function FlxTypedGroupIterator:new(GroupMembers, Filter)
    self._groupMembers = GroupMembers
    self._filter = Filter
    self._cursor = 0
    self._length = #GroupMembers

    return self
end

function FlxTypedGroupIterator:next()
    return FlxTypedGroupIterator:hasNext(self) and self._groupMembers[self._cursor + 1] or nil
end

function FlxTypedGroupIterator:hasNext()
    while (self._cursor < self._length and (self._groupMembers[self._cursor + 1] == nil or self._filter ~= nil and not self._filter(self._groupMembers[self._cursor + 1]))) do
        self._cursor = self._cursor + 1
    end

    return self._cursor < self._length
end