dofile("Tools.lua")
dofile("Curve.lua")

offsets = {
	core   = 0,
	core2  = 0,
	fan    = 0,
	turb   = 0,
	jet    = 0,
	around = 0
}

--SOUND_CORE_RPM = 0 -- This is normalised 0.0 -> 1.0
SOUND_FAN_RPM = 1  -- This is normalised 0.0 -> 1.0
SOUND_TURBINE_POWER = 2 --No idea
--SOUND_THRUST = 3 -- I assume this is in Newtons
SOUND_TRUE_AIRSPEED = 4 --Airspeed I think is in m/s

engine = {number = 0}

function engine:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	o.number = 1
	return o
end

function engine:init(number_, host)

	--[[
	Format:

	{
		sound = nil,
		type = <what is the x axis for the pitch and gain curves>,
		sdef_name = <which sound sdef>,
		pitch_curve = Curve(<curve data>, <min>, <max>)
		gain_curve = Curve(<curve data>, <min>, <max>)
	}

	]]


	self.sounds = {
		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_around_hi",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},
		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_front_hi",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},
		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_back_hi",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},

		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_around_lo",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},

		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_front_lo",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},

		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_back_lo",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},

		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_far_whine",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},

		{
			sound = nil,
			type = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_far_rip",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.23, 1.40}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.61, 0.82, 0.93, 0.97, 0.99, 1}, 0.01, 1.0),
		},
	}



	self:createSounds(number_, host)
end

function engine:createSounds(number_, host)
	self.number = number_

	for i,v in pairs(self.sounds) do
		self.sounds[i].sound = ED_AudioAPI.createSource(host, v.sdef_name)
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

	sound_param = {
		--[SOUND_CORE_RPM] = coreRPM,
		[SOUND_FAN_RPM] = fanRPM,
		[SOUND_TURBINE_POWER] = turbPower,
		--[SOUND_THRUST] = thrust,
		[SOUND_TRUE_AIRSPEED] = vTrue,
	}

	for i, v in pairs(self.sounds) do
		param_value = sound_param[v.type]
		self:controlSound(v.sound, v.pitch_curve:value(param_value), v.gain_curve:value(param_value), nil)
	end
	
end

