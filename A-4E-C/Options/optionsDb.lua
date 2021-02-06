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
	trimSpeed				= DbOption.new():setValue(0):combo({DbOption.Item(_('100% (default)')):Value(0),
																DbOption.Item(_('50%')):Value(1),
																}),

	--[[catapultLaunchMode		= DbOption.new():setValue(0):combo({DbOption.Item(_('MIL Power')):Value(0),
																DbOption.Item(_('Manual')):Value(1),
																}),]]

	--catapultAlignmentCheck	= DbOption.new():setValue(true):checkbox(),

	--efmEnabled				= DbOption.new():setValue(true):checkbox(),

	cockpitShake 			= DbOption.new():setValue(100):slider(Range(0,200)),

	cssActivate				= DbOption.new():setValue(15):slider(Range(1,100)),
}
