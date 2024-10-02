-- AnimationModule.lua
local AnimationModule = {}

-- Services --
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

-- Requires --
local AnimationsHandler = require(ReplicatedStorage.Modules.Client.Animations.AnimationsManager)
local Animations = require(ReplicatedStorage.Modules.Client.Animations.Animations)
local ClientAudioManager = require(ReplicatedStorage.Modules.Client.AudioManager)
local InteractionModule = require(ReplicatedStorage.Modules.Office.Interaction)
local Values = require(script.Parent.Values)

-- Objects --
local PlrCam = Workspace.Game.PlrCamera:WaitForChild("Desk", 1)
local Chair = Workspace.Map["Office Chair"].Part
local Camera = Workspace.CurrentCamera
local Door = Workspace.Door.Door
local Door_Knob = Door.Knob

-- Tween --
function AnimationModule.tweenObject(object, tweenInfo, properties)
	local tween = TweenService:Create(object, tweenInfo, properties)
	tween:Play()
end

-- Desk Animation Handler --
function handleDeskAnimation(deskAnimation, cameraCFrame, cameraOrientation, chairCFrame, chairOrientation)
	Values.PlayingAnimation = true
	InteractionModule.setMouseVisible("Hide")

	deskAnimation.Completed:Connect(function()
		Values.PlayingAnimation = false
		InteractionModule.setMouseVisible("Show")
		PlrCam.CFrame = cameraCFrame
		Chair.CFrame = chairCFrame
		Chair.Orientation = chairOrientation

		if cameraOrientation then
			PlrCam.Orientation = cameraOrientation
		end
	end)
end

-- Desk Animations --
function AnimationModule.goUnderDesk()
	if not Values.PlayingAnimation and Values.CameraSide == "Front" then
		if Values.CameraOnSide == "None" then
			Values.TurningAroundCamera = false
			local Animation = Animations.StringAnimations.ChairAnimations.Chair_Animation_IN
			local EndData = AnimationsHandler.getEndModule(Animation)
			
			handleDeskAnimation(AnimationsHandler:PlayStringAnimation(Animation), EndData.Camera_CFrame, nil, EndData.Chair_CFrame, EndData.Chair_Orientation)
			Values.CameraOnSide = "Under_Desk"
		elseif not Values.PlayingAnimation and Values.CameraOnSide == "Under_Desk" then
			local Animation = Animations.StringAnimations.ChairAnimations.Chair_Animation_OUT
			local EndData = AnimationsHandler.getEndModule(Animation)
			
			handleDeskAnimation(AnimationsHandler:PlayStringAnimation(Animation), EndData.Camera_CFrame, EndData.Camera_Orientation, EndData.Chair_CFrame, EndData.Chair_Orientation)
			Values.TurningAroundCamera = true
			Values.CameraOnSide = "None"
		end
	end
end

-- Go To Door Animation --
function AnimationModule.goToDoor()
	Values.TurningAroundCamera = false
	Values.PlayingAnimation = true
	local Animation = Animations.StringAnimations.DoorAnimations.Walking_To_Left_Door
	local EndData = AnimationsHandler.getEndModule(Animation)
	local doorAnimation = AnimationsHandler:PlayStringAnimation(Animation)

	InteractionModule.setMouseVisible("Hide")
	
	AnimationsHandler.setTimePos(doorAnimation, tostring(doorAnimation), {
		[0.35] = function()
			ClientAudioManager:PlaySoundEffect("Player", "FootSteps")
			print("1")
		end,
		[1.22] = function()
			ClientAudioManager.StopAudio("Sounds", "Player", "FootSteps")
			print("2")
		end,
	})

	doorAnimation.Completed:Connect(function()
		InteractionModule.setMouseVisible("Show")
		PlrCam.CFrame = EndData.Camera_CFrame
		PlrCam.Orientation = EndData.Camera_Orientation
		Values.PlayingAnimation = false
		Values.CameraOnSide = "Left_Door"
	end)
end


function HandleDoorAnimation(direction: string)
	if direction == "Peak" then
		Values.PlayingAnimation = true
		local Animation = Animations.StringAnimations.DoorAnimations.Peaking_Left_Door
		local EndData = AnimationsHandler.getEndModule(Animation)
		local Weld = Door.WeldConstraint

		Weld.Enabled = true
		Door_Knob.Anchored = false

		InteractionModule.setMouseVisible("Hide")
		AnimationsHandler:PlayStringAnimation(Animation, false, function()
			ReplicatedStorage.GlobalValues.Office.FlashLight.Value = true
			InteractionModule.setMouseVisible("Show")
			Weld.Enabled = false
			Door_Knob.Anchored = true
			PlrCam.CFrame = EndData.Camera_CFrame
			PlrCam.Orientation = EndData.Camera_Orientation
			Door.CFrame = EndData.Door_CFrame
			Door.Orientation = EndData.Door_Orientation
			Door_Knob.CFrame = EndData.Knob_CFrame
			Door_Knob.Orientation = EndData.Knob_Orientation
			Values.PlayingAnimation = false
			Values.CameraOnSide = "Peaking_Left_Door"
		end)
	elseif direction == "Unpeak" then
		Values.PlayingAnimation = true
		ReplicatedStorage.GlobalValues.Office.FlashLight.Value = false
		local Animation = Animations.StringAnimations.DoorAnimations.Unpeaking_Left_Door
		local EndData = AnimationsHandler.getEndModule(Animation)
		local Weld = Door.WeldConstraint
		
		Weld.Enabled = true
		Door_Knob.Anchored = false
		
		InteractionModule.setMouseVisible("Hide")
		AnimationsHandler:PlayStringAnimation(Animation, false, function()
			InteractionModule.setMouseVisible("Show")
			Weld.Enabled = false
			Door_Knob.Anchored = true
			PlrCam.CFrame = EndData.Camera_CFrame
			PlrCam.Orientation = EndData.Camera_Orientation
			Door.CFrame = EndData.Door_CFrame
			Door.Orientation = EndData.Door_Orientation
			Door_Knob.CFrame = EndData.Knob_CFrame
			Door_Knob.Orientation = EndData.Knob_Orientation
			Values.PlayingAnimation = false
			Values.CameraOnSide = "Left_Door"
		end)
	end
end

function AnimationModule.LeaveDoorReturnToChair()
	Values.TurningAroundCamera = false
	Values.PlayingAnimation = true
	local Animation = Animations.StringAnimations.DoorAnimations.Walking_Away_Left_Door
	local EndData = AnimationsHandler.getEndModule(Animation)

	InteractionModule.setMouseVisible("Hide")
	local animation = AnimationsHandler:PlayStringAnimation(Animation, false, function()
		InteractionModule.setMouseVisible("Show")
		PlrCam.CFrame = EndData.Camera_CFrame
		PlrCam.Orientation = EndData.Camera_Orientation
		Values.PlayingAnimation = false
		Values.CameraOnSide = "None"
		Values.TurningAroundCamera = true
	end)

	AnimationsHandler.setTimePos(animation, tostring(animation), {
		[0.35] = function()
			ClientAudioManager:PlaySoundEffect("Player", "FootSteps")
			print("1")
		end,
		[1.15] = function()
			ClientAudioManager.StopAudio("Sounds", "Player", "FootSteps")
			print("2")
		end,
	})
end


-- Door Animations --
function AnimationModule.DoorAnimations(direction: string)
	HandleDoorAnimation(direction)
end

return AnimationModule
