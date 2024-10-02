-- << REMINDER: >> --
-- << REMINDER: >> --
-- << THE NAME OF THE CREATE IS SENT TO THE RE/M/RF. FOR EXAMPLE IF A BUTTON IS NAMED "EnableText" AND ITS TRUE, IT WILL SEND: EnableText = true>> --
-- << ONLY USE THE DESCRIPTION TO EXPLAIN WHAT IT DOES >> --
-- << REMINDER: >> --
-- << REMINDER: >> --

return {
    Name = "Test", -- Sets the name on the frame and the text.
    Type = "Module", -- Module, RemoteEvent, RemoteFunction.
    Create = { -- You can put custom properties inside of this, for example Button or Slider. The list goes from top the bottom in order
        Notes = { -- Custom note you can put that has a text string
            Text = "[Important hi]" -- Text thats displayed
        },
        Button = { -- Buttons Tab
            Name = "Test Button", -- Name for button
            Description = "hi", -- Description for button
        },
        Slider = { -- Slider Tab
            Name = "Test Slider", -- Name for slider
            Description = "hi v2", -- Description for slider
            Min = 10, -- Minimum amount
            Max = 100, -- Maximum amount
        },
        Textbox = { -- Textbox that gives a string
            Name = "Test Textbox", -- Name for textbox
            Description = "hi v3", -- Description for textbox
            PlaceholderText = nil, -- Text thats shown before a input. (Optional) nil to not have this
        },
        Colorwheel = { -- Color wheel that will use a Color3.fromRGB
            Name = "Test Color Wheel", -- Name for color wheel
            Description = "hi v4", -- Description for color wheel
        },
        Dropdown = { -- Dropdown menu that can be used for multi choice
            Name = "Test Dropdown", -- Name for dropdown
            Description = "hi v5", -- Description for dropdown
            Extra = { -- Put for same code as you would do for Create. So for example Button = { Name = "Dropdown 1", Description = "No",}
                -- Button, Slider, Or Color
            }
        },
    }
}