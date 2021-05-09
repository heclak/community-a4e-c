dofile("Tools.lua")
dofile("Curve.lua")


engine = {number = 0}


SOUND_CORE_RPM = 0
SOUND_FAN_RPM = 1
SOUND_TURBINE_POWER = 2
SOUND_THRUST = 3
SOUND_TRUE_AIRSPEED =4

function engine:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	o.number = 1
	return o
end

function engine:init(number_, host)
	self:initNames()

	self.engine_sounds = {
		{
			sdef_name = "Aircrafts/Engines/A-4E-C/PlaneFrontEngine",
			type = SOUND_CORE_RPM,
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 1.0, 100.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 1.0, 100.0),
			sound = nil,
		},

		{
			sdef_name = "Aircrafts/Engines/A-4E-C/PlaneAroundEngine",
			type = SOUND_CORE_RPM,
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 1.0, 100.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 1.0, 100.0),
			sound = nil,
		},
	}

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

	self.offsets = {}

	self.sndCore = ED_AudioAPI.createSource(host, "Aircrafts/Engines/A-4E-C/PlaneAroundEngine")

	for key,value in pairs(self.engine_sounds) do
		value.sound = ED_AudioAPI.createSource(host, value.sdef_name)
		self.offsets[key] = 0.0
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
				if self.offsets[offsetKey] ~= nil then
					ED_AudioAPI.playSourceLooped(snd, self.offsets[offsetKey])
					self.offsets[offsetKey] = self.offsets[offsetKey] + 0.5
				end
			else
				ED_AudioAPI.playSourceLooped(snd)
			end
		end
	end
end

function engine:update(coreRPM, fanRPM, turbPower, thrust, flame, vTrue)
	dbgPrint("engine:update")

	--[[
	sound_param = {
		[SOUND_CORE_RPM] = coreRPM,
		[SOUND_FAN_RPM] = fanRPM,
		[SOUND_TURBINE_POWER] = turbPower,
		[SOUND_THRUST] = thrust,
		[SOUND_TRUE_AIRSPEED] = vTrue,
	}

	for key,value in pairs(self.engine_sounds) do

		local param = sound_param[value.type]

		local pitch = value.pitch_curve:value(param)
		local gain = value.gain_curve:value(param)

		self:controlSounds(value.sound, 1.0, 1.0, nil)
	end
	]]

	self:controlSounds(self.sndCore, 1.0, 1.0, nil)
end

