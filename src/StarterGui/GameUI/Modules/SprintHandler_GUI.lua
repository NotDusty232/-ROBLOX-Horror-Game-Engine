local module = {}
local TweenService = game:GetService("TweenService")

local SprintFrame = script.Parent.Parent.Sprint
local SprintBar = SprintFrame.SprintBar
local RunningEffect = script.Parent.Parent.Parent:WaitForChild("Effects").RunningEffect

local GIF = require(script.Parent.Parent.Parent.Modules.GIF)
local spriteSheet = GIF.new(RunningEffect, 2, 4, 230, 230, 0.1, 10, 100, 260, 200)

function module.interpolateSize(percentage)
	local alpha = percentage / 100

	local startPos = UDim2.new(0.501, 0, -0.018, 0)
	local endPos = UDim2.new(-0.001, 0, -0.018, 0)
	local startSize = UDim2.new(-0.003, 0, 1, 0)
	local endSize = UDim2.new(1, 0, 1, 0)

	local posX = startPos.X.Scale + (endPos.X.Scale - startPos.X.Scale) * alpha
	local posXOffset = startPos.X.Offset + (endPos.X.Offset - startPos.X.Offset) * alpha
	local posY = startPos.Y.Scale + (endPos.Y.Scale - startPos.Y.Scale) * alpha
	local posYOffset = startPos.Y.Offset + (endPos.Y.Offset - startPos.Y.Offset) * alpha

	local sizeX = startSize.X.Scale + (endSize.X.Scale - startSize.X.Scale) * alpha
	local sizeXOffset = startSize.X.Offset + (endSize.X.Offset - startSize.X.Offset) * alpha
	local sizeY = startSize.Y.Scale + (endSize.Y.Scale - startSize.Y.Scale) * alpha
	local sizeYOffset = startSize.Y.Offset + (endSize.Y.Offset - startSize.Y.Offset) * alpha

	return UDim2.new(posX, posXOffset, posY, posYOffset), UDim2.new(sizeX, sizeXOffset, sizeY, sizeYOffset)
end

function module.setup()
	SprintFrame.Visible = true
end

function module.runningEffect(status)
    local runningEffectTween = TweenService:Create(RunningEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { ImageTransparency =  0.95 })
    local stopEffectTween = TweenService:Create(RunningEffect, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { ImageTransparency =  1 })
    if status == "Start" then
        stopEffectTween:Cancel()
        runningEffectTween:Play()
        spriteSheet:startAnimation()
    elseif status == "Stop" then
        runningEffectTween:Cancel()
        stopEffectTween:Play()
    end
end

return module
