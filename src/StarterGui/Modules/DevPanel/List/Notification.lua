return {
    Name = "Notification",
    Type = "Module",
    Create = {
        Buttons = {
            {
                Name = "Enable TimeBar",
                Description = "Enables the time bar.",
                Define = "EnableTimeBar",
                Value = true,
            },
            {
                Name = "Enable Information",
                Description = "Enables the Information instead of Textbox",
                BanDublicationValue = 1,
                Define = "EnableInformation",
                Value = true,
            },
            {
                Name = "Enable TextBox",
                Description = "Enables the Textbox instead of Information",
                BanDublicationValue = 1,
                Define = "EnableTextBox",
                Value = false,
            },
            {
                Name = "Enable TypingSound",
                Description = "Enables sound on the typing text.",
                Define = "EnableTypingSound",
                Value = false,
            },
            {
                Name = "Enable FadeOut",
                Description = "Enables the fade out when finished.",
                Define = "EnableFadeOut",
                Value = true,
            },
        },
        Sliders = {
            {
                Name = "TimeBar Duration",
                Description = "Time before disappearing.",
                Define = "TimeBarDuration",
                Min = 1,
                Max = 10,
                Increment = 1,
                Value = 5,
            },
            {
                Name = "Tween Out Duration",
                Description = "Amount of time it takes to fade out.",
                Define = "TweenOutDuration",
                Min = 1,
                Max = 10,
                Increment = 1,
                Value = 5,
            },
        }
    }
}
