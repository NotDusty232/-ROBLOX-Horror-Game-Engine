local Animations = require(script.Parent.Animations)

local AnimationMapModule = {}

AnimationMapModule.animationMap = {
	["Front"] = {
		["W"] = {
			["None"] = Animations.goUnderDesk,
			["Under_Desk"] = Animations.goUnderDesk
		},
	},
	["Left"] = {
		["W"] = {
			["None"] = Animations.goToDoor,
			["Left_Door"] = function() Animations.DoorAnimations("Peak") end
		},
		["S"] = {
			["Left_Door"] = Animations.LeaveDoorReturnToChair,
			["Peaking_Left_Door"] = function() Animations.DoorAnimations("Unpeak") end
		}
	}
}

return AnimationMapModule
