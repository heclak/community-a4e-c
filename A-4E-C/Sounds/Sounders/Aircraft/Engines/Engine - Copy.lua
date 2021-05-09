dofile("Tools.lua")

offsets = {
	core   = 0,
	core2  = 0,
	fan    = 0,
	turb   = 0,
	jet    = 0,
	around = 0
}

engine = {number = 0}

function engine:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	o.number = 1
	return o
end

function engine:init(number_, host)
	self:initNames()
	self:createSounds(number_, host)
end

function engine:initNames()
	self.core_name 	 = "Aircrafts/Engines/A-4E-C/PlaneFrontEngine"
	--self.jet_name    = "Aircrafts/Engines/A-4E-C/EngineJet"
	self.around_name = "Aircrafts/Engines/A-4E-C/PlaneAroundEngine"
	--self.fan_name = "Aircrafts/Engines/A-4E-C/PlaneAroundEngine"
end

function engine:createSounds(number_, host)
	self.number = number_

	if self.core_name ~= nil then
		self.sndCore = ED_AudioAPI.createSource(host, self.core_name)
	end
	
	if self.core2_name ~= nil then
		self.sndCore2 = ED_AudioAPI.createSource(host, self.core2_name)
	end
	
	if self.jet_name ~= nil then
		self.sndJet = ED_AudioAPI.createSource(host, self.jet_name)
	end
	
	if self.around_name ~= nil then
		self.sndAround = ED_AudioAPI.createSource(host, self.around_name)
	end
	
	if self.fan_name ~= nil then
		self.sndFan = ED_AudioAPI.createSource(host, self.fan_name)
	end
	
	if self.turb_name ~= nil then
		self.sndTurb = ED_AudioAPI.createSource(host, self.turb_name)
	end
end

function engine:initCptNames()
	self.engine_l_name  = "Aircrafts/A-4E-C/a4e-debugtest05"
	self.engine_r_name  = "Aircrafts/A-4E-C/a4e-debugtest05"
	self.heAmb_l_name   = "Aircrafts/A-4E-C/a4e-debugtest05"
	self.heAmb_r_name   = "Aircrafts/A-4E-C/a4e-debugtest05"
end

function engine:createSoundsCpt(hostCpt)
	if self.number == 1 then
		if self.engine_l_name ~= nil then
			self.sndCpt = ED_AudioAPI.createSource(hostCpt, self.engine_l_name)
		end
		
		if self.engine_l2_name ~= nil then
			self.sndCpt2 = ED_AudioAPI.createSource(hostCpt, self.engine_l2_name)
		end
		
		if self.heAmb_l_name ~= nil then
			self.sndCptAmb = ED_AudioAPI.createSource(hostCpt, self.heAmb_l_name)
		end
	elseif self.number == 2 then
		if self.engine_r_name ~= nil then
			self.sndCpt = ED_AudioAPI.createSource(hostCpt, self.engine_r_name)
		end
		
		if self.engine_r2_name ~= nil then
			self.sndCpt2 = ED_AudioAPI.createSource(hostCpt, self.engine_r2_name)
		end
		
		if self.heAmb_r_name ~= nil then
			self.sndCptAmb = ED_AudioAPI.createSource(hostCpt, self.heAmb_r_name)
		end
	end
end

function engine:destroySoundsCpt()
	if self.sndCpt ~= nil then
		ED_AudioAPI.destroySource(self.sndCpt)
		self.sndCpt = nil
	end
	
	if self.sndCpt2 ~= nil then
		ED_AudioAPI.destroySource(self.sndCpt2)
		self.sndCpt2 = nil
	end
	
	if self.sndCptAmb ~= nil then
		ED_AudioAPI.destroySource(self.sndCptAmb)
		self.sndCptAmb = nil
	end
end

function engine:calculatePitchGainCore(coreRPM)
	return coreRPM, math.sqrt(coreRPM)
end

function engine:calculatePitchGainFan(fanRPM)
	local gain = 1
	if fanRPM < 0.5 then
		gain = fanRPM * 2
	end
	
	return fanRPM, gain
end

function engine:calculatePitchGainAround(fanRPM, coreRPM, coreRPM2)
	local pitch = fanRPM
	if pitch == 0 then
		pitch = coreRPM -- using core if no fan is present
	end
	
	return pitch, math.max(0, 5.6592*coreRPM2*coreRPM2 - 13.259*coreRPM2*coreRPM + 8.3924*coreRPM2 - 0.337*coreRPM - 0.0048)
end

