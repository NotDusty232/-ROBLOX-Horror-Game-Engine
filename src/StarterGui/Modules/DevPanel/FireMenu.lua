local module = {}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local cloneFolder = script.Parent.TemplateFolder.Create
local FireMenu = script.Parent.Parent.Parent.Admin.FireMenu
local ListFrame = FireMenu.ListFrame
local ScrollingFrame = ListFrame.ScrollingFrame

local Slider = require(ReplicatedStorage.Modules.Libs.Slider)

local status = {
    Buttons = {},
    Sliders = {}
}

local defaultStatus = {
    Buttons = {},
    Sliders = {}
}

local activeSliders = {}

local function setDefaultProperties(_frame, _name, _description, _parent)
    _frame.Name = _name
    _frame.Text.Text = _name
    _frame.Description.Text = _description
    _frame.Parent = _parent
end

local function checkForChange(_statusType, _item)
    if status[_statusType] and defaultStatus[_statusType] then
        if status[_statusType][_item] ~= defaultStatus[_statusType][_item] then
            return true
        end
    end
    return false
end

local function setButtonIcon(_button, _isActive)
    if _isActive then
        _button.ImageRectOffset = Vector2.new(4, 836)
    else
        _button.ImageRectOffset = Vector2.new(940, 784)
    end
end

local function updateButton(_button, _status)
    if _status then
        _button.ImageRectOffset = Vector2.new(4, 836)
    else
        _button.ImageRectOffset = Vector2.new(940, 784)
    end
end

local function handleButtonClick(_button, _frame)
    if _button then
        _button.MouseButton1Click:Connect(function()
            local returnButton = _frame.Return
            status.Buttons[_frame.Name] = not status.Buttons[_frame.Name]

            if checkForChange("Buttons", _frame.Name) then
                returnButton.Visible = true
            else
                returnButton.Visible = false
            end

            updateButton(_button, status.Buttons[_frame.Name])
        end)
    end
end

local function handleReturnButtonClick(_returnButton, _button, _frame)
    _returnButton.MouseButton1Click:Connect(function()
        if _returnButton.Visible then
            status.Buttons[_frame.Name] = defaultStatus.Buttons[_frame.Name]
            updateButton(_button, status.Buttons[_frame.Name])
            _returnButton.Visible = false
        end
    end)
end

local function handleSliders(_frame, _sliderFrame, _data)
    local min = _data.Min
    local max = _data.Max
    local increment = _data.Increment
    local returnButton = _frame.Return

    local Slider_ = Slider.new(_sliderFrame, {
        AllowBackgroundClick = false,
        SliderData = { Start = min, End = max, Increment = increment },
        MoveInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad)
    })

    Slider_:OverrideValue(_data.Value)
    Slider_.Changed:Connect(function(_value)
        status.Sliders[_frame.Name] = _value

        if checkForChange("Sliders", _frame.Name) then
            returnButton.Visible = true
        else
            returnButton.Visible = false
        end
    end)

    Slider_:Track()

    table.insert(activeSliders, Slider_)
    print("Created new slider:", _frame.Name, "Value:", _data.Value)
end

local function create(_requireM)
    if _requireM.Create and _requireM.Create.Buttons then
        for _, buttonData in ipairs(_requireM.Create.Buttons) do
            local buttonFrameClone = cloneFolder:FindFirstChild("Button"):Clone()
            setDefaultProperties(buttonFrameClone, buttonData.Name, buttonData.Description, ScrollingFrame)

            defaultStatus.Buttons[buttonFrameClone.Name] = buttonData.Value or false
            status.Buttons[buttonFrameClone.Name] = defaultStatus.Buttons[buttonFrameClone.Name]

            setButtonIcon(buttonFrameClone.Button, status.Buttons[buttonFrameClone.Name])

            handleButtonClick(buttonFrameClone.Button, buttonFrameClone)
            handleReturnButtonClick(buttonFrameClone.Return, buttonFrameClone.Button, buttonFrameClone)
        end
    end

    if _requireM.Create and _requireM.Create.Sliders then
        for _, sliderData in ipairs(_requireM.Create.Sliders) do
            local sliderClone = cloneFolder:FindFirstChild("Slider"):Clone()
            setDefaultProperties(sliderClone, sliderData.Name, sliderData.Description, ScrollingFrame)

            defaultStatus.Sliders[sliderClone.Name] = sliderData.Value or sliderData.Min
            status.Sliders[sliderClone.Name] = defaultStatus.Sliders[sliderClone.Name]

            handleSliders(sliderClone, sliderClone.Slider, sliderData)
        end
    end
end

function module.load(_menu)
    local list = script.Parent.List:FindFirstChild(_menu)
    if list then
        local requireM = require(list)
        if requireM.Create then
            create(requireM)
        end
    end
end

return module
