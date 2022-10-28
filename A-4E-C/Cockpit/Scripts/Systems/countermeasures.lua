----------------------------------------------------------------
-- COUNTERMEASURES SYSTEM
----------------------------------------------------------------
-- This module will handle the dispensing of countermeasures
-- This module models the AN/ALE-29A Chaff Dispensing System
----------------------------------------------------------------

dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")
dofile(LockOn_Options.script_path.."utils.lua")

local CMS = GetSelf()

local update_rate = 0.006
make_default_activity(update_rate)

startup_print("countermeasures: load")

function debug_print(x)
    -- print_message_to_user(x)
    -- log.alert(x)
end

local sensor_data = get_base_data()

-- constants
local AUTO_MODE_MIN_INTERVAL = 30

-- countermeasure state
local chaff_count = 0
local flare_count = 0
local cm_bank1_show = 0
local cm_bank2_show = 0
local cm_bank1_count = 0
local cm_bank2_count = 0
local cm_banksel = "both"
local cm_auto_mode = false
local cm_enabled = false
local ECM_status = false
local cms_bank1_pos = 0
local cms_bank2_pos = 0
local cms_dispense = false
local cms_manual_salvo_dispense = false
local burst_counter = 0
local salvo_counter = 0
local cm_bank1_type = nil
local cm_bank2_type = nil

-- cms programmer settings
local cms_bursts_setting = 1
local cms_burst_interval_setting = 0.2
local cms_salvos_setting = 8
local cms_salvo_interval_setting = 2

-- cms programmer settings array
local cms_bursts_setting_array = { 1, 2, 3, 4 }
local cms_burst_interval_setting_array = { 0.2, 0.3, 0.4, 0.5}
local cms_salvos_setting_array = { 8, 12, 16, 20, 24, 28, 32 }
local cms_salvo_interval_setting_array = { 2, 4, 6, 8, 10, 12, 14 }

local cms_bursts_setting_array_pos = 1
local cms_burst_interval_setting_array_pos = 1
local cms_salvos_setting_array_pos = 1
local cms_salvo_interval_setting_array_pos = 1

-- timers
local time_ticker = 0
local last_burst_time = 0

-- missile launch checks
local missile_threat_state = false
local previous_threat_state = false
local rwr_status = get_param_handle("RWR_STATUS_SIGNAL")
local auto_mode_ticker = 0

-- params for kneeboard
local cms_bursts_param          = get_param_handle("CMS_BURSTS_PARAM")
local cms_burst_interval_param  = get_param_handle("CMS_BURST_INTERVAL_PARAM")
local cms_salvos_param          = get_param_handle("CMS_SALVOS_PARAM")
local cms_salvo_interval_param  = get_param_handle("CMS_SALVO_INTERVAL_PARAM")

CMS:listen_command(device_commands.cm_pwr)
CMS:listen_command(device_commands.cm_bank)
CMS:listen_command(device_commands.cm_adj1)
CMS:listen_command(device_commands.cm_adj2)
CMS:listen_command(device_commands.cm_auto)
CMS:listen_command(iCommandActiveJamming)
CMS:listen_command(iCommandPlaneDropFlareOnce)
CMS:listen_command(iCommandPlaneDropChaffOnce)
CMS:listen_command(Keys.JATOFiringButton)
CMS:listen_command(Keys.CmBankSelectRotate)
CMS:listen_command(Keys.CmBankSelectToggle)
CMS:listen_command(Keys.CmBankSelect)
CMS:listen_command(Keys.CmAutoButton)
CMS:listen_command(Keys.CmBank1AdjUp)
CMS:listen_command(Keys.CmBank1AdjDown)
CMS:listen_command(Keys.CmBank2AdjUp)
CMS:listen_command(Keys.CmBank2AdjDown)
CMS:listen_command(Keys.CmPowerToggle)
CMS:listen_command(Keys.ChangeCmsBursts)
CMS:listen_command(Keys.ChangeCmsBurstInterval)
CMS:listen_command(Keys.ChangeCmsSalvos)
CMS:listen_command(Keys.ChangeSalvoInterval)

