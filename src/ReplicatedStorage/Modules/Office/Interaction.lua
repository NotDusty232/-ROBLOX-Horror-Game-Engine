local module = {}

local UserInputService = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()

function module.setMouseIcon(id) 
	mouse.Icon = "http://www.roblox.com/asset/?id=" .. id
end

function module.setMouseVisible(status)
	if status == "Show" then
		mouse.Icon = "http://www.roblox.com/asset/?id=950896037"
	else if status == "Hide" then
			mouse.Icon = "http://www.roblox.com/asset/?id=13593261200"
		end
	end
end

return module
