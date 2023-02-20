dofile("A4Tools.lua")
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
SOUND_THRUST = 3 -- I assume this is in Newtons
SOUND_TRUE_AIRSPEED = 4 --Airspeed I think is in m/s

J52P8 = {number = 0}

function J52P8:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	o.number = 1
	return o
end

function J52P8:init(number_, host)

	--[[
	Format:

	{
		sound = nil,
		type_pitch = <what is the x axis for the pitch curve>,
		type_gain = <what is the x axis for the gain curve>,
		sdef_name = <which sound sdef>,
		pitch_curve = Curve(<curve data>, <min>, <max>)
		gain_curve = Curve(<curve data>, <min>, <max>)
	}

	]]


	self.sounds = {
		--[[
			= = = = = = = = = = = = = = = = = = = = = = = = =
			SOUND DEFINITION FILES AND ASSETS
			= = = = = = = = = = = = = = = = = = = = = = = = =

			Localiztion, audible distance, and other imporant variables are set in the sdefs, see:
			/Sounds/sdef/Aircrafts/Engines/A-4E-C

			External sound assets are placed in 
			/Sounds/Effects/Aircrafts/Engines/A-4E-C
		
			= = = = = = = = = = = = = = = = = = = = = = = = =
			WARNING! WARNING! WARNING! WARNING! WARNING! 
			= = = = = = = = = = = = = = = = = = = = = = = = =
			DO NOT COPY OR USE THESE SOUNDS IN YOUR PROJECTS
			= = = = = = = = = = = = = = = = = = = = = = = = =

			The A-4E-C team purchased and licensed some assets 
        	to use in the creation of our engine sounds.
			While many parts of this project are open source, 
			these sounds are not. 

			While they are significantly transformed 
			from their original sources, taking these sounds 
			for use in your own project is theft: 
			not from the Community A-4E-C project, 
			but from the original licensors of the source material.

			Distributing these sounds puts YOU in legal jeopardy 
			should the licensors of the original assets find out,
			and rest assured, there are entire teams of people 
			whose entire livelihood is chasing theives down
			and making them pay (in spades). 

			The Community A-4E-C project is not reponsible 
			for your copyright infringement.

			= = = = = = = = = = = = = = = = = = = = = = = = =
			ENGINE SOUNDS
			= = = = = = = = = = = = = = = = = = = = = = = = =

			Loud, large-frequency spectrum sounds can easily damage your hearing.
			Be mindful of how loud you set sounds like this.
			Be mindful of how loud you set your volume in DCS World.
			Take regular breaks to give your ears and your brain a break.

			The engine has two signature tones, with a baseline curve across RPM.
			
			a LOW tone: 
			curve = {0.30, 0.61, 0.85, 1.00, 1.04, 1.09, 1.13},
			
			and a HIGH tone:
			curve = {0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33},
		
			These sounds are organized by aircraft orientation:
			The main groups are FRONT, AROUND and REAR.
			Each includes a low-operation tone, a high-operation tone, and a distant sound.

        	Gain volumes are set quite high, as this assists in drowning out
        	the default SU-25T engine sound scheme and providing a more theatrical
			fly-by sound. 
			
			DCS' sound engine prevents any digital clipping by automatically 
			lowering the mix of lower-gain sounds, so in addition to volume, 
			this variable should also be thought of as a kind of priority.

			In order to maintain consistency when the pilot opens the canopy, 
			asset signature frequencies and pitch curves should be replicated 
			on the interior sound set, see: 
			/Cockpit/Scripts/Systems/sound_system.lua

			= = = = = = = = = = = = = = = = = = = = = = = = =
			INTERPRETING ASSETS AND SDEFS
			= = = = = = = = = = = = = = = = = = = = = = = = =

			In addition to setting appropriate audible radiuses,
			driven by the inner_radius, outer_radius, silent_radius 
			and peak_radius variables, external engine sounds should 
			consider placement (away from the aircraft's origin/COG), and
			cone-broadcasting for sounds that head primarily to the front, 
			rear, or sides of the aircraft.

			For example, the engine RIP and ROAR are in a silent_radius
			in close proximity -- this prevents distracting and 
			inappropriate noise during formation flying.

			= = = = = = = = = = = = = = = = = = = = = = = = =
		]]


		-- FRONT
		-- It's the sound of air being sucked into the turbine.
		-- It has a swirling phasing sound, and a grinding signature tone.
		-- It lacks the lower frequencies present in other engine sounds.
		-- At higher speeds, a dramatic screaming ROAR is heard from a distance.
		{
			sound = nil,
			type_pitch = SOUND_FAN_RPM,
			type_gain = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_front_lo",
			pitch_curve = Curve({0.30, 0.61, 0.85, 1.00, 1.04, 1.09, 1.13}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.51, 0.60, 0.83, 0.84, 0.88, 1.00}, 0.01, 1.0),
		},
		{
			sound = nil,
			type_pitch = SOUND_FAN_RPM,
			type_gain = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_front_hi",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.10, 0.45, 0.65, 0.70, 0.98, 1.00}, 0.47, 1.0),
		},
		{
			sound = nil,
			type_pitch = SOUND_FAN_RPM,
			type_gain = SOUND_TRUE_AIRSPEED,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_far_roar",
			pitch_curve = Curve({0.66, 1.00, 1.33}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.04, 0.34, 0.84, 0.86, 0.93, 1.00}, 80.0, 340.0),
		},
		-- AROUND
		-- It's a full spectrum jet engine sound.
		-- It has elements of the front and rear sounds, with the full signatures of neither.
		-- It projects in a sphere, not in a cone, filling in missing frequenies from any direction.
		-- At high RPM, a WHINE is heard from a distance.
		{
			sound = nil,
			type_pitch = SOUND_FAN_RPM,
			type_gain = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_around_lo",
			pitch_curve = Curve({0.30, 0.61, 0.85, 1.00, 1.05, 1.08, 1.13}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.51, 0.60, 0.83, 0.84, 0.86, 1.00}, 0.01, 1.0),
		},
		{
			sound = nil,
			type_pitch = SOUND_FAN_RPM,
			type_gain = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_around_hi",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.10, 0.45, 0.65, 0.70, 0.98, 1.0}, 0.43, 1.0),
		},
		{
			sound = nil,
			type_pitch = SOUND_FAN_RPM,
			type_gain = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_far_whine",
			pitch_curve = Curve({0.30, 0.61, 0.85, 0.99, 1.10, 1.21, 1.33}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.64, 0.73, 0.77, 0.82, 0.91, 1.00}, 0.18, 1.0),
		},
		-- BACK
		-- It's the sound of air thrust out of the turbine.
		-- It has a loud, low roar.
		-- It lacks the higher frequencies present in other engine sounds.
		-- At higher speeds, a dramatic screaming RIP is heard from a distance.
		{
			sound = nil,
			type_pitch = SOUND_TURBINE_POWER,
			type_gain = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_back_lo",
			pitch_curve = Curve({0.30, 0.61, 0.85, 1.00, 1.05, 1.08, 1.13}, 0.01, 1.0),
			gain_curve = Curve({0.00, 0.51, 0.60, 0.83, 0.84, 0.86, 1.00}, 0.01, 1.0),
		},
		{
			sound = nil,
			type_pitch = SOUND_TURBINE_POWER,
			type_gain = SOUND_FAN_RPM,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_back_hi",
			pitch_curve = Curve({0.93, 1.00, 1.07}, 0.43, 1.0),
			gain_curve = Curve({0.00, 0.10, 0.45, 0.65, 0.70, 0.98, 1.00}, 0.43, 1.0),
		},
		{
			sound = nil,
			type_pitch = SOUND_FAN_RPM,
			type_gain = SOUND_TRUE_AIRSPEED,
			sdef_name = "Aircrafts/Engines/A-4E-C/a-4e_engine_ext_far_rip",
			pitch_curve = Curve({0.66, 1.00, 1.33}, 0.5, 1.0),
			gain_curve = Curve({0.00, 0.02, 0.4, 0.81, 0.90, 0.95, 1.00}, 80.0, 340.0),
		},

	}



	self:createSounds(number_, host)
end

function J52P8:createSounds(number_, host)
	self.number = number_

	for i,v in pairs(self.sounds) do
		self.sounds[i].sound = ED_AudioAPI.createSource(host, v.sdef_name)
	end
end

function J52P8:initCptNames()
	self.engine_l_name  = "Aircrafts/A-4E-C/a4e-debugtest05"
	self.engine_r_name  = "Aircrafts/A-4E-C/a4e-debugtest05"
	self.heAmb_l_name   = "Aircrafts/A-4E-C/a4e-debugtest05"
	self.heAmb_r_name   = "Aircrafts/A-4E-C/a4e-debugtest05"
end

function J52P8:createSoundsCpt(hostCpt)
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

function J52P8:destroySoundsCpt()
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

function J52P8:DBGstop()
	stopSRC = function(src)
		if src ~= nil then
			if ED_AudioAPI.isSourcePlaying(src) then
				a4_tools.dbgPrint("src: " .. src)
				ED_AudioAPI.stopSource(src)
			end
		end
	end
end

function J52P8:controlSound(snd, pitch, gain, offsetKey)
	if gain < 0.01 then
		ED_AudioAPI.stopSource(snd)
	elseif gain >= 0.01 then
		a4_tools.dbgPrint("pitch: " .. pitch)
		a4_tools.dbgPrint("gain: " .. gain)
	
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

function J52P8:update(coreRPM, fanRPM, turbPower, thrust, flame, vTrue)

	sound_param = {
		--[SOUND_CORE_RPM] = coreRPM,
		[SOUND_FAN_RPM] = fanRPM,
		[SOUND_TURBINE_POWER] = turbPower,
		--[SOUND_THRUST] = thrust,
		[SOUND_TRUE_AIRSPEED] = vTrue,
	}

	for i, v in pairs(self.sounds) do
		local param_gain = sound_param[v.type_gain]
		local param_pitch = sound_param[v.type_pitch]
		self:controlSound(v.sound, v.pitch_curve:value(param_pitch), v.gain_curve:value(param_gain), nil)
	end
	
end

