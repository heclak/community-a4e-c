
function updateHost(host, params)
	ED_AudioAPI.setHostPosition(host, params.posx, params.posy, params.posz)
	ED_AudioAPI.setHostOrientation(host, params.orienta, params.orientb, params.orientc, params.orientd)
	ED_AudioAPI.setHostVelocity(host, params.velx, params.vely, params.velz)
	ED_AudioAPI.setHostTimestamp(host, params.timestamp)
end

function dbgPrint(whatToPrint)
	do return end
	print(whatToPrint)
end

function updLoopedSrcWithGain(snd, val)
	if snd ~= nil then
		if val < 0.0001 then
			ED_AudioAPI.stopSource(snd)
		else
			ED_AudioAPI.setSourceGain(snd, val)
			ED_AudioAPI.playSourceLooped(snd)
		end
	end
end

function updNotLoopedSrcWithGain(snd, val)
	if snd ~= nil then
		ED_AudioAPI.setSourceGain(snd, val)
	end
end

function switchSound(oldSnd, newSnd)
	if ED_AudioAPI.isSourcePlaying(oldSnd) then
		ED_AudioAPI.stopSource(oldSnd)
	end
	
	return newSnd
end

function ControlSound(snd, pitch, gain, loop)
	if snd == nil then
		return 0
	end
	
 	ED_AudioAPI.setSourcePitch(snd, pitch)
	ED_AudioAPI.setSourceGain(snd, gain)
	
	if loop == true then
		ED_AudioAPI.playSourceLooped(snd)
	else
		ED_AudioAPI.playSourceOnce(snd)
	end
end
