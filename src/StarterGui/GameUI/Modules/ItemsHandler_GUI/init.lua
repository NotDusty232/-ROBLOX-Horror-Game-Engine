local ItemsHandler = {}
local ItemsData = require(script.ItemsData_GUI)

local ItemsFrame = script.Parent.Parent.Items
local StoredBorderFolder = script.Border

local ItemsAmount = 0

local excludedFrames = {
	["LeftDown"] = true,
	["LeftUp"] = true,
	["RightDown"] = true,
	["RightUp"] = true
}

local function checkForItem(item)
	local foundItem = ItemsFrame:FindFirstChild(item)
	if foundItem then
        print("<<ItemsHandler_GUI>> Found item: " .. tostring(item))
		return foundItem
	else
        warn("<<ItemsHandler_GUI>> Unable to find item in frame: " .. tostring(item))
		return nil
	end
end

function ItemsHandler:AddItem(item)
	local check = ItemsFrame:FindFirstChild("item")
	if check then
        warn("<<ItemsHandler_GUI>> Already existing item: " .. tostring(item) .. ". Gonna return now :)")
		return
	end

	if ItemsData.Items[item] then
		local clonedItem = ItemsData.Items[item]:Clone()
		clonedItem.Parent = ItemsFrame
		ItemsAmount += 1
        clonedItem.LayoutOrder = ItemsAmount
        
        ItemsHandler:setKeyBindOnItem("72207058593148", "FlashLight")
	else
        warn("<<ItemsHandler_GUI>> Unable to find item in ItemsData: " .. tostring(item))
	end
end

function ItemsHandler:RemoveItem(item)
	local foundItem = checkForItem(item)
	if foundItem then
		foundItem:Destroy()
		ItemsAmount -= 1
	end
end

function ItemsHandler:ApplyBorder(border, item)
	local foundItem = checkForItem(item)
	if foundItem then
		if ItemsData.Borders[border] then
			local clonedBorder = ItemsData.Borders[border]:Clone()
			clonedBorder.Parent = foundItem
		else
            warn("<<ItemsHandler_GUI>> Unable to find border: " .. tostring(border))
		end
	end
end

function ItemsHandler:setKeyBindOnItem(keybind, item)
    local foundItem = checkForItem(item)
    if foundItem then
        local keyImage = Instance.new("ImageLabel")
        keyImage.Parent = foundItem
        keyImage.Name = "Key"
        keyImage.Image = "rbxassetid://" .. keybind
        keyImage.BackgroundTransparency = 1
        keyImage.Position = UDim2.new(foundItem.Position.X.Scale, foundItem.Position.X.Offset - 65, 
                                      foundItem.Position.Y.Scale, foundItem.Position.Y.Offset + 10)
        keyImage.Size = UDim2.new(0, 50, 0, 50)
    end
end

function ItemsHandler.setItemTransparency(item, transparency)
	local foundItem = checkForItem(item)
	if foundItem then
		foundItem.ImageTransparency = transparency
	end
end

function ItemsHandler.setBorderTransparency(item, border, transparency)
	local foundItem = checkForItem(item)
	if foundItem then
		local borderInstance = foundItem:FindFirstChild(border)
		if borderInstance then
			for _, descendant in pairs(borderInstance:GetDescendants()) do
				if not excludedFrames[descendant.Name] then
					descendant.BackgroundTransparency = transparency
				end
			end
		else
			warn("<<ItemsHandler_GUI>> Unable to find border: " .. tostring(border))
		end
	end
end

return ItemsHandler