local Module = {}

-- Services --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Requires --
local Animations = require(script.Animations)
local Values = require(script.Values)
local AnimationMap = require(script.Map)

-- Extra imports --
local localPlayer = Players.LocalPlayer

-- Objects --
local Camera = Workspace.CurrentCamera
local PlrCam = Workspace.Game.PlrCamera:WaitForChild("Desk")
local Chair = Workspace.Map["Office Chair"].Part


-- Updating Camera --
function Module.updateCamera(scale, moveSpeed)
	local mouse = localPlayer:GetMouse()
	local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	local moveVector = Vector3.new((mouse.X - center.X) / scale, (mouse.Y - center.Y) / scale, 10)
	local targetCFrame = PlrCam.CFrame * CFrame.Angles(math.rad(-(mouse.Y - center.Y) / scale), math.rad(-(mouse.X - center.X) / scale), 0)
	Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, moveSpeed * RunService.RenderStepped:Wait())
end

-- Rotate Camera --
function Module.rotateCamera(rotation, turn)
	if Values.TurningAroundCamera and not Values.PlayingAnimation then
		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear)
		local targetCFrame = CFrame.new(45.511, 1.801, -96.011) * CFrame.Angles(0, math.rad(rotation), 0)
		local targetCamCFrame = CFrame.new(45.478, 4.857, -96.03) * CFrame.Angles(0, math.rad(rotation), 0)

		Animations.tweenObject(Chair, tweenInfo, {CFrame = targetCFrame})
		Animations.tweenObject(PlrCam, tweenInfo, {CFrame = targetCamCFrame})
	end
end

function Module.PlayCameraAnimation(animation: string) 
	if Animations[animation] then
		Animations[animation]()
	end
end

function Module.PlayAnimationDependingOnValues(keyPressed)
	if Values.PlayingAnimation then return end

	local cameraSideMap = AnimationMap.animationMap[Values.CameraSide]
	if cameraSideMap then
		local keyAnimations = cameraSideMap[keyPressed]
		if keyAnimations then
			local animationFunc = keyAnimations[Values.CameraOnSide]
			if animationFunc then
				print("Playing animation for key:", keyPressed, "and CameraOnSide:", Values.CameraOnSide)
				animationFunc()
			end
		end
	end
end

function Module.onKeyPress(input)
	if Values.PlayingAnimation then return end

	local key = input.KeyCode.Name

	if key == "W" or key == "S" then
		Module.PlayAnimationDependingOnValues(key)
	end
end

-- Input  --
function Module.handleCameraRotation(input)
	if Values.TurningAroundCamera then
		Values.CanRotate = false

		if input.KeyCode == Enum.KeyCode.A then
			if Values.CameraSide == "Front" then
				Values.CameraSide = "Left"
				Values.CanRotate = true
			elseif Values.CameraSide == "Right" then
				Values.CameraSide = "Front"
				Values.CanRotate = true
			end
		elseif input.KeyCode == Enum.KeyCode.D then
			if Values.CameraSide == "Front" then
				Values.CameraSide = "Right"
				Values.CanRotate = true
			elseif Values.CameraSide == "Left" then
				Values.CameraSide = "Front"
				Values.CanRotate = true
			end
		end

		if Values.CanRotate then
			local rotation = Values.CameraFullRotations[Values.CameraSide]
			local turns = Values.CameraFullTurn[Values.CameraSide]
			Module.rotateCamera(rotation, turns)
		end
	end
end

return Module