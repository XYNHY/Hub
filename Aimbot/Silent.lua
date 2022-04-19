local Plrs = game:GetService("Players")
local Cam = game:GetService("Workspace").CurrentCamera
local LP = Plr.LocalPlayer
Local MOUSE = LP:GetMouse()

local Logic, CharTable, Trajectory
for I,V in pairs(getgc(true)) do
    if type(V) == "table" then
        if rawget(V, "gammo") then
            Logic = V
        end
    elseif type(V) == "function" then
        if debug.getinfo(V).name == "getbodyparts" then
            CharTable = debug.getupvalue(V, 1)
        elseif debug.getinfo(V).name == "trajectory" then
            Trajectory = V
        end
    end
    if Logic and CharTable and Trajectory then break end
end

local function GetClosestPlr()
    local Max, Close = math.huge -- inf
    for I,V in pairs(Plrs:GetPlayers()) do
        if V ~= LP and V.Team ~= LP.Team and CharTable[V] then
            local Pos, OnScreen = Cam:WorldToScreenPoint(CharTable[V].head.Position)
            if OnScreen then
                local Dist = (Vector2.new(Pos.X, Pos.Y) - Vector2.new(MOUSE.X, MOUSE.Y)).Magnitude
                if Dist < Max then
                    Max = Dist
                    Close = V
                end
            end
        end
    end
    return Close -- returns closest plr
end

local gmt = getrawmetatable(game)
local __index = gmt.__index
setreadonly(gmt, false)-- sets metatable false and unlocks it
MT.__index = newcclosure(function(self, K)
    if not checkcaller() and GameLogic.currentgun and GameLogic.currentgun.data and (self == GameLogic.currentgun.barrel or tostring(self) == "SightMark") and K == "CFrame" then
        local CharChosen = (CharTable[Closest()] and CharTable[Closest()].head)
        if CharChosen then
            local _, Time = Trajectory(self.Position, Vector3.new(0, -workspace.Gravity, 0), CharChosen.Position, GameLogic.currentgun.data.bulletspeed)
            return CFrame.new(self.Position, CharChosen.Position + (Vector3.new(0, -workspace.Gravity / 2, 0)) * (Time ^ 2) + (CharChosen.Velocity * Time))
        end
    end
    return __index(self, K)
end)
setreadonly(MT, true)-- sets metatable true and locks it