function engine:calculatePitchGainJet(fanRPM, coreRPM, thrust, flame)
	local RPM = fanRPM
	if RPM == 0 then
		RPM = coreRPM -- using core if no fan is present
	end
	
	local gain = math.sqrt(thrust)
	if thrust < 0.05 and flame > 0 then
		gain = 0.23 * coreRPM / 0.7
	end
		
	return 0.5 + 0.5 * RPM, gain
end

function engine:calculatePitchGainCpt(coreRPM, vTrue)
	return coreRPM, 0.4 * math.sqrt(coreRPM)
end

function engine:calculatePitchGainCpt2(coreRPM)
	return coreRPM, 1 - (math.exp(-(math.pow(coreRPM, 7))))
end

function engine:calculatePitchGainCptAmb(coreRPM, coreRPM2)
	local gain = 1
	if coreRPM < 0.6784 then
		gain = math.max(0, 2.0967 * coreRPM2 + 0.0516 * coreRPM - 6E-15)
	end
	
	return 1, gain
end

function engine:DBGstop()
	stopSRC = function(src)
		if src ~= nil then
			if ED_AudioAPI.isSourcePlaying(src) then
				dbgPrint("src: " .. src)
				ED_AudioAPI.stopSource(src)
			end
		end
	end
	
	stopSRC(self.sndCore)
	stopSRC(self.sndCore2)
	stopSRC(self.sndJet)
	stopSRC(self.sndAround)
	stopSRC(self.sndFan)
	stopSRC(self.sndTurb)
		
	stopSRC(self.sndCpt)
	stopSRC(self.sndCpt2)
	stopSRC(self.sndCptAmb)
end

function engine:controlSound(snd, pitch, gain, offsetKey)
	if gain < 0.01 then
		ED_AudioAPI.stopSource(snd)
	elseif gain >= 0.01 then
		dbgPrint("pitch: " .. pitch)
		dbgPrint("gain: " .. gain)
	
		ED_AudioAPI.setSourcePitch(snd, pitch)
		ED_AudioAPI.setSourceGain(snd, gain)
		
		if not ED_AudioAPI.isSourcePlaying(snd) then
			if offsetKey ~= nil then
				if offsets[offsetKey] ~= nil then
					ED_AudioAPI.playSourceLooped(snd, offsets[offsetKey])
					offsets[offsetKey] = offsets[offsetKey] + 0.5
				end
			else
				ED_AudioAPI.playSourceLooped(snd)
			end
		end
	end
end

function engine:update(coreRPM, fanRPM, turbPower, thrust, flame, vTrue)
	dbgPrint("engine:update")

	local corePitch, coreGain = self:calculatePitchGainCore(coreRPM)
	
	local coreRPM2 = coreRPM * coreRPM
	local aroundPitch, aroundGain = self:calculatePitchGainAround(fanRPM, coreRPM, coreRPM2)
	
	if self.sndCore ~= nil then
		dbgPrint("core")
		self:controlSound(self.sndCore, corePitch, coreRPM, "core")
	end
	
	if self.sndCore2 ~= nil then
		dbgPrint("core2")
		local core2Pitch = corePitch
		local core2Gain = coreGain
		
		self:controlSound(self.sndCore2, core2Pitch, coreRPM2, "core2")
	end

	if self.sndFan ~= nil then
		dbgPrint("fan")
		local fanPitch, fanGain = self:calculatePitchGainFan(fanRPM)
		self:controlSound(self.sndFan, fanPitch, fanGain, "fan")
	end
	
	if self.sndAround ~= nil then
		dbgPrint("around")
		self:controlSound(self.sndAround, aroundPitch, aroundGain, "around")
	end

	if self.sndTurb ~= nil then
		dbgPrint("turb")
		local turbPitch = aroundPitch
		local turbGain = turbPower
		self:controlSound(self.sndTurb, turbPitch, turbGain, "turb")
	end
	
	if self.sndJet ~= nil then
		dbgPrint("jet")
		local jetPitch, jetGain = self:calculatePitchGainJet(fanRPM, coreRPM, thrust, flame)
		self:controlSound(self.sndJet, jetPitch, jetGain, "jet")
	end
	
	if self.sndCpt ~= nil then
		local cptPitch, cptGain = self:calculatePitchGainCpt(coreRPM, vTrue)
		self:controlSound(self.sndCpt, cptPitch, cptGain)
	end

	if self.sndCpt2 ~= nil then
		local cpt2Pitch, cpt2Gain = self:calculatePitchGainCpt2(coreRPM)
		self:controlSound(self.sndCpt2, cpt2Pitch, cpt2Gain)
	end
	
	if self.sndCptAmb ~= nil then
		local cptAmbPitch, cptAmbGain = self:calculatePitchGainCptAmb(coreRPM, coreRPM2)
		self:controlSound(self.sndCptAmb, cptAmbPitch, cptAmbGain)
	end
end

