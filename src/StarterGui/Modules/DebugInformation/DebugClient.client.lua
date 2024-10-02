local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Thanks https://devforum.roblox.com/t/get-client-fps-trough-a-script/282631/14?u=dusty232altlol
local TimeFunction = RunService:IsRunning() and time or os.clock
local LastIteration, Start
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut)

local FrameUpdateTable = {}
local MouseHoveringOnFrame = nil

local DebugInformation = require(script.Parent.Parent.DebugInformation)

local debugInfoFrame = script.Parent.Parent.Parent.DebugInfo.Frame

DebugInformation:CreateDebug("FPS", "")
DebugInformation:CreateDebug("MEMORY", "")
DebugInformation:CreateDebug("FOOTSTEP", "")
DebugInformation:CreateDebug("POSITION", "")
DebugInformation:CreateDebug("ENGINE VERSION", "0.01 [DEVELOPER]")

-- Hover events
local function tweenButtons(v)
    local fadeFrame = v.Fade
    local copyImage = v.Copy
    local hover     = v.Hover

    local tweenInFade = TweenService:Create(fadeFrame, tweenInfo, { BackgroundTransparency = 0.4 })
    local tweenInImage = TweenService:Create(copyImage, tweenInfo, { ImageTransparency = 0 })

    local tweenOutFade = TweenService:Create(fadeFrame, tweenInfo, { BackgroundTransparency = 1 })
    local tweenOutImage = TweenService:Create(copyImage, tweenInfo, { ImageTransparency = 1 })

    local tweenInFadePlaying = false -- Listen, I know this is bad but I ran out of ideas and i'm sick of making 100 tables
    local tweenInImagePlaying = false
    local tweenOutFadePlaying = false
    local tweenOutImagePlaying = false

    hover.MouseEnter:Connect(function()
        if not tweenInFadePlaying then
            tweenInFadePlaying = true
            tweenInFade:Play()
            tweenInImage:Play()
            
            MouseHoveringOnFrame = v.Name

            tweenInFade.Completed:Wait()
            tweenInFadePlaying = false
            tweenInImagePlaying = false
        end
    end)

    hover.MouseLeave:Connect(function()
        if not tweenOutFadePlaying then
            tweenOutFadePlaying = true
            tweenOutFade:Play()
            tweenOutImage:Play()
            
            MouseHoveringOnFrame = nil

            tweenOutFade.Completed:Wait()
            tweenOutFadePlaying = false
            tweenOutImagePlaying = false
        end
    end)
end

-- Check for all the buttons
for i, v in pairs(debugInfoFrame:GetChildren()) do
    local check = table.find(DebugInformation.RequestDebugNames(), v.Name)
    if v:IsA("Frame") and check then
        tweenButtons(v)
    end
end

-- Mouse click
UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        if MouseHoveringOnFrame == nil then return end
        print(MouseHoveringOnFrame)
        
    end
end)

local function update()
    -- FPS --
    LastIteration = TimeFunction()
    for Index = #FrameUpdateTable, 1, -1 do
        FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
    end
    FrameUpdateTable[1] = LastIteration

    -- Debug update --
    local fps = tostring(math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start))) .. " FPS"
    DebugInformation.Updateinformation("FPS", fps)

    local memoryUsage = tostring(math.floor(Stats:GetTotalMemoryUsageMb())) .. " MB"
    DebugInformation.Updateinformation("MEMORY", memoryUsage)

    local player = Players.LocalPlayer
    if player and player.Character and player.Character.PrimaryPart then
        local position = player.Character.PrimaryPart.Position
        DebugInformation.Updateinformation("POSITION", string.format("X: %.2f, Y: %.2f, Z: %.2f", position.X, position.Y, position.Z))
    end
end

Start = TimeFunction()

ReplicatedStorage.RemoteEvents.Player.SendFootstep.OnClientEvent:Connect(function(_part, _material)
    DebugInformation.Updateinformation("FOOTSTEP", "Part: " .. tostring(_part) .. ", Material: " .. tostring(_material))
end)

RunService.Heartbeat:Connect(update)
