local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local GameUI = LocalPlayer.PlayerGui:WaitForChild("GameUI", 1)
local ItemsHandler_GUI = require(GameUI:WaitForChild("Modules", 1):WaitForChild("ItemsHandler_GUI", 1))

local OfficeFlashLight = require(ReplicatedStorage.Modules.Items.FlashLightHandler.OfficeFlashlight)
local PlayerFlashLight = require(ReplicatedStorage.Modules.Items.FlashLightHandler.PlayerFlashlight)

local useOfficeFlashlight = false

function setup()
    ItemsHandler_GUI:AddItem("FlashLight")
    ItemsHandler_GUI:ApplyBorder("Arrow", "FlashLight")
    ItemsHandler_GUI.setItemTransparency("FlashLight", 0.9)
    ItemsHandler_GUI.setBorderTransparency("FlashLight", "Arrow", 0.9)
end

function updateFlashLight()
	if useOfficeFlashlight then
		OfficeFlashLight.updateFlashLight()
	else
		PlayerFlashLight.updateFlashLight()
	end
end

function toggleFlashlight()
	if useOfficeFlashlight then
		OfficeFlashLight.toggleFlashlight()
	else
		PlayerFlashLight.toggleFlashlight()
	end
end

setup()

game:GetService("RunService").Heartbeat:Connect(updateFlashLight)

game:GetService("UserInputService").InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F then
        toggleFlashlight()
        ItemsHandler_GUI.setItemTransparency("FlashLight", 0)
        ItemsHandler_GUI.setBorderTransparency("FlashLight", "Arrow", 0)
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.F then
        toggleFlashlight()
        ItemsHandler_GUI.setItemTransparency("FlashLight", 0.9)
        ItemsHandler_GUI.setBorderTransparency("FlashLight", "Arrow", 0.9)
	end
end)

