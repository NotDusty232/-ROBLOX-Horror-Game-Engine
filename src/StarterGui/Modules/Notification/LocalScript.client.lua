local dasd = require(script.Parent.Parent.Notification)
local textInput = {
    InformationText = {
        "Get me out [1]",
        "Again what do I put here [2]",
        "You cannot remove the headset [3]",
        "Invevitor [4]",
        "Storage [5]",
    }
}

math.randomseed(tick())

wait(5)
while wait(1) do
    local randomIndex = math.random(1, 5)
    dasd.new({InformationText = textInput.InformationText[randomIndex]})
end