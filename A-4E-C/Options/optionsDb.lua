local DbOption  = require('Options.DbOption')
local Range 	= DbOption.Range
local i18n	    = require('i18n')
local oms       = require('optionsModsScripts')

local _ = i18n.ptranslate

-- find the relative location of optionsDb.lua
function script_path() 
    -- remember to strip off the starting @ 
	local luafileloc = debug.getinfo(2, "S").source:sub(2)
	local ti, tj = string.find(luafileloc, "Options")
	local temploc = string.sub(luafileloc, 1, ti-1)
    return temploc
end 

-- find module path
local relativeloc = script_path()
modulelocation = lfs.currentdir().."\\"..relativeloc

local tblCPLocalList = oms.getTblCPLocalList(modulelocation)

return {

	customPitchPressure		= DbOption.new():setValue(50):slider(Range(1,100)),
	customPitchRelease		= DbOption.new():setValue(0):slider(Range(0,100)),
	customRollPressure		= DbOption.new():setValue(50):slider(Range(1,100)),
	customRollRelease		= DbOption.new():setValue(100):slider(Range(0,100)),
	customRudderPressure	= DbOption.new():setValue(50):slider(Range(1,100)),
	customRudderRelease		= DbOption.new():setValue(100):slider(Range(0,100)),

	trimSpeedPitch			= DbOption.new():setValue(100):slider(Range(1,100)),
	trimSpeedRoll			= DbOption.new():setValue(100):slider(Range(1,100)),
	trimSpeedRudder			= DbOption.new():setValue(100):slider(Range(1,100)),

	throttleRate			= DbOption.new():setValue(1.0):slider(Range(1.00,5.00)),
	throttleAcceleration 	= DbOption.new():setValue(50):slider(Range(1.00,100.00)),

	cockpitShake 			= DbOption.new():setValue(100):slider(Range(0,200)),

	cssActivate				= DbOption.new():setValue(15):slider(Range(1,100)),

	wheelBrakeAssist        = DbOption.new():setValue(false):checkbox(),

	oldRadar       			= DbOption.new():setValue(false):checkbox(),

}
