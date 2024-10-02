local GlobalValues = {}

GlobalValues.CameraSide = "Front"
GlobalValues.CameraOnSide = "None"
GlobalValues.PlayingAnimation = false
GlobalValues.CanRotate = false
GlobalValues.TurningAroundCamera = game.ReplicatedStorage.GlobalValues.Office.TurningAroundOnDesk.Value

GlobalValues.CameraFullRotations = {
	Front = 180,
	Left  = -90,
	Right = 90,
	Back  = 0,
}
GlobalValues.CameraFullTurn = {
	Front = 0,
	Left  = -9.999,
	Right = 9.999,
	Back  = 0,
}

return GlobalValues
