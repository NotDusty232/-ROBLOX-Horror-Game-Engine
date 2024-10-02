local AP = {}
local TweenService = game:GetService("TweenService")

local cloneFolder = script.TemplateFolder
local AdminList = script.Parent.Parent.Admin.ListMenu
local FireList = script.Parent.Parent.Admin.FireMenu
local ListFrame = AdminList.ListFrame
local ScrollingFrame = ListFrame.ScrollingFrame
local list = script.List

local SearchBox = ListFrame.Search.TextBox
local SearchIcon = ListFrame.Search.Search
local SearchUIStroke = ListFrame.Search.UIStroke

local listTable = {}

local Notifications = require(script.Parent.Notification)
local FireMenu = require(script.FireMenu)

local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

local function applyHoverEffects(_frame, _button)
    _button.MouseEnter:Connect(function()
        local tween = TweenService:Create(_button.UIStroke, tweenInfo, { Transparency = 0 })
        tween:Play()
    end)

    _button.MouseLeave:Connect(function()
        local tween = TweenService:Create(_button.UIStroke, tweenInfo, { Transparency = 1 })
        tween:Play()
    end)

    _frame.MouseEnter:Connect(function()
        local tween = TweenService:Create(_frame.UIStroke, tweenInfo, { Transparency = 0 })
        tween:Play()
    end)

    _frame.MouseLeave:Connect(function()
        local tween = TweenService:Create(_frame.UIStroke, tweenInfo, { Transparency = 0.3 })
        tween:Play()
    end)
end

local function applySearchBoxEffects()
    SearchBox.MouseEnter:Connect(function()
        local tween = TweenService:Create(SearchUIStroke, tweenInfo, { Transparency = 0 })
        tween:Play()
    end)

    SearchBox.MouseLeave:Connect(function()
        local tween = TweenService:Create(SearchUIStroke, tweenInfo, { Transparency = 0.3 })
        tween:Play()
    end)
    
    SearchBox.Focused:Connect(function()
        local tween = TweenService:Create(SearchIcon, tweenInfo, { ImageTransparency = 0 })
        tween:Play()
    end)

    SearchBox.FocusLost:Connect(function()
        local tween = TweenService:Create(SearchIcon, tweenInfo, { ImageTransparency = 0.3 })
        tween:Play()
    end)
end

local function addMouseClick(_button, _frame)

    _button.MouseButton1Click:Connect(function()
        FireMenu.load(_frame)
        AdminList.Visible = false
        FireList.Visible = true
    end)
end

function AP.updateSearchResults(_searchText)
    local foundItems = 0

    for _, v in pairs(ScrollingFrame:GetChildren()) do
        if v:IsA("Frame") then
            local name = string.lower(v.Name)
            local searchLower = string.lower(_searchText)

            if string.find(name, searchLower) then
                v.Visible = true
                foundItems += 1
            else
                v.Visible = false
            end
        end
    end
end

local function update()
    for _, v in pairs(ScrollingFrame:GetDescendants()) do
        if v:IsA("Frame") and table.find(listTable, v.Name) then
            applyHoverEffects(v, v.Button)
            addMouseClick(v.Button, v.Name)
        end
    end
    applySearchBoxEffects()
end

function AP.new()
    for _, v in pairs(list:GetChildren()) do
        if v:IsA("ModuleScript") then
            AP.newList(v.Name)
        end
    end
    
    update()
end

function AP.newList(_name)
    local existingClone = ScrollingFrame:FindFirstChild(_name)
    if existingClone then return end

    local check = list:FindFirstChild(_name)
    if check then
        local requiredModule = require(check)
        local moduleName = requiredModule.Name
        local moduleType = requiredModule.Type

        local cloneType = cloneFolder:FindFirstChild(moduleType)
        if cloneType then
            local clone = cloneType:Clone()
            clone.Parent = ScrollingFrame
            clone.Name = moduleName
            clone.Text.Text = moduleName

            table.insert(listTable, clone.Name)
        else
            Notifications.new({ InformationText = "<<Admin Panel>> Unable to find type to clone: " .. moduleType })
        end
    else
        Notifications.new({ InformationText = "<<Admin Panel>> Unable to find Module: " .. tostring(check) })
    end
end

return AP