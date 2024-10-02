local FlashLightHandler = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ClientAudioManager = require(ReplicatedStorage.Modules.Client.AudioManager)
local Interaction = require(ReplicatedStorage.Modules.Office.Interaction)

local flashlightOn = false
local flashlightBattery = 100

function FlashLightHandler.flickerLight(lights, flickerChanceMultiplier)
	local flickerChance = math.clamp((100 - flashlightBattery) / flickerChanceMultiplier, 0, 1)

	if math.random() < flickerChance then
		for _, light in ipairs(lights) do
			if light:IsA("SpotLight") then
				light.Brightness = 1.9
			end
		end
		task.wait(math.random() * 0.1)
		for _, light in ipairs(lights) do
			if light:IsA("SpotLight") then
				light.Brightness = 1.6
			end
		end
		task.wait(math.random() * 0.1)
		for _, light in ipairs(lights) do
			if light:IsA("SpotLight") then
				light.Brightness = 2.22
			end
		end
	end
end

function FlashLightHandler.updateBattery(hasBattery, drainRate, rechargeRate, maxBattery)
	if hasBattery then
		if flashlightOn and flashlightBattery > 0 then
			flashlightBattery = math.clamp(flashlightBattery - drainRate, 0, maxBattery)
		elseif not flashlightOn and flashlightBattery < maxBattery then
			flashlightBattery = math.clamp(flashlightBattery + rechargeRate, 0, maxBattery)
		end
	else
		return
	end
	return flashlightBattery
end

function flashlightEnabled(lights, status)
	for _, light in ipairs(lights) do
		if light:IsA("SpotLight") then
			light.Enabled = status
		end
	end
end

function FlashLightHandler.toggleFlashlight(lights)
	if not flashlightOn then
		flashlightEnabled(lights, true)
		flashlightOn = true
		ClientAudioManager:PlaySoundEffect("Items", "FlashLight_ON")
		Interaction.setMouseVisible("Hide")
	else
		flashlightEnabled(lights, false)
		flashlightOn = false
		ClientAudioManager:PlaySoundEffect("Items", "FlashLight_OFF")
		Interaction.setMouseVisible("Show")
	end
end

return FlashLightHandler