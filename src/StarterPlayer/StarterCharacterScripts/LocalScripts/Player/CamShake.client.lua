local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = script.Parent.Parent.Parent
local Camera = workspace.CurrentCamera
local PlayFootStep = ReplicatedStorage.RemoteEvents.Player.PlayFootStep
local Humanoid: Humanoid = Character:WaitForChild("Humanoid", math.huge)
Humanoid = Character:FindFirstChildOfClass("Humanoid")

local DeltaTimeOffset = 1 / 60 
local BobbingOffset = CFrame.new()

local previousYBobbing = 0  -- To track previous bobbing value

RunService.RenderStepped:Connect(function(DeltaTime)
    local Offset = DeltaTime / DeltaTimeOffset * 0.5 * Humanoid.WalkSpeed / 12
    local IsMoving = Humanoid.MoveDirection.Magnitude > 0.01
    local CurrentCameraPosition = Camera.CFrame * BobbingOffset:Inverse()

    local ZDirection = -math.round(Humanoid.MoveDirection:Dot(Camera.CFrame.RightVector))

    -- Calculate the current Y bobbing based on movement
    local YBobbing = IsMoving and 
        math.rad(math.sin(time() * 20)) / 3.5 * Offset or 
        math.rad(math.sin(time())) / 100 * Offset

    BobbingOffset = BobbingOffset:Lerp(
        CFrame.Angles(
            YBobbing,
            IsMoving and 
                math.rad(math.sin(time() * 10)) / 3 * Offset or 
                math.rad(math.cos(time())) / 100 * Offset,
            math.rad(ZDirection * 2) * Offset
        ),
        0.05
    )

    Camera.CFrame = Camera.CFrame * BobbingOffset

    if IsMoving and previousYBobbing > 0 and YBobbing < 0 then
        PlayFootStep:FireServer()
    end

    previousYBobbing = YBobbing
end)
