local PlayerFlashLight = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FlashLightModule = require(ReplicatedStorage.Modules.Items.FlashLightHandler)
local FlashLightConfig = require(ReplicatedStorage.Modules.Configs.Items.FlashlightConfig)

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local plrFlash = ReplicatedStorage.Objects.FlashLightObject:Clone()
plrFlash.Parent = Character:FindFirstChild("Head")
plrFlash.Transparency = 0

local lights = plrFlash:GetChildren()
local config = FlashLightConfig.PlayerFlashlight

function PlayerFlashLight.updateFlashLight()
	local head = Character:FindFirstChild("Head")
	if head then
		local mouse = LocalPlayer:GetMouse()
		local targetPosition = (mouse.Hit.p - head.Position).unit
		local currentCFrame = plrFlash.CFrame
		local targetCFrame = CFrame.new(head.Position, head.Position + targetPosition)
		plrFlash.CFrame = currentCFrame:Lerp(targetCFrame, config.smoothness)
	end
end

function PlayerFlashLight.toggleFlashlight()
	FlashLightModule.toggleFlashlight(lights)
end

return PlayerFlashLight
