local module = {}
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local FootstepSounds = require(ReplicatedStorage.Modules.Libs.FootstepSounds)

local ignoreParts = {}

local isOnCooldown = false
local debug = true

function module.updateRaycastParams(character)
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(ignoreParts, part)
        end
    end
    
    if debug then
        print(ignoreParts)
    end
end

local function isIgnorePartsEmpty(a)
    return next(a) == nil
end

function module.shootRayCast(character, humanoidRootPart) -- RayCast that gets the material and sends it to playFootstepSound
    if isOnCooldown then
        return
    end
    
    if isIgnorePartsEmpty(ignoreParts) then warn("<<FootstepModule>> Ignore parts is equaled to zero :(") return end
    
    isOnCooldown = true

    local originPosition = humanoidRootPart.Position
    local direction = -Vector3.yAxis
    local distance = 5
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = ignoreParts
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude

    local raycastResult = Workspace:Raycast(originPosition, direction * distance, raycastParams)

    if debug then
        local rayPart = Instance.new("Part")
        rayPart.Anchored = true
        rayPart.CanCollide = false
        rayPart.Size = Vector3.new(0.1, 0.1, distance)
        rayPart.CFrame = CFrame.new(originPosition, originPosition + direction) * CFrame.new(0, 0, -distance / 2)
        rayPart.BrickColor = BrickColor.new("Bright red")
        rayPart.Material = Enum.Material.Neon
        rayPart.Parent = Workspace

        game.Debris:AddItem(rayPart, 0.1)
    end

    if raycastResult then
        if debug then
            local player = Players:GetPlayerFromCharacter(character)
            ReplicatedStorage.RemoteEvents.Player.SendFootstep:FireClient(player, raycastResult.Instance, raycastResult.Material.Name)
        end
        module.playFootstepSound(character, raycastResult.Material.Name)
    else
        if debug then
            print("Nothing was hit")
        end
    end

    task.delay(0.5, function()
        isOnCooldown = false
    end)
end

function module.playFootstepSound(character, material) -- Plays the sound depending on the material
	local sound = Instance.new("Sound")
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	local materialSound = FootstepSounds:GetTableFromMaterial(material) -- Thanks uglyburger for the function <3
	local humanoid = character:WaitForChild("Humanoid")
	local walkSpeed = humanoid.WalkSpeed
	
    local playbackSpeed = walkSpeed / 12
    
    -- Learn math
    if walkSpeed > 12 then
        playbackSpeed = playbackSpeed * 0.8
    end
	
	sound.Parent = humanoidRootPart
	sound.SoundId = FootstepSounds:GetRandomSound(materialSound)
    sound.PlaybackSpeed = playbackSpeed
    sound.Volume = 0.2
	sound:Play()
	
	sound.Ended:Connect(function()
		sound:Destroy()
	end)
end

function module.allowFootstep(humanoid) -- Check on movement
	local walkSpeed = humanoid.WalkSpeed
	local moveDirection = humanoid.MoveDirection.Magnitude
	local floorMaterial = humanoid.FloorMaterial

	if walkSpeed > 0 and moveDirection > 0 and floorMaterial ~= Enum.Material.Air then
		return true
	end

	return false
end

return module
