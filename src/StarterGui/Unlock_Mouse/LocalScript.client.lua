local UserInputSerivce = game:GetService("UserInputService")

UserInputSerivce.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.L then
		if not script.Parent.Parent.Unlock_Mouse.Enabled then
			script.Parent.Parent.Unlock_Mouse.Enabled = true
			script.Parent.TextButton.Visible = true
		else
			script.Parent.Parent.Unlock_Mouse.Enabled = false
			script.Parent.TextButton.Visible = false
		end
	end
end)