CMS:listen_event("WeaponRearmComplete")
CMS:listen_event("UnlimitedWeaponStationRestore")

local cm_bank1_Xx = get_param_handle("CM_BANK1_Xx")
local cm_bank1_xX = get_param_handle("CM_BANK1_xX")
local cm_bank2_Xx = get_param_handle("CM_BANK2_Xx")
local cm_bank2_xX = get_param_handle("CM_BANK2_xX")

local rpm_main = get_param_handle("RPM")

function cm_draw_bank1( count )
    local tens = math.floor(count/10 + 0.02)
    local ones = math.floor(count%10 + 0.02)

    --print_message_to_user("b1: "..tens.." "..ones)
    cm_bank1_Xx:set(tens/10)
    cm_bank1_xX:set(ones/10)
end

function cm_draw_bank2( count )
    local tens = math.floor(count/10 + 0.02)
    local ones = math.floor(count%10 + 0.02)

    --print_message_to_user("b2: "..tens.." "..ones)
    cm_bank2_Xx:set(tens/10)
    cm_bank2_xX:set(ones/10)
end

function update_countermeasures_display()
    cm_draw_bank1(cm_bank1_show)
    cm_draw_bank2(cm_bank2_show)
end

function release_countermeasure()
    debug_print("releasing countermeasures")

    if (cm_banksel == "bank_1" or cm_bank2_count < 1) and cm_bank1_count > 0 then
        debug_print("Dropping bank 1")
        if cm_bank1_type == "chaff" then
            CMS:drop_chaff(1, cms_bank1_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
        else
            CMS:drop_flare(1, cms_bank1_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
        end
        cm_bank1_count = cm_bank1_count - 1
        cm_bank1_show = (cm_bank1_show - 1) % 100

    elseif (cm_banksel == "bank_2" or cm_bank1_count < 1) and cm_bank2_count > 0 then
        debug_print("Dropping bank 2")
        if cm_bank2_type == "chaff" then
            CMS:drop_chaff(1, cms_bank2_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
        else
            CMS:drop_flare(1, cms_bank2_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
        end
        cm_bank2_count = cm_bank2_count - 1
        cm_bank2_show = (cm_bank2_show - 1) % 100

    elseif cm_banksel == "both" then

        -- release from bank 1
        if cm_bank1_count > 0 then
            debug_print("Dropping bank 1")
            if cm_bank1_type == "chaff" then
                CMS:drop_chaff(1, cms_bank1_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
            else
                CMS:drop_flare(1, cms_bank1_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
            end
            cm_bank1_count = cm_bank1_count - 1
            cm_bank1_show = (cm_bank1_show - 1) % 100
        end -- cm_bank1_count > 0

        -- release from bank 2
        if cm_bank2_count > 0 then
            debug_print("Dropping bank 2")
            if cm_bank2_type == "chaff" then
                CMS:drop_chaff(1, cms_bank2_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
            else
                CMS:drop_flare(1, cms_bank2_pos)  -- first param is count, second param is dispenser number (see chaff_flare_dispenser in aircraft definition)
            end
            cm_bank2_count = cm_bank2_count - 1
            cm_bank2_show = (cm_bank2_show - 1) % 100
        end -- cm_bank2_count > 0
    end -- if cm_banksel

    if LockOn_Options.flight.unlimited_weapons == true then
        update_countermeasure_quantity()
    end
    
    debug_print("Countermeasures remaining: Bank 1 = "..cm_bank1_count.." Bank 2 = "..cm_bank2_count)
    debug_print("Countermeasures remaining: Flares = "..tostring(CMS:get_flare_count()).." Chaff = "..tostring(CMS:get_chaff_count()))
end -- release_countermeasure()

function missile_warning_check()
    -- check for message from rwr
    if rwr_status:get() == 3 then
        missile_threat_state = 1

        -- if threat state is new
        if missile_threat_state ~= previous_threat_state and cm_auto_mode then
            cms_dispense = true
            -- start 30 second counter between start of auto sequence
            auto_mode_ticker = time_ticker
        end

        -- restart sequence if auto mode interval has passed and missile threat is still present
        if (time_ticker - auto_mode_ticker) > AUTO_MODE_MIN_INTERVAL and cm_auto_mode then
            cms_dispense = true
            -- start 30 second counter between start of auto sequence
            auto_mode_ticker = time_ticker
        end
    else
        missile_threat_state = 0
    end
end

function reset_auto_sequence()
    cms_dispense = false
    salvo_counter = 0
    burst_counter = 0
end

function update_cms_params()
    cms_bursts_setting          = cms_bursts_setting_array[cms_bursts_setting_array_pos]
    cms_burst_interval_setting  = cms_burst_interval_setting_array[cms_burst_interval_setting_array_pos]
    cms_salvos_setting          = cms_salvos_setting_array[cms_salvos_setting_array_pos]
    cms_salvo_interval_setting  = cms_salvo_interval_setting_array[cms_salvo_interval_setting_array_pos]

    cms_bursts_param:set(cms_bursts_setting)
    cms_burst_interval_param:set(cms_burst_interval_setting)
    cms_salvos_param:set(cms_salvos_setting)
    cms_salvo_interval_param:set(cms_salvo_interval_setting)
end -- update_cms_params()

function update_countermeasure_quantity()
    -- fill dispensers with chaff
    chaff_count     = CMS:get_chaff_count()
    if chaff_count > 0 then
        -- fill bank 1 with chaff
        cm_bank1_type = "chaff"
        cm_bank1_count = 30
    end
    
    -- fill bank 2 with chaff if more than 30 chaff
    if chaff_count > 30 then
        cm_bank2_type = "chaff"
        cm_bank2_count = 30
    end

    -- fill dispensers with chaff
    flare_count     = CMS:get_flare_count()
    if flare_count > 0 then
        cm_bank2_type = "flare"
        cm_bank2_count = 30
    end
    
    -- fill bank 2 with flare if more than 30 flare
    if flare_count > 30 then
        -- fill bank 1 with flare
        cm_bank1_type = "flare"
        cm_bank1_count = 30
    end

    cm_bank1_show   = cm_bank1_count
    cm_bank2_show   = cm_bank2_count
    
end -- update_countermeasure_quantity()

function post_initialize()
    cm_banksel      = "both"
    
    update_countermeasure_quantity()
    
    -- init values from mission options
    cms_bursts_setting_array_pos          = get_aircraft_property("CMS_BURSTS")
    cms_burst_interval_setting_array_pos  = get_aircraft_property("CMS_BURST_INTERVAL")
    cms_salvos_setting_array_pos          = get_aircraft_property("CMS_SALVOS")
    cms_salvo_interval_setting_array_pos  = get_aircraft_property("CMS_SALVO_INTERVAL")
    
    update_cms_params()

end -- post_initialize()


function update()

    -- increment the internal timer
    time_ticker = time_ticker + update_rate

    -- update missile warning status
    -- NOTE: Turns out the RWR link requires the AN/ALE-39 which this aircraft doesn't have.
    -- missile_warning_check()

    -- check if monitored dc bus power is available
    -- check if AN/ALE-29A panel is on
    if get_elec_mon_dc_ok() and cm_enabled then

        -- check if dispense should be dispensing
        if cms_dispense then
            -- continue burst sequence if not completed
            if burst_counter < cms_bursts_setting then
                -- debug_print("running burst sequence")
                -- check if burst interval is reached
                if (time_ticker - last_burst_time) > cms_burst_interval_setting then
                    release_countermeasure()
                    last_burst_time = time_ticker
                    burst_counter = burst_counter + 1
                    
                    -- check if burst sequence complete. Mark end time if completed.
                    if burst_counter == cms_bursts_setting then
                        last_salvo_time = time_ticker
                    end
                end

            -- start new salvo if interval reached
            elseif salvo_counter < cms_salvos_setting then
                -- restart burst sequence if salvo interval is met
                if (time_ticker - last_salvo_time) > cms_salvo_interval_setting then
                    salvo_counter = salvo_counter + 1

                    -- stop dispensing if salvos are completed
                    if salvo_counter == cms_salvos_setting then
                        debug_print("sequence complete: salvo")
                        cms_dispense = false
                        salvo_counter = 0
                        burst_counter = 0

                    -- start next salvo if sequence is not completed
                    else
                        debug_print("starting next salvo "..salvo_counter)
                        burst_counter = 0
                    end
                end

            -- stop dispensing if bursts and salvos completed
            elseif burst_counter == cms_bursts_setting and salvo_counter == cms_salvos_setting then
                debug_print("sequence complete")
                cms_dispense = false
                salvo_counter = 0
                burst_counter = 0
            end
        end -- cms_dispense

        -- single salvo manual dispense (power on, jato button pressed)
        if cms_manual_salvo_dispense == true and cms_dispense == false then
            -- continue burst sequence if not completed
            if burst_counter < cms_bursts_setting then
                -- debug_print("running burst sequence")
                -- check if burst interval is reached
                if (time_ticker - last_burst_time) > cms_burst_interval_setting then
                    release_countermeasure()
                    last_burst_time = time_ticker
                    burst_counter = burst_counter + 1
                    
                    -- check if burst sequence complete. Mark end time if completed.
                    if burst_counter == cms_bursts_setting then
                        last_salvo_time = time_ticker
                    end
                end

            -- stop dispensing if bursts and salvos completed
            elseif burst_counter == cms_bursts_setting then
                debug_print("sequence complete")
                cms_manual_salvo_dispense = false
                burst_counter = 0
            end
        end -- cms_manual_salvo_dispense


    end -- get_elec_mon_dc_ok() and        

        update_countermeasures_display()

end -- update()

function SetCommand(command, value)

    if command == device_commands.cm_pwr then
        cm_enabled = (value > 0) and true or false
        if value == 0 then reset_auto_sequence() end -- end auto sequence if power is turned off

    elseif command == device_commands.cm_bank then
        if value == -1 then cm_banksel = "bank_1" -- bank 1
        elseif value == 1 then cm_banksel = "bank_2" -- bank 2
        else cm_banksel = "both" -- both
        end

    elseif command == device_commands.cm_auto then
        -- cm_auto_mode = (value > 0) and true or false
        if cm_enabled and get_elec_mon_dc_ok() and get_elec_retraction_release_airborne() then
            cms_dispense = true
        end
        

    elseif command == device_commands.cm_adj1 then
        --print_message_to_user("value = "..value)
        cm_bank1_show = round(cm_bank1_show + 5*value)
        cm_bank1_show = cm_bank1_show % 100

    elseif command == device_commands.cm_adj2 then
        --print_message_to_user("value = "..value)
        cm_bank2_show = round(cm_bank2_show + 5*value)
        cm_bank2_show = cm_bank2_show % 100

    elseif command == Keys.JATOFiringButton then
        if cm_enabled and get_elec_mon_dc_ok() and get_elec_retraction_release_airborne() then
            if cms_dispense then
                release_countermeasure()
            else
                cms_manual_salvo_dispense = true
            end
        end

    elseif command == Keys.CmBankSelect then
        CMS:performClickableAction(device_commands.cm_bank, value, false)

    elseif command == Keys.CmBankSelectRotate then
        --up goes to middle (0), middle goes to down (+1), down goes to up (-1)
        if cm_banksel == "bank_1" then
            CMS:performClickableAction(device_commands.cm_bank, 0, false)
        elseif cm_banksel == "bank_2" then
            CMS:performClickableAction(device_commands.cm_bank, -1, false)
        elseif cm_banksel == "both" then
            CMS:performClickableAction(device_commands.cm_bank, 1, false)
        end
    elseif command == Keys.CmBankSelectToggle then
        if cm_banksel == "bank_1" then
            CMS:performClickableAction(device_commands.cm_bank, 1, false)
        elseif cm_banksel == "bank_2" then
            CMS:performClickableAction(device_commands.cm_bank, -1, false)
        elseif cm_banksel == "both" then
            CMS:performClickableAction(device_commands.cm_bank, -1, false)
        end

    elseif command == Keys.CmAutoButton then
        CMS:performClickableAction(device_commands.cm_auto, 1, false)

    elseif command == Keys.CmBank1AdjUp then
        CMS:performClickableAction(device_commands.cm_adj1, 0.15, false)

    elseif command == Keys.CmBank1AdjDown then
        CMS:performClickableAction(device_commands.cm_adj1, -0.15, false)
    
    elseif command == Keys.CmBank2AdjUp then
        CMS:performClickableAction(device_commands.cm_adj2, 0.15, false)
    
    elseif command == Keys.CmBank2AdjDown then
        CMS:performClickableAction(device_commands.cm_adj2, -0.15, false)
    
    elseif command == Keys.CmPowerToggle then
        if cm_enabled then
            CMS:performClickableAction(device_commands.cm_pwr, 0, false)
        else
            CMS:performClickableAction(device_commands.cm_pwr, 1, false)
        end
    
    elseif command == iCommandActiveJamming then
        if ECM_status then
            CMS:set_ECM_status(false)
        else
            CMS:set_ECM_status(true)
        end

    -- bindings for kneeboard command changes
    elseif command == Keys.ChangeCmsBursts then
        -- check for weight on wheels and engine off
        if (sensor_data.getWOW_LeftMainLandingGear() > 0 and rpm_main:get() < 2.0) then
            -- cycle to next value in array
            cms_bursts_setting_array_pos = next(cms_bursts_setting_array_pos, 1, table.getn(cms_bursts_setting_array))
            update_cms_params()
        end
        
    elseif command == Keys.ChangeCmsBurstInterval then
        -- check for weight on wheels and engine off
        if (sensor_data.getWOW_LeftMainLandingGear() > 0 and rpm_main:get() < 2.0) then
            -- cycle to next value in array
            cms_burst_interval_setting_array_pos = next(cms_burst_interval_setting_array_pos, 1, table.getn(cms_burst_interval_setting_array))
            update_cms_params()
        end

    elseif command == Keys.ChangeCmsSalvos then
        -- check for weight on wheels and engine off
        if (sensor_data.getWOW_LeftMainLandingGear() > 0 and rpm_main:get() < 2.0) then
            -- cycle to next value in array
            cms_salvos_setting_array_pos = next(cms_salvos_setting_array_pos, 1, table.getn(cms_salvos_setting_array))
            update_cms_params()
        end

    elseif command == Keys.ChangeSalvoInterval then
        -- check for weight on wheels and engine off
        if (sensor_data.getWOW_LeftMainLandingGear() > 0 and rpm_main:get() < 2.0) then
            -- cycle to next value in array
            cms_salvo_interval_setting_array_pos = next(cms_salvo_interval_setting_array_pos, 1, table.getn(cms_salvo_interval_setting_array))
            update_cms_params()
        end

    end
end -- setCommand()

function CockpitEvent(event, val)
    if event == "WeaponRearmComplete" or event == "UnlimitedWeaponStationRestore" then
        update_countermeasure_quantity()
    end
end

function next(value_to_increment, increment_by, modulus)
    return ((value_to_increment + increment_by - 1) % modulus) + 1
end


startup_print("countermeasures: load complete")

need_to_be_closed = false -- close lua state after initialization