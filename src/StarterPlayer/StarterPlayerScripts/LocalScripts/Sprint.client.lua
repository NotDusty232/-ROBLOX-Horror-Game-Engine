local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local GameUI = LocalPlayer.PlayerGui:WaitForChild("GameUI", 1)

local Modules = GameUI:WaitForChild("Modules", 1)
local SprintModule = require(Modules.SprintHandler_GUI)
local SprintFrame = GameUI.Sprint
local UIStroke = SprintFrame.UIStroke
local SprintBar = SprintFrame.SprintBar

local remoteSpeed = ReplicatedStorage.RemoteEvents.Player.updateSpeed

local sprintPercentage = 100
local isSprinting = false
local sprintCooldown = 2
local cooldownTime = 0
local originalWalkSpeed = 12

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local TweenSprintFrameShow = TweenService:Create(SprintFrame, tweenInfo, { BackgroundTransparency = 0 })
local TweenUIStrokeShow = TweenService:Create(UIStroke, tweenInfo, { Transparency = 0 })
local TweenSprintBarShow = TweenService:Create(SprintBar, tweenInfo, { BackgroundTransparency = 0 })

local TweenSprintFrameHide = TweenService:Create(SprintFrame, tweenInfo, { BackgroundTransparency = 1 })
local TweenUIStrokeHide = TweenService:Create(UIStroke, tweenInfo, { Transparency = 1 })
local TweenSprintBarHide = TweenService:Create(SprintBar, tweenInfo, { BackgroundTransparency = 1 })

local function updateUI()
	local position, size = SprintModule.interpolateSize(sprintPercentage)
	local tweenInfoSprint = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	TweenService:Create(SprintBar, tweenInfoSprint, { Position = position }):Play()
    TweenService:Create(SprintBar, tweenInfoSprint, { Size = size }):Play()
    
    if isSprinting then
        SprintModule.runningEffect("Start")
    elseif not isSprinting then
        SprintModule.runningEffect("Stop")
    end
	
	if sprintPercentage < 100 or isSprinting then
		TweenSprintFrameShow:Play()
		TweenUIStrokeShow:Play()
        TweenSprintBarShow:Play()
    else
		TweenSprintFrameHide:Play()
		TweenUIStrokeHide:Play()
		TweenSprintBarHide:Play()
	end
end

local function onInput(input, gameProcessed)
	if gameProcessed then return end

	if input.KeyCode == Enum.KeyCode.LeftShift then
		if input.UserInputState == Enum.UserInputState.Begin then
			isSprinting = true
			remoteSpeed:FireServer(originalWalkSpeed + 8)
		elseif input.UserInputState == Enum.UserInputState.End then
			isSprinting = false
			cooldownTime = tick() + sprintCooldown
			remoteSpeed:FireServer(12)
		end
	end
end

local function updateSprint()
	if isSprinting then
		sprintPercentage = math.max(0, sprintPercentage - 4.5)
		if sprintPercentage <= 0 then
			isSprinting = false
			remoteSpeed:FireServer(12)
		end
	elseif not isSprinting and tick() > cooldownTime then
		sprintPercentage = math.min(100, sprintPercentage + 5.5)
	end

	updateUI()
end

SprintModule.setup()

game:GetService("UserInputService").InputBegan:Connect(onInput)
game:GetService("UserInputService").InputEnded:Connect(onInput)

while true do
	updateSprint()
	wait(0.1)
end