local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MoonLight = require(ReplicatedStorage.Modules.Libs.Moonlite)
local Values = require(script.Values)

local Players = game:GetService("Players")
local Camera = game.Workspace.CurrentCamera

local AnimationsTable = {}
local Keyframes = {}

function module.getEndModule(animation)
	local endFindFirstChild = animation:FindFirstChild("End")
	if endFindFirstChild == nil then return end
	local endModule = require(endFindFirstChild)

	if endModule then
		local result = {}

		for key, value in pairs(endModule) do
			if typeof(value) == "CFrame" or typeof(value) == "Vector3" then
				result[key] = value
			end
		end

		return result
	else
		warn("<<AnimationsManager>> Unable to locate or get data from End module, this will cause a error" .. animation)
		return nil
	end
end

function module.setTimePos(animation, animationName, timePos)
	if not Values.Stored_Animations[animationName] then
		Values.Stored_Animations[animationName] = { timePos = timePos }
	else
		for timePosition, cb in pairs(timePos) do
			Values.Stored_Animations[animationName].timePos[timePosition] = cb
		end
	end

	local function RecheckTimePos()
		while Values.Stored_Animations[animationName] do
			wait(0.1) -- Is this even a good idea?
			local currentTimePosition = animation.TimePosition
			local toRemove = {}

			for timePosition, cb in pairs(Values.Stored_Animations[animationName].timePos) do
				if currentTimePosition >= timePosition then
					cb()
					toRemove[timePosition] = true
				end
			end

			for timePosition in pairs(toRemove) do
				Values.Stored_Animations[animationName].timePos[timePosition] = nil
			end
			
			if next(Values.Stored_Animations[animationName].timePos) == nil then
				Values.Stored_Animations[animationName] = nil
				return
			end
		end
	end

	coroutine.wrap(RecheckTimePos)()
end


function module:PlayStringAnimation(animation, loop:boolean?, callback)
	if loop == nil then loop = false end

	local playAnimation = MoonLight.CreatePlayer(animation)
	playAnimation:Play()
	playAnimation.Looped = loop

	AnimationsTable[animation] = playAnimation

	playAnimation.Completed:Connect(function()
		AnimationsTable[animation] = nil
		if callback ~= nil then
			callback()
		end
	end)

	return playAnimation
end


function module:PlayKeyframeAnimation(character, animationId, lockAnimation, loop, callback)
    if loop == nil then loop = false end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        warn("<<AnimationsManager>> Character does not have a Humanoid")
        return
    end

    local animation = Instance.new("Animation")
    animation.AnimationId = animationId
    local animator = humanoid:FindFirstChildOfClass("Animator")

    if not animator then
        animator = Instance.new("Animator")
        animator.Name = "Animator"
        animator.Parent = humanoid
    end

    local animationTrack = animator:LoadAnimation(animation)
    animationTrack.Looped = loop
    animationTrack:Play()

    AnimationsTable[animationId] = animationTrack

    if lockAnimation then
        local player = Players.LocalPlayer
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local oldWalkSpeed = humanoid.WalkSpeed
        local cameraTypeBefore = player.CameraMode
        player.CameraMode = Enum.CameraMode.LockFirstPerson
        humanoid.WalkSpeed = 0

        local head = character:FindFirstChild("Head")
        if head then
            local function updateCamera()
                while animationTrack.IsPlaying do
                    if not head.Parent then break end
                    Camera.CFrame = head.CFrame
                    game:GetService("RunService").RenderStepped:Wait()

                    if animationTrack.TimePosition == animationTrack.Length - 0.1 then
                        animationTrack:AdjustSpeed(0)
                    end
                end
            end

            coroutine.wrap(updateCamera)()
        end

        animationTrack.Stopped:Connect(function()
            AnimationsTable[animationId] = nil

            player.CameraMode = cameraTypeBefore
            humanoid.WalkSpeed = oldWalkSpeed

            if callback then
                callback()
            end
        end)
    end

    return animationTrack
end

function module:StopAnimation(animation) 
	if AnimationsTable[animation] then
		AnimationsTable[animation]:Stop()
		AnimationsTable[animation] = nil
	end
end

return module
