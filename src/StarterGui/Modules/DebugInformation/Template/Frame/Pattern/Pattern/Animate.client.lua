local image = script.Parent.Parent.Pattern

local function moveLeft()
    image:TweenPosition(UDim2.new(image.Position.X.Scale - 0.447, 0, image.Position.Y.Scale, 0), "Out", "Linear", 10, false, function()
        moveLeft()
    end)
end

moveLeft()
