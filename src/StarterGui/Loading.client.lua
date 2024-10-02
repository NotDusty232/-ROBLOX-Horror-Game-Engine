local lighting = game:GetService("Lighting")
local currentCamera = game:GetService("Workspace").CurrentCamera
local UIS = game:GetService("UserInputService")
local starterGui = game:GetService("StarterGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

wait(3)
lighting.FogEnd = 25
currentCamera.FieldOfView = 80
game:GetService("Workspace").Game.PlrCamera:WaitForChild("Desk").Transparency = 1
game:GetService("Workspace").Game.PlrCamera:WaitForChild("Desk").camera.Transparency = 1
UIS.ModalEnabled = true
starterGui:SetCore("ResetButtonCallback", false)

local Character = LocalPlayer.Character
for i, v in pairs(Character:GetChildren()) do
    if v:IsA("Accessory") then
        v:Destroy()
    end
end

local Humanoid = Character:FindFirstChild("Humanoid")
Humanoid.JumpPower = 0

--lighting.FogEnd = 4500
--lighting.OutdoorAmbient = Color3.fromRGB(140, 140, 140)
--lighting.GlobalShadows = true
--lighting.Brightness = 1.5
--lighting.Ambient = Color3.fromRGB(0, 0, 0)
--lighting.ShadowColor = Color3.fromRGB(61, 61, 61)
--lighting.ClockTime = 0
--lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
--lighting.EnvironmentDiffuseScale = 0

game.StarterPlayer.EnableMouseLockOption = false