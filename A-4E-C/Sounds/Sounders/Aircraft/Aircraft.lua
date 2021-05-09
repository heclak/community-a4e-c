dofile("Tools.lua")

host = ED_AudioAPI.createHost(ED_AudioAPI.ContextWorld, "Aircraft")
ED_AudioAPI.setHostSonicBoom(host, ED_AudioAPI.SonicBoomAircraft, 1.0)

aircraft = {engines = {}, cockpit = {}, APU = {initialized = false}}
aircraft.cockpit.initialized = false
aircraft.cockpit.hostPosition = {-0.7, -0.5, 0}

function aircraft:new()
	o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

-- stub for now
function aircraft:createEngines()
	
end

function aircraft:createAPU(APUin, APUhost)
	self.APU.item = APUin
	self.APU.item:create(APUhost)
	self.APU.initialized = true
end

function aircraft:createAPUcpt(APUhostCpt, path)
	if self.APU.initialized then
		self.APU.item:createCpt(APUhostCpt, path)
	end
end

function aircraft:createEnginesCpt(hostCpt)
	for k, v in pairs(self.engines) do
		v:createSoundsCpt(hostCpt)
	end
end

function aircraft:destroyEnginesCpt()
	for k, v in pairs(self.engines) do
		v:destroySoundsCpt()
	end
end

function aircraft:createCockpit()
	self.cockpit.host           = ED_AudioAPI.createHost(ED_AudioAPI.ContextCockpit, "cockpitMain")
	ED_AudioAPI.setHostPosition(self.cockpit.host, self.cockpit.hostPosition[1], self.cockpit.hostPosition[2], self.cockpit.hostPosition[3])
	self.cockpit.hostHeadphones = ED_AudioAPI.createHost(ED_AudioAPI.ContextHeadphones, "cockpitHeadphones")
	self.cockpit.hostCpt2D      = ED_AudioAPI.createHost(ED_AudioAPI.ContextCockpit2D, "cockpit2D")
	
	self.cockpit.initialized = true
	
	self:createEnginesCpt(self.cockpit.hostCpt2D)
	
	self.cockpit.sndGbreath     = ED_AudioAPI.createSource(self.cockpit.hostCpt2D, "Aircrafts/Cockpits/GBreath")
	self.cockpit.sndGbreathEnd  = ED_AudioAPI.createSource(self.cockpit.hostCpt2D, "Aircrafts/Cockpits/GBreath_End")
end

function aircraft:releaseCockpit()
	self:destroyEnginesCpt()
	
	ED_AudioAPI.destroyHost(self.cockpit.host)
	ED_AudioAPI.destroyHost(self.cockpit.hostHeadphones)
	ED_AudioAPI.destroyHost(self.cockpit.hostCpt2D)

	self.cockpit.initialized = false
end

local gBreathActive = false

function aircraft:updateGbreath(params)
	if params.GbreathEnabled == 1 then
		if not gBreathActive and params.pilotGforceFiltered > 3.9 then
			ED_AudioAPI.playSourceLooped(self.cockpit.sndGbreath)
			gBreathActive = true
		elseif gBreathActive and params.pilotGforceFiltered < 3.5 then
			ED_AudioAPI.stopSource(self.cockpit.sndGbreath)
			ED_AudioAPI.playSourceOnce(self.cockpit.sndGbreathEnd)
			gBreathActive = false
		end
	end
end

function aircraft:onInit(params)
	params.GbreathEnabled = 0
	params.pilotGforceFiltered = 1
end

function aircraft:onUpdate(params)
	updateHost(host, params)

	for k, v in pairs(self.engines) do
		if params.DBG_playEngines == 0 then
			v:DBGstop()
		else
			v:update(params["coreRPM_"..k], params["fanRPM_"..k], params["turbPower_"..k], params["thrust_"..k], params["flame_"..k], params["vTrue"])
		end
	end
	
	if self.APU.initialized then
		self.APU.item:update(params)
	end

	if self.cockpit.initialized then
		self:updateGbreath(params)
	end
end

function onEvent_cockpitCreate()
	aircraft:createCockpit()
end

function onEvent_cockpitDestroy()
	aircraft:releaseCockpit()
end

function onUpdate(params)
	aircraft:onUpdate(params)
end
