local HitBoxSize=6
local HitBoxTarget="Torso"
game.RunService.RenderStepped:Connect(function()
    for _,a in pairs(game.Workspace.Players:GetChildren())do
        if a.Name~=game.Players.LocalPlayer.Team.Name then
            for _,b in pairs(a:GetChildren())do
                b[HitBoxTarget].Size=Vector3.new(HitBoxSize,HitBoxSize,HitBoxSize)
            end
        end
    end
end)