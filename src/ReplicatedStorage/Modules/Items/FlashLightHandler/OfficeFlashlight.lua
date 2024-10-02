local OfficeFlashLight = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspaces = game:GetService("Workspace")

local FlashLightConfig = require(ReplicatedStorage.Modules.Configs.Items.FlashlightConfig)
local FlashLightModule = require(script.Parent.Parent.FlashLightHandler)

local plrFlash = ReplicatedStorage.Objects.FlashLight:Clone()
plrFlash.Parent = Workspaces.Game.PlrCamera:WaitForChild("Desk")
local config = FlashLightConfig.OfficeFlashlight

local lights = { plrFlash.InnerRing, plrFlash.OuterRing, plrFlash.CircleRing }

function OfficeFlashLight.updateFlashLight()
	local mouse = game.Players.LocalPlayer:GetMouse()
	local flashlightDirection = (mouse.Hit.p - plrFlash.Position).unit
	plrFlash.CFrame = CFrame.new(plrFlash.Parent.Parent.Desk.Position, plrFlash.Position + flashlightDirection)
	FlashLightModule.flickerLight(lights, config.flickerChanceMultiplier)
	FlashLightModule.updateBattery(true, config.batteryDrainRate, config.batteryRechargeRate, config.maxBattery)
end

function OfficeFlashLight.toggleFlashlight()
	FlashLightModule.toggleFlashlight(lights)
end

return OfficeFlashLight
