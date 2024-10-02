-- Thanks for the help - https://devforum.roblox.com/t/scale-spritesheet-iteration/350693
local module = {}

function module.new(imageLabel, rows, columns, frameWidth, frameHeight, animationSpeed, initialXOffset, initialYOffset, xStep, yStep)
    local self = {}
    self.imageLabel = imageLabel
    self.rows = rows
    self.columns = columns
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
    self.animationSpeed = animationSpeed or 0.1
    self.currentFrame = 1
    self.totalFrames = rows * columns
    self.initialXOffset = initialXOffset or 10
    self.initialYOffset = initialYOffset or 100
    self.xStep = xStep or 260
    self.yStep = yStep or 200
    self.isAnimating = false

    function self:updateFrame()
        local column = (self.currentFrame - 1) % self.columns
        local row = math.floor((self.currentFrame - 1) / self.columns)
        local xOffset = self.initialXOffset + (column * self.xStep)
        local yOffset = self.initialYOffset + (row * self.yStep)
        
        self.imageLabel.ImageRectOffset = Vector2.new(xOffset, yOffset)
        self.imageLabel.ImageRectSize = Vector2.new(self.frameWidth, self.frameHeight)

        self.currentFrame = self.currentFrame + 1
        if self.currentFrame > self.totalFrames then
            self.currentFrame = 1
        end
    end
    
    function self:startAnimation()
        if not self.isAnimating then
            self.isAnimating = true
            spawn(function()
                while self.isAnimating do
                    self:updateFrame()
                    wait(self.animationSpeed)
                end
            end)
        end
    end
    
    function self:stopAnimation()
        self.isAnimating = false
    end

    return self
end

return module
