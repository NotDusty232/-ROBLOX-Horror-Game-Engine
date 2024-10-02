local module = {}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local ClientAudioManager = require(ReplicatedStorage.Modules.Client.AudioManager)
local Interaction = require(ReplicatedStorage.Modules.Office.Interaction)

local flashlightEnabled = true
local flashlightOn = false

local plrFlash = ReplicatedStorage.Objects.FlashLightObject:Clone()
plrFlash.Parent = Character:FindFirstChild("Head")

if not plrFlash then
	return error("<<FlashLightModule>> Flashlight Not Found")
end

local smoothness = 0.1

function module.updateFlashLight()
	local head = Character and Character:FindFirstChild("Head")
	if head then
		local mouse = LocalPlayer:GetMouse()
		local targetPosition = (mouse.Hit.p - head.Position).unit
		local currentCFrame = plrFlash.CFrame
		local targetCFrame = CFrame.new(head.Position, head.Position + targetPosition)
		plrFlash.CFrame = currentCFrame:Lerp(targetCFrame, smoothness)
	end
end

function setPlayerFlashLightStatus(status: boolean)
	for _, child in pairs(plrFlash:GetChildren()) do
		if child:IsA("SpotLight") then
			child.Enabled = status
		end
	end
end

function module.toggleFlashlight()
	if not flashlightOn then
		setPlayerFlashLightStatus(true)
		flashlightOn = true
		ClientAudioManager:PlaySoundEffect("Items", "FlashLight_ON")
		Interaction.setMouseVisible("Hide")
	else
		setPlayerFlashLightStatus(false)
		flashlightOn = false
		ClientAudioManager:PlaySoundEffect("Items", "FlashLight_OFF")
		Interaction.setMouseVisible("Show")
	end
end

return module
