local Settings = {}

function Settings.new(Data)
    local self = setmetatable({
        -- Togglables --
        EnableTimeBar = true,
        EnableInformation = true,
        EnableTextBox = false,
        EnableTypingSound = true,
        EnableFadeOut = true,

        -- Tweens --
        TimeBarDuration = 5,
        TweenOutDuration = 0.5,

        -- Texts --
        InformationText = "{BottomText}",
        TextBoxText = "{TextBox}",
        Icon = "rbxassetid://8445471499",

        -- Colors --
        IconColor = Color3.fromRGB(255, 255, 255),
        ShadowColor = Color3.fromRGB(255, 255, 255),
    }, {
        __index = Settings
    })

    if Data then
        for key, value in pairs(Data) do
            if self[key] ~= nil then
                self[key] = value
            end
        end
    end

    return self
end

return Settings
