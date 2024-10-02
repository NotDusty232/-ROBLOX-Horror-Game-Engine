local UIS               = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CameraModule = require(ReplicatedStorage.Modules.Office.Camera)

local deskStatus = "Out"

-- Update Camera
game:GetService("RunService").RenderStepped:Connect(function() 
	if ReplicatedStorage.GlobalValues.Behaviors.InOffice.Value then
		CameraModule.updateCamera(100, 5)
	end
end)

-- Camera Rotation
UIS.InputBegan:Connect(function(input)
	if ReplicatedStorage.GlobalValues.Behaviors.InOffice.Value then
		CameraModule.handleCameraRotation(input)
	end
end)


UIS.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	if ReplicatedStorage.GlobalValues.Behaviors.InOffice.Value then
		CameraModule.onKeyPress(input)
	end
end)