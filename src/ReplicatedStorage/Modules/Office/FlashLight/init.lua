local FlashLightModule = {}

local Workspaces        = game:GetService("Workspace")
local player            = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer        = player.LocalPlayer
local plrFlash           = ReplicatedStorage.Objects.FlashLight:Clone()

local ClientAudioManager = require(ReplicatedStorage.Modules.Client.AudioManager)
local Interaction = require(ReplicatedStorage.Modules.Office.Interaction)

local innerRing  = plrFlash.InnerRing
local outerRing  = plrFlash.OuterRing
local circleRing = plrFlash.CircleRing

--local flashLightUI = LocalPlayer.PlayerGui:WaitForChild("GameUI").Items.FlashLight

local flashlightEnabled = true
local flashlightOn      = false

local flashlightBattery = 100

if not plrFlash then
	return error("<<FlashLightModule>> Flashlight Not Found")
end

plrFlash.Parent = Workspaces.Game.PlrCamera:WaitForChild("Desk")

function FlashLightModule.flickerLight()
	local flickerChance = math.clamp((100 - flashlightBattery) / 1300, 0, 1) -- TODO: Make a config file that controlls this

	if math.random() < flickerChance then
		innerRing.Brightness = 1.9
		outerRing.Brightness = 1.9
		circleRing.Brightness = 1.9
		task.wait(math.random() * 0.1)
		innerRing.Brightness = 1.6
		outerRing.Brightness = 1.6 
		circleRing.Brightness = 1.6
		task.wait(math.random() * 0.1)
		innerRing.Brightness = 2.22
		outerRing.Brightness = 2.22
		circleRing.Brightness = 2.22
	end
end

function updateFlashLightIcon()
	local value = math.clamp(flashlightBattery, 0, 100)
	local imageColor = (value / 100) * 255
	--flashLightUI.ImageColor3 = Color3.fromRGB(imageColor, imageColor, imageColor)
end

function FlashLightModule.updateFlashLight()
	if flashlightOn then
		local mouse = LocalPlayer:GetMouse()
		local flashlightDirection = (mouse.Hit.p - plrFlash.Position).unit
		plrFlash.CFrame = CFrame.new(plrFlash.Parent.Parent.Desk.Position, plrFlash.Position + flashlightDirection)
		FlashLightModule.flickerLight()
		
		if flashlightBattery > 0 then
			flashlightBattery -= 0.15 -- TODO: Make a config file that controlls this
		end
		updateFlashLightIcon()
	else
		if flashlightBattery < 100 then
			flashlightBattery += 0.15 -- TODO: Make a config file that controlls this
		end
		updateFlashLightIcon()
	end
end

function FlashLightModule.toggleFlashlight()
	if not flashlightOn then
		innerRing.Enabled = true
		outerRing.Enabled = true
		circleRing.Enabled = true
		flashlightOn = true
		ClientAudioManager:PlaySoundEffect("Office", "FlashLight_ON")
		Interaction.setMouseVisible("Hide")
	else
		innerRing.Enabled = false
		outerRing.Enabled = false
		circleRing.Enabled = false
		flashlightOn = false
		ClientAudioManager:PlaySoundEffect("Office", "FlashLight_OFF")
		Interaction.setMouseVisible("Show")
	end
end

return FlashLightModule
