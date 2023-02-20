
dofile("Aircraft/Planes/Plane.lua")

A4EC = plane:new()

dofile("Aircraft/Engines/J52P8.lua")
--dofile("Aircraft/Engines/APUs/BasicAPU.lua")

function A4EC:createEngines()
	self.engines[1] = J52P8:new()
	self.engines[1]:init(1, host)
end


A4EC:createEngines()

function onUpdate(params)
	A4EC:onUpdate(params)
end