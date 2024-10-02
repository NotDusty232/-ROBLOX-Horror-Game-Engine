local module = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BloodEngine = require(ReplicatedStorage.Modules.Libs.BloodEngine)

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local character = Player.Character

local ignoreParts = {}

function setIgnoreParts()
    for i, v in pairs(character:GetChildren()) do
        if v:IsA("Part") then
            table.insert(ignoreParts, v)
        end
    end
end

function module.CoughBlood()
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    setIgnoreParts()

    local headPosition = head.Position
    local headForward = head.CFrame.LookVector

    local caughBlood = BloodEngine.new({
        Limit = 8,
        Type = "Decal",
        RandomOffset = true,
        OffsetRange = { -30, 30 },
        DropletVelocity = { 2, 3 },
        StartingSize = Vector3.new( 0.5, 0.6, 0.3 ),
        DefaultSize = { 1,4, 1.7 },
        Expansion = true,
        MaximumSize = 4,
        Filter = ignoreParts,
        Tweens = {
            Expand = TweenInfo.new(0, Enum.EasingStyle.Cubic),
        }
    }) 
    caughBlood:EmitAmount(headPosition, headForward, 8)
end

function module.SlowBleedingFromPart(part)
    if not character then return end
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not HumanoidRootPart then return end
    
    setIgnoreParts()
    
    local blood = BloodEngine.new({
        Limit = 5,
        Type = "Decal",
        RandomOffset = false,
        OffsetRange = { 0, 0 },
        DropletVelocity = { 1, 2 },
        StartingSize = Vector3.new(1, 1, 1),
        DefaultSize = { 2, 5 },
        Expansion = false,
        MaximumSize = 10,
        ScaleDown = false,
        Trail = false,
        Filter = ignoreParts,
    })
    
    local downwardDirection = Vector3.new(0, -1, 0)
    blood:Emit(HumanoidRootPart, downwardDirection)
end


return module
