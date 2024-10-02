local AdminPanel = require(script.Parent.Parent.DevPanel)
AdminPanel.new()

local search = script.Parent.Parent.Parent.Admin.ListMenu.ListFrame.Search.TextBox
search:GetPropertyChangedSignal("Text"):Connect(function()
    AdminPanel.updateSearchResults(search.Text)
end)