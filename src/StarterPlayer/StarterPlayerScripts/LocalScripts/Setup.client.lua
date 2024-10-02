--Remove CoreGui
local coreGuiTypes = {
	Enum.CoreGuiType.All,
	Enum.CoreGuiType.Backpack,
	Enum.CoreGuiType.Chat,
	Enum.CoreGuiType.EmotesMenu,
	Enum.CoreGuiType.Health,
	Enum.CoreGuiType.PlayerList
}

local DisableGUI = game:GetService("StarterGui")

for _, guiType in ipairs(coreGuiTypes) do
	DisableGUI:SetCoreGuiEnabled(guiType, false)
end

local Interaction = require(game.ReplicatedStorage.Modules.Office.Interaction)
Interaction.setMouseIcon("950896037")


local ContextActionService = game:GetService("ContextActionService")

ContextActionService:BindActionAtPriority("RightMouseDisable", function()
	return Enum.ContextActionResult.Sink
end, false, Enum.ContextActionPriority.Medium.Value, Enum.UserInputType.MouseButton2)
-- Thanks
-- https://devforum.roblox.com/t/how-to-disable-mouses-locking-action-when-right-clicking/285403/5?u=dusty232altlol