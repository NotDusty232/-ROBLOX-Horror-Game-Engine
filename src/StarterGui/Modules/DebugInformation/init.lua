local module = {}
local storedUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local DebugInfoGUI = script.Parent.Parent.DebugInfo.Frame
local Template = script.Template.Frame

local debug = false

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function checkForDebug(_debug, _update)
    if _update == nil then _update = false end
    if table.find(storedUI, _debug) then
        local debugFrame = DebugInfoGUI:FindFirstChild(_debug)
        if debugFrame then
            if debug and not _update then
                print("<<DebugInformation>> Found debugFrame")
            end
            return true
        else
            warn("<<DebugInformation>> Unable to find debugFrame")
            return false
        end
    else
        warn("<<DebugInformation>> Current debug: " .. _debug .. ", Cannot be found in storedUI")
        return false
    end
end

function module.RequestDebugNames()
    return storedUI
end

function module:CreateDebug(_debug: string, information: string)
    local getAmountStoredInTable = #storedUI
    table.insert(storedUI, _debug)
    
    local newDebugFrame = Template:Clone()
    newDebugFrame.Parent = DebugInfoGUI
    newDebugFrame.Name = _debug
    newDebugFrame.Pattern.Pattern.Animate.Enabled = true
    newDebugFrame.TopText.Text = _debug
    newDebugFrame.BottomText.Text = information
    
    if debug then
        print("<<DebugInformation>> Created debug information!! + " .. _debug)
    end
end

function module:RemoveDebug(_debug: string)
    if checkForDebug(_debug) then
        local index = table.find(storedUI, _debug)
        table.remove(storedUI, index)
        local debugFrame = DebugInfoGUI:FindFirstChild(_debug)
        debugFrame:Destroy()
    end
end

function module.Updateinformation(_debug: string, newInformation: string)
    if checkForDebug(_debug, true) then
        local debugFrame = DebugInfoGUI:FindFirstChild(_debug)
        debugFrame.BottomText.Text = newInformation
    end
end

return module