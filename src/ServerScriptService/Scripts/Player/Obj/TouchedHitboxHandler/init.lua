local module = {}

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hitboxes = Workspace.Map.Hitboxes
local PlayAnimation_Server = ReplicatedStorage.RemoteEvents.Backend.PlayAnimation_Server

module.HitboxList = {}

function module:InitializeHitboxes()
	for _, hitbox in pairs(Hitboxes:GetDescendants()) do
		if hitbox:IsA("BasePart") then
			table.insert(self.HitboxList, hitbox)
		end
	end
end

function module:ConnectHitboxTouches()
	for _, hitbox in pairs(self.HitboxList) do
		hitbox.Touched:Connect(function(hit)
			if hit.Parent:FindFirstChildOfClass("Humanoid") then
				self:OnHitboxTouched(hitbox, hit)
			end
		end)
	end
end

function module:OnHitboxTouched(hitbox, hit)
    local character = hit.Parent
    local player = Players:GetPlayerFromCharacter(character)
    
    if player then
        PlayAnimation_Server:FireClient(player, character)
    end
end

return module
