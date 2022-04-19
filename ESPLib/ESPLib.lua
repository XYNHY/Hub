-- Credits to deto for the ESP
local plr = game:GetService("Players").LocalPlayer
local cam = workspace.CurrentCamera

function calcdistance(part, part2)
    return math.floor(((part.Position - part2.Position).magnitude) + 0.5)
end

local function GetPartCorners(Part)
	local Size = Part.Size
	return {
        TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
		BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
		TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
		BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position,
	}
end

getgenv().esp = true
getgenv().tracers = true
getgenv().name = true

function DrawESP(part, name, color)
    local pos, vis = cam:WorldToScreenPoint(part.Position)
    
    local text = Drawing.new("Text")
    text.Text = name
    text.Position = Vector2.new(pos.x, pos.y)
    text.Size = 18
    text.Color = color
    text.Outline = true
    text.Center = true
    
    local line = Drawing.new("Line")
    line.From = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
    line.To = Vector2.new(pos.x, pos.y - 20)
    line.Color = color
    line.Thickness = 1.5
    line.Transparency = 0.5
    
    local box = Drawing.new("Quad")
    box.PointA = Vector2.new()
    box.PointB = Vector2.new()
    box.PointC = Vector2.new()
    box.PointD = Vector2.new()
    box.Color = color
    box.Thickness = 1.5
    box.Transparency = 1
    
    game:GetService("RunService").Stepped:connect(function()
        pcall(function()
            local descendant = part:IsDescendantOf(workspace)
            if not descendant and text ~= nil and line ~= nil then
                text:Remove()
                line:Remove()
                box:Remove()
            end

            local pos, vis = cam:WorldToScreenPoint(part.Position)
            
            if part ~= nil then
                text.Position = Vector2.new(pos.x, pos.y)
                line.To = Vector2.new(pos.x, pos.y)
                text.Text = name.."\n\n["..calcdistance(game.Players.LocalPlayer.Character.HumanoidRootPart, part).."] ".."["..part.Parent:FindFirstChildOfClass("Model").Name.."]"
            end
            
            if getgenv().esp then
                if getgenv().tracers then
                    if vis then
                        line.Visible = true
                    else 
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
                
                local partcorners = GetPartCorners(part)
                local topright, trvis = cam:WorldToScreenPoint(partcorners.TR)
                local bottomright, brvis = cam:WorldToScreenPoint(partcorners.BR)
                local topleft, tlvis = cam:WorldToScreenPoint(partcorners.TL)
                local bottomleft, blvis = cam:WorldToScreenPoint(partcorners.BL)
                
                if getgenv().name then
                    if (vis or trvis or brvis or tlvis or blvis) then
                        text.Visible = true
                        box.Visible = true
                        box.PointA = Vector2.new(topright.X, topright.Y + 36)
                        box.PointB = Vector2.new(topleft.X, topleft.Y + 36)
                        box.PointC = Vector2.new(bottomleft.X, bottomleft.Y + 36)
                        box.PointD = Vector2.new(bottomright.X, bottomright.Y + 36)
                    else
                        box.Visible = false
                        text.Visible = false
                    end
                else
                    text.Visible = false
                    box.Visible = false
                end
            else
                line.Visible = false
                text.Visible = false
                box.Visible = false
            end
        end)
    end)
end

if getgenv().mainfunc == nil then
    for i, v in pairs(getgc(true)) do
    	if typeof(v) == "table" and rawget(v, "getbodyparts") then
    		getgenv().mainfunc = v
    		break;
    	end
    end
end

game:GetService("RunService").Stepped:connect(function()
    for i,v in pairs(game:GetService("Players"):GetPlayers()) do
        local bodyparts = getgenv().mainfunc.getbodyparts(v)
        if bodyparts and type(bodyparts) == "table" and rawget(bodyparts, "rootpart") and bodyparts.rootpart ~= nil then
            v.Character = bodyparts.rootpart.Parent
        end
    end
end)

wait()

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
    if v ~= plr and v.Character and v.Character.Parent then
        if tostring(v.Team) == "Ghosts" then
            DrawESP(v.Character.HumanoidRootPart, v.Name, Color3.fromRGB(255, 100, 0))
        elseif tostring(v.Team) == "Phantoms" then
            DrawESP(v.Character.HumanoidRootPart, v.Name, Color3.fromRGB(0, 100, 255))
        end
    end
end

game:GetService("Workspace").Players.Phantoms.ChildAdded:connect(function(v)
    repeat wait() until game:GetService("Players"):GetPlayerFromCharacter(v) ~= nil
    local plrtochar = game:GetService("Players"):GetPlayerFromCharacter(v)

    DrawESP(plrtochar.Character.HumanoidRootPart, plrtochar.Name, Color3.fromRGB(0, 100, 255))
end)

game:GetService("Workspace").Players.Ghosts.ChildAdded:connect(function(v)
    repeat wait() until game:GetService("Players"):GetPlayerFromCharacter(v) ~= nil
    local plrtochar = game:GetService("Players"):GetPlayerFromCharacter(v)

    DrawESP(plrtochar.Character.HumanoidRootPart, plrtochar.Name, Color3.fromRGB(255, 100, 0))
end)
