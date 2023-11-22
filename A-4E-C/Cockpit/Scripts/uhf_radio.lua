dofile(LockOn_Options.common_script_path..'Radio.lua')
dofile(LockOn_Options.common_script_path.."mission_prepare.lua")

local gettext = require("i_18n")
_ = gettext.translate

dofile(LockOn_Options.script_path.."EFM_Data_Bus.lua")
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local dev 	    = GetSelf()

local efm_data_bus = get_efm_data_bus()

device_timer_dt = 0.2

innerNoise 			= getInnerNoise(2.5E-6, 10.0)--V/m (dB S+N/N)
frequency_accuracy 	= 500.0				--Hz
band_width			= 12E3				--Hz (6 dB selectivity)
power 				= 10.0				--Watts
goniometer = {isLagElement = true, T1 = 0.3, bias = {{valmin = math.rad(0), valmax = math.rad(360), bias = math.rad(1)}}}

agr = {
	input_signal_deviation		= rangeUtoDb(4E-6, 0.5), --Db
	output_signal_deviation		= 5 - (-4),  --Db
	input_signal_linear_zone 	= 10.0, --Db
	regulation_time				= 0.25, --sec
}

GUI = {
	range = {min = 225E6, max = 399.975E6, step = 25E3}, --Hz
	displayName = _('UHF Radio AN/ARC-164'),
	AM = true,
	FM = false,
}

--UHF_RADIO_FAILURE_TOTAL	= 0

--Damage = {	{Failure = UHF_RADIO_FAILURE_TOTAL, Failure_name = "UHF_RADIO_FAILURE_TOTAL", Failure_editor_name = _("UHF radio total failure"),  Element = 55, Integrity_Treshold = 0.25, work_time_to_fail_probability = 0.5, work_time_to_fail = 3600*300}}

local update_time_step = 1 --update will be called once per second
device_timer_dt = update_time_step

function post_initialize()
  efm_data_bus.fm_setAvionicsAlive(1.0)


  dev:set_frequency(243E6) -- GUARD
  --print_message_to_user(tostring(dev:get_frequency()))
  dev:set_modulation(MODULATION_AM) -- gives DCS.log INFO msg:  COCKPITBASE: avBaseRadio::ext_set_modulation not implemented, used direct set
  --print_message_to_user("Power before "..dev:get_power())
  
  --[[
  for k,v in pairs(getmetatable(dev)["__index"]) do
	print_message_to_user(tostring(k).." : "..tostring(v).."\n")
  end
  ]]--
  
  --recursively_print(dev, 30, 100, "C:/tmp/stuff1.txt")
  
  --radio_ptr = strsub(tostring(dev:link()), 10)
  str_ptr = string.sub(tostring(dev.link),10)
  efm_data_bus.fm_setRadioPTR(str_ptr)

  
  
  --print_message_to_user(string.sub(dev["link"],10))
	--print_message_to_user(GetDevice(devices.RADIO))
	
	--[[
	dev = GetDevice(devices.UHF_RADIO)
	print_message_to_user(tostring(dev))
	for k,v in pairs(getmetatable(dev)) do
		print_message_to_user(tostring(k).." : "..tostring(v))
	end
	
	for k,v in pairs(getmetatable(dev)["__index"]) do
		print_message_to_user(tostring(k).." : "..tostring(v))
	end
	--]]
	
	--print_message_to_user("Is on: "..tostring(dev:is_on()))
	
	--print_message_to_user("End")
  --print_message_to_user("Power after "..dev:get_power())
--[[
  GetSelf meta["__index"]["listen_command"] = function: 00000000CC631830
GetSelf meta["__index"]["is_frequency_in_range"] = function: 00000000CC632290
GetSelf meta["__index"]["set_frequency"] = function: 00000000CC631C20
GetSelf meta["__index"]["is_on"] = function: 00000000CC631DE0
GetSelf meta["__index"]["get_frequency"] = function: 00000000CC631970
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC6317E0
GetSelf meta["__index"]["set_modulation"] = function: 00000000CC631CC0
GetSelf meta["__index"]["set_channel"] = function: 00000000CC631D60
GetSelf meta["__index"]["listen_event"] = function: 00000000CC6318D0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC6316F0
--]]


  --log.alert("UHF radio: is_on="..tostring(dev:is_on())..",freq="..tostring(dev:get_frequency())..", is_f_in_r="..tostring(dev:is_frequency_in_range(256E6))    )
  -- UHF radio: is_on=false,freq=256000416, is_f_in_r=true
  -- need to figure out why is_on is false...
--[[
        local str=dump("_G",_G)
        local lines=strsplit("\n",str)
        for k,v in ipairs(lines) do
            log.alert(v)
        end
        str=dump("list_cockpit_params",list_cockpit_params())
        local lines=strsplit("\n",str)
        for k,v in ipairs(lines) do
            log.alert(v)
        end
--]]
end

--local iCommandToggleCommandMenu=179
--dev:listen_command(iCommandToggleCommandMenu)

local iCommandPlaneIntercomUHFPress=1172
dev:listen_command(iCommandPlaneIntercomUHFPress)

function listen_event()
	print_message_to_user("LISTEN_EVENT")
end


function SetCommand(command,value)
end


need_to_be_closed = false -- close lua state after initialization



