local module = {}

local KickCodesModule = require(script.KickCodes)

function module.kickMessage(player, errorCode)
	if KickCodesModule[errorCode] then
		player:Kick(KickCodesModule[errorCode])
	else
		player:Kick("Unable to get kick message, error code: " .. errorCode)
	end
end

return module