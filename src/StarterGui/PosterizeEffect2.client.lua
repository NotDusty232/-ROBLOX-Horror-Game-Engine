for i,v in ipairs(game.Lighting:GetChildren()) do
	if v:IsA("ColorCorrectionEffect") then
		v:Destroy()
	end
end
local CCE = Instance.new("ColorCorrectionEffect")
CCE.Brightness = -1
CCE.Contrast = 100
CCE.Saturation = -0.1
CCE.Parent = game.Lighting

local Part = Instance.new("Part")
local Gui = Instance.new("SurfaceGui")
local Frame = Instance.new("Frame")
Part.CastShadow = false
Part.CanCollide = false
Part.CanQuery = false
Part.Anchored = true
Part.Size = Vector3.new(49.15, 32.2, 0.001)
Part.Transparency = 1
Part.Name = "ContrastPart"
Part.Parent = game.Workspace
Gui.Face = Enum.NormalId.Back
Gui.LightInfluence = 0
Gui.Adornee = Part
Gui.Parent = Part
Frame.BackgroundColor3 = Color3.fromRGB(128,128,128)
Frame.BackgroundTransparency = 0.015
Frame.Size = UDim2.fromScale(1,1)
Frame.Parent = Gui



game:GetService("RunService").RenderStepped:Connect(function()
	Part.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(0,0,-0.101)
end)