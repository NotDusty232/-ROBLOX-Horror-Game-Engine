local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local WalkSpeedChanged = ReplicatedStorage:WaitForChild("RemoteEvents").Player.updateSpeed

local AntiCheat = require(ServerScriptService.Scripts.Server.AntiCheat)

local NORMAL_WALK_SPEED = 12
local SPRINT_WALK_SPEED = 16
local MAX_WALK_SPEED = 30

WalkSpeedChanged.OnServerEvent:Connect(function(player, newWalkSpeed)
	local character = player.Character
	if character then
		local humanoid = character:WaitForChild("Humanoid")

		if newWalkSpeed <= MAX_WALK_SPEED then
			humanoid.WalkSpeed = newWalkSpeed
		else
			AntiCheat.kickMessage(player, 0x01)
		end
	end
end)
