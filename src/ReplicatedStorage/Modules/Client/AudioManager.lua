local module = {}

local function getSoundPath(mainFolder:string, soundFolder:string, soundEffect: string)
	local path = "ReplicatedStorage.Audios." .. mainFolder
	local main = game:GetService("ReplicatedStorage").Audios:FindFirstChild(mainFolder)

	if main then
		path = path .. "." .. soundFolder
		local folder = main:FindFirstChild(soundFolder)

		if folder then
			path = path .. "." .. soundEffect
			local sound = folder:FindFirstChild(soundEffect)

			if sound then
				print("<<ClientAudioManager>> Successfully found sound: " .. path)
				return sound
			else
				warn("<<ClientAudioManager>> Unable to find sound: " .. path)
			end
		else
			warn("<<ClientAudioManager>> Unable to find sound folder: " .. path)
		end
	else
		warn("<<ClientAudioManager>> Unable to find main folder: " .. path)
	end

	return nil
end


function module:PlaySoundEffect(soundFolder:string, soundEffect: string, volume: number?)
	if volume == nil then volume = 0.5 end

	local soundPath = getSoundPath("Sounds", soundFolder, soundEffect)
	if soundPath then
		soundPath:Play()
		soundPath.Volume = volume
	end
end

function module:PlayMusic(musicFolder:string, music: string, looped: boolean?, volume: number?)
	if volume == nil then volume = 0.5 end
	if looped == nil then looped = false end

	local musicPath = getSoundPath("Music", musicFolder, music)
	if musicPath then
		musicPath:Play()
		musicPath.Volume = volume
		musicPath.Looped = looped
	end
end

function module.StopAudio(audio, soundFolder, sound)
	local soundPath = getSoundPath(audio, soundFolder, sound)
	if soundPath then
		soundPath:Stop()
	end
end

function module:AddEffect(mainFolder:string, soundFolder:string, sound:string, effect:SoundEffect)
	local soundPath = getSoundPath(mainFolder, soundFolder, sound)
	if soundPath then
		effect.Parent = soundPath
	end
end

function module:RemoveEffect(mainFolder:string, soundFolder:string, sound:string, effect:string)
	local soundPath = getSoundPath(mainFolder, soundFolder, sound)
	if soundPath then
		if soundPath[effect] then
			soundPath[effect]:Destroy()
		else
			warn("<<ClientAudioManager>> Unable to locate effect: " .. effect)
		end
	end
end

function module:RemoveAllEffects(mainFolder:string, soundFolder:string, sound:string)
	local soundPath = getSoundPath(mainFolder, soundFolder, sound)
	if soundPath then
		for i, v in pairs(soundPath:GetDescendants()) do
			if v:IsA("SoundEffect") then
				if soundPath[v] then
					soundPath[v]:Destroy()
				else
					warn("<<ClientAudioManager>> Unable to locate effect: " .. v)
				end
			else
				warn("<<ClientAudioManager>> Unable to locate any effect: " .. v)
			end
		end
	end
end

return module
