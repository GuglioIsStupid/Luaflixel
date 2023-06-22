FlxBaseAnimation = IFlxDestroyable:extend()

FlxBaseAnimation.parent = nil
FlxBaseAnimation.string = nil

FlxBaseAnimation.curIndex = 0

function FlxBaseAnimation.set_curIndex(v)
    self.curIndex = v

    if self.parent ~= nil and self.parent._curAnim == self then
        self.parent.frameIndex = v
    end

    return v
end

function FlxBaseAnimation:new(Parent, Name)
    self.parent = Parent
    self.name = Name
end

function FlxBaseAnimation:update(elapsed) end

function FlxBaseAnimation:clone(Parent)
    return nil
end