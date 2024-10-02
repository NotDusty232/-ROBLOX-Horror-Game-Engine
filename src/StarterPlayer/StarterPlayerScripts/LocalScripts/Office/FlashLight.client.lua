local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local FlashlightModule = require(ReplicatedStorage.Modules.Office.FlashLight)

local LocalPlayer = Players.LocalPlayer
local isFlashlightOn = false
local flashLightUI = LocalPlayer.PlayerGui:WaitForChild("GameUI").Items.FlashLight

local excludedFrames = { -- lol
	["LeftDown"] = true,
	["LeftUp"] = true,
	["RightDown"] = true,
	["RightUp"] = true
}

local function updateFlashlightUI()
	local AllowFlashLight = ReplicatedStorage.GlobalValues.Office.FlashLight.Value
	local InOffice = ReplicatedStorage.GlobalValues.Behaviors.InOffice.Value

	--if InOffice and AllowFlashLight then
	--	flashLightUI.Visible = true
	--else
	--	flashLightUI.Visible = false
	--end
end

local function setTransparencyOnFrames(transparency)
	for i, corners in pairs(flashLightUI:GetDescendants()) do
		if not excludedFrames[corners.Name] then
			corners.BackgroundTransparency = transparency
		end
	end
end

local function canToggleFlashlight()
	local AllowFlashLight = ReplicatedStorage.GlobalValues.Office.FlashLight.Value
	local InOffice = ReplicatedStorage.GlobalValues.Behaviors.InOffice.Value

	return AllowFlashLight and InOffice
end

ReplicatedStorage.GlobalValues.Office.FlashLight.Changed:Connect(updateFlashlightUI)
ReplicatedStorage.GlobalValues.Behaviors.InOffice.Changed:Connect(updateFlashlightUI)

--updateFlashlightUI()
--setTransparencyOnFrames(0.9)
--flashLightUI.ImageTransparency = 0.9

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F and not isFlashlightOn then
		if canToggleFlashlight() then
			flashLightUI.ImageTransparency = 0
			
			setTransparencyOnFrames(0)
			
			isFlashlightOn = true
			FlashlightModule.toggleFlashlight(true)
		end
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F and isFlashlightOn then
		if canToggleFlashlight() then
			flashLightUI.ImageTransparency = 0.9
			
			setTransparencyOnFrames(0.9)
			
			isFlashlightOn = false
			FlashlightModule.toggleFlashlight(false)
		end
	end
end)

game:GetService("RunService").RenderStepped:Connect(FlashlightModule.updateFlashLight)
