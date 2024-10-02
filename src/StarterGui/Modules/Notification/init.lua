local Notifications = {}

local TweenService = game:GetService("TweenService")

local Settings = require(script.Settings)

local cloneFrame = script.Template.Notifcation
local notificationHolder = script.Parent.Parent.GameUI.Notifcations.NotifcationHolder

local updateFrame = {}

-- << Types the text out >> --
function TypeText(_text, _object)
    local textLength = string.len(_text)
    local typedText = ""

    for i = 1, textLength do
        typedText = string.sub(_text, 1, i)
        _object.Text = typedText
        task.wait(0.001 * i)
    end
end

-- << Moves existing Notifcations Up >> --
function moveExistingNotifcations()
    for i, v in pairs(notificationHolder:GetChildren()) do
        if #updateFrame > 0 then
            local currentPosY = v.Position.Y.Scale

            local newYPos = currentPosY - 0.07
            local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            local tween = TweenService:Create(v, tweenInfo, { Position = UDim2.new(v.Position.X.Scale, v.Position.X.Offset, 
                newYPos, v.Position.Y.Offset) })
            tween:Play()
        end
    end
end

-- << Lowers the frame from the updateFrame table >> --
function removeFrameTable(_frame)
    local index = table.find(updateFrame, _frame)
    table.remove(updateFrame, index)
end

-- << Fades out the frame and the descendants >> --
function fadeOutFrames(_frame, _settings)
    local tweenInfo = TweenInfo.new(_settings.TweenOutDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(_frame, tweenInfo, { BackgroundTransparency = 1 })
    tween:Play()

    for i, v in pairs(_frame:GetDescendants()) do
        if v:IsA("Frame") then
            local tween = TweenService:Create(v, tweenInfo, { BackgroundTransparency = 1 })
            tween:Play()
        elseif v:IsA("TextLabel") or v:IsA("TextBox") then
            local tween = TweenService:Create(v, tweenInfo, { TextTransparency = 1 })
            tween:Play()
        elseif v:IsA("ImageLabel") then
            local tween = TweenService:Create(v, tweenInfo, { ImageTransparency = 1 })
            tween:Play()
        elseif v:IsA("UIStroke") then
            local tween = TweenService:Create(v, tweenInfo, { Transparency = 1 })
            tween:Play()
        end
    end

    tween.Completed:Connect(function()
        _frame:Destroy()
        removeFrameTable(_frame)
    end)
end

-- << Removes the notifcation >> --
function remove(_frame, _settings)
    if table.find(updateFrame, _frame) then
        if _settings.EnableFadeOut then
            fadeOutFrames(_frame, _settings)
        else
            _frame:Destroy()
            removeFrameTable(_frame)
        end
    end
end

-- << Update for the timebar >> --
function update(_frame, _settings)
    if table.find(updateFrame, _frame) then
        local timeBar = _frame.TimeBar
        local tweenInfo = TweenInfo.new(_settings.TimeBarDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
        local endScaleX, endScaleY
        endScaleX = 1 endScaleY = -0.066

        local tween = TweenService:Create(timeBar, tweenInfo, { Size = UDim2.new(endScaleX, 0, endScaleY, 0) })
        tween:Play()
        tween.Completed:Connect(function()
            remove(_frame, _settings)
        end)
    end
end

-- << Creates the notifcation >> --
function Notifications.new(_settings)
    local settings = Settings.new(_settings)
    local enableTextBox = settings.EnableTextBox
    local enableinformation = settings.EnableInformation
    local enableTimeBar = settings.EnableTimeBar

    moveExistingNotifcations()

    local cloneFrame = cloneFrame:Clone()
    cloneFrame.Parent = notificationHolder
    cloneFrame.LayoutOrder = #updateFrame
    cloneFrame.Position = UDim2.new(1.1, 0, 0.928, 0)
    cloneFrame.Name = "Notification_" .. #updateFrame

    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(cloneFrame, tweenInfo, { Position = UDim2.new(0.03, 0, 0.928, 0) })
    tween:Play()
    tween.Completed:Connect(function()
        if enableTimeBar then
            table.insert(updateFrame, cloneFrame)
            update(cloneFrame, settings)
        end

        if enableTextBox then
            local textBox = cloneFrame.TextBox
            textBox.Visible = true
            TypeText(settings.TextBoxText, textBox)
        elseif enableinformation then
            local informationText = cloneFrame.InformationText
            informationText.Visible = true
            TypeText(settings.InformationText, informationText)
        end
    end)
end

return Notifications