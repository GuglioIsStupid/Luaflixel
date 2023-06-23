FlxG = class:extend()

FlxG.autoPause = true
FlxG.fixedTimestep = true
FlxG.timeScale = 1.0
FlxG.worldDivisions = 6
FlxG.camera = nil

FlxG.VERSION = FlxVersion(1, 0, 0)

FlxG.game = nil
FlxG.stage = nil
FlxG.state = nil

FlxG.updateFramerate = 60
FlxG.draFrameRate = 60

FlxG.onMobile = false

FlxG.renderMethod = nil
FlxG.renderBlit = nil
FlxG.renderTile = nil

FlxG.elapsed = 0
FlxG.maxElapsed = 0.1

FlxG.width = nil
FlxG.height = nil

FlxG.scaleMode = RatioScaleMode:new()

FlxG.fullscreen = false

FlxG.worldBounds = FlxRect:new()

FlxG.save = FlxSave:new()

FlxG.mouse = nil

FlxG.keys = nil

FlxG.inputs = InputFrontEnd:new()
FlxG.bitmap = BitmapFrontEnd:new()
FlxG.cameras = CameraFrontEnd:new()

FlxG.keys = nil--FlxKeyboard:new()

FlxG.initialWidth = 0
FlxG.initialHeight = 0

FlxG.sound = SoundFrontEnd:new()
--FlxG.signals = SignalFrontEnd:new()

function FlxG:resizeGame(w,h)
    self.scaleMode:onMeasure(w,h)
end

function FlxG:resizeWindow(w, h)
    self.stage:resize(w, h)
    self.width = w
    self.height = h
end

function FlxG:resetGame()
    self.game._resetGame = true
end

function FlxG:switchState(nextState)
    local stateOnCall = self.state
    self.state = nextState
    self.state:startOutro(
        function()
            if (self.state == stateOnCall) then
                self.state:create()
            else
                self.state:create()
            end
        end
    )
end

function FlxG:update(elapsed)
    self.elapsed = elapsed
    self.inputs:update()
    self.state:tryUpdate(elapsed)
end

function FlxG:init(title, w, h)
    self.width = math.floor(math.abs(w))
    self.height = math.floor(math.abs(h))

    FlxG.initialWidth = w
    FlxG.initialHeight = h

    self:resizeGame(w, h)

    love.window.setMode(w, h, {resizable = true, vsync = true, minwidth = 320, minheight = 240})
    love.window.setTitle(title)
end

function FlxG:draw()
    self.state:draw()
end 