local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local PlayFootStep = ReplicatedStorage.RemoteEvents.Player.PlayFootStep

local FootstepModule = require(script.Parent.Parent.FootstepModule)

PlayFootStep.OnServerEvent:Connect(function(player)
    local character = player.Character
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    if FootstepModule.allowFootstep(humanoid) then
        FootstepModule.shootRayCast(character, humanoidRootPart)
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        local humanoid = character:WaitForChild("Humanoid")
        local humanoidRootPart = character:WaitForChild("HumanoidRootPart") 

        character.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("BasePart") then
                FootstepModule.updateRaycastParams(character)
            end
        end)
    end)
end)