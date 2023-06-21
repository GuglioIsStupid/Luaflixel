FlxVersion = class:extend()

FlxVersion.major = 0
FlxVersion.minor = 0
FlxVersion.patch = 0

FlxVersion.sha = ""

function FlxVersion:new(Major, Minor, Path)
    self.major = Major or 0
    self.minor = Minor or 0
    self.patch = Patch or 0
end

function FlxVersion:toString()
    local sha = FlxVersion.sha
    if (sha ~= "") then
        sha = "@" .. string.sub(sha, 1, 7)
    end

    return "LuaFlixel " .. self.major .. "." .. self.minor .. "." .. self.patch .. sha
end