--[[
	hasBattery = true,             << If the flashlight has a battery system >>
	batteryDrainRate = 0.15,       << How fast the battery goes down when used >>
	batteryRechargeRate = 0.15,    << How fast the battery recharges when not used >>
	maxBattery = 100,              << Maximum battery percentage >>
	smoothness = 0.1,              << How smooth the drag effect is on the flashlight (TIP: the more the less of the effect) >>
	flickerChanceMultiplier = 1300 << How much the light has a chance of flickering depending on the battery >>
]]

return {
	PlayerFlashlight = {
		hasBattery = false,
		smoothness = 0.05,
	},
	OfficeFlashlight = {
		hasBattery = true,
		batteryDrainRate = 0.1,
		batteryRechargeRate = 0.1,
		maxBattery = 100,
		flickerChanceMultiplier = 1300,
	},
}