dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
local dev 	    = GetSelf()

GUI = {
}

-- device which just dumps _G via log.alert

local update_time_step = 1 --update will be called once per second

if make_default_activity then  -- not all device types implement this
    make_default_activity(update_time_step)
end

dumped = false
function update()
    if not dumped then
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
        m=getmetatable(dev)
        str=dump("GetSelf meta",m)
        local lines=strsplit("\n",str)
        for k,v in ipairs(lines) do
            log.alert(v)
        end
        dumped = true
    end
end

function post_initialize() -- not all devices call this
    update()
end

function SetCommand(command,value)
    print_message_to_user("SetCommand in dump_device: "..tostring(command).."="..tostring(value))

end


need_to_be_closed = false -- close lua state after initialization



--[[

strings from CockpitBase.dll starting with "av"  (for avionics?):

avA11Clock nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avA2GRadar fails

avAChS_1 nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avADF

avADI
GetSelf meta["__index"]["get_sideslip"] = function: 00000000CE41A760
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE41A280
GetSelf meta["__index"]["get_bank"] = function: 00000000CE41A6C0
GetSelf meta["__index"]["listen_event"] = function: 00000000CE41A370
GetSelf meta["__index"]["get_pitch"] = function: 00000000CE41A410
GetSelf meta["__index"]["listen_command"] = function: 00000000CE41A2D0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE41A190

avAGB_3K

avAHRS

avAN_ALE_40V

avAN_ALR69V

avA_RV_Altimeter

avActuator

avActuator_BasicTimer

avAirDrivenDirectionalGyro

avAirDrivenTurnIndicator

avArcadeRadar

avArtificialHorizon

avArtificialHorizont_AN5736

avAutostartDevice

avAvionicsDataProxyDefault fails

avBaseARC fails

avBaseASP_3 nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avBaseIKP
GetSelf meta["__index"] = {}
GetSelf meta["__index"]["get_sideslip"] = function: 00000000CC825190
GetSelf meta["__index"]["listen_command"] = function: 00000000CC824D00
GetSelf meta["__index"]["listen_event"] = function: 00000000CC824DA0
GetSelf meta["__index"]["get_attitude_warn_flag_val"] = function: 00000000CC8252D0
GetSelf meta["__index"]["get_pitch_steering"] = function: 00000000CC825820
GetSelf meta["__index"]["get_track_deviation"] = function: 00000000CC825960
GetSelf meta["__index"]["get_airspeed_deviation"] = function: 00000000CC8258C0
GetSelf meta["__index"]["get_height_deviation"] = function: 00000000CC825A00
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC824CB0
GetSelf meta["__index"]["get_bank_steering"] = function: 00000000CC825780
GetSelf meta["__index"]["get_pitch"] = function: 00000000CC824E40
GetSelf meta["__index"]["get_steering_warn_flag_val"] = function: 00000000CC825230
GetSelf meta["__index"]["get_bank"] = function: 00000000CC8250F0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC824BC0

avBaseRadio fails

avBasicElectric fails

avBasicElectricInterface fails

avBasicHearingSensitivityInterface
GetSelf meta["__index"]["listen_event"] = function: 00000000CDB95870
GetSelf meta["__index"]["listen_command"] = function: 00000000CDB957D0
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CDB95780
GetSelf meta["__index"]["SetCommand"] = function: 00000000CDB95690

avBasicLightSystem fails

avBasicOxygenSystemInterface fails

avBasicSAI

avBasicSensor

avBasicSensor_SearchTimer

avBreakable fails

avBreakable_BasicTimer

avBreakable_WorkTimeFailureTimer

avChaffFlareContainer

avChaffFlareDispencer

avCommunicator fails

avDNS

avDevice

avDevice_BasicTimer

avDirectionalGyro_AN5735

avDispenseProgram

avEkranControl

avElectricSourceParamDriven fails

avElectricallyHeldSwitch

avElectroMagneticDetector

avFMProxyBase fails

avHSI

avHUD

avHUD_SEI31

avHelmet

avIFF_APX_72

avIFF_FuG25

avILS

avILS_AN_ARN108

avINS

avIRSensor

avIntercom:
GetSelf meta["__index"]["listen_command"] = function: 00000000CEBA3BD0
GetSelf meta["__index"]["listen_event"] = function: 00000000CEBA3C70
GetSelf meta["__index"]["set_communicator"] = function: 00000000CEBA3FC0
GetSelf meta["__index"]["is_communicator_available"] = function: 00000000CEBA3D10
GetSelf meta["__index"]["set_voip_mode"] = function: 00000000CEBA4060
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CEBA3B80
GetSelf meta["__index"]["get_noise_level"] = function: 00000000CEBA4100
GetSelf meta["__index"]["get_signal_level"] = function: 00000000CEBA41A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CEBA3A90


avIntercomWWII
GetSelf meta["__index"]["listen_command"] = function: 00000000CC122DD0
GetSelf meta["__index"]["listen_event"] = function: 00000000CC122E70
GetSelf meta["__index"]["set_communicator"] = function: 00000000CC1231C0
GetSelf meta["__index"]["is_communicator_available"] = function: 00000000CC122F10
GetSelf meta["__index"]["set_voip_mode"] = function: 00000000CC123260
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC122D80
GetSelf meta["__index"]["get_noise_level"] = function: 00000000CC123300
GetSelf meta["__index"]["get_signal_level"] = function: 00000000CC1233A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC122C90

avJammerInterface

avK14GunSight

avKneeboard nothing special
GetSelf meta["__index"]["listen_event"] = function: 00000000CE44AD30
GetSelf meta["__index"]["listen_command"] = function: 00000000CE44AC90
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE44AC40
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE44AB50

avKneeboardZoneObject

avLaserSpotDetector

avLinkToTargetResponder

avLuaDevice
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CC4194C0
GetSelf meta["__index"]["SetDamage"] = function: 00000000CC419650
GetSelf meta["__index"]["listen_event"] = function: 00000000CC4195B0
GetSelf meta["__index"]["listen_command"] = function: 00000000CC419510
GetSelf meta["__index"]["SetCommand"] = function: 00000000CC4193D0

avLuaRegistrable fails

avMLWS

avMagneticCompass

avMarkerReceiver

avMechCompass

avMechanicAccelerometer

avMechanicClock

avMissionTargetManager

avMovingMap

avMovingMapPoint

avMovingMap_Cursor

avNightVisionGoggles

avPadlock


avPlatform fails

avPlayerTaskHandler

avR73seeker

avRWR fails

avR_828

avRadarAltimeterBase fails

avRangefinder

avReceiver fails

avRemoteCompass_AN5730

avRemoteMagnetCompass

avRippReleaseCapable

avRollPitchGyro

avSNS

avSNS_GPS_GNSS_Listener

avSNS_GPS_Listener

avSidewinderSeeker fails

avSimpleAirspeedIndicator

avSimpleAltimeter

avSimpleElectricSystem
GetSelf meta["__index"]["get_DC_Bus_1_voltage"] = function: 00000000CD4E73D0
GetSelf meta["__index"]["get_DC_Bus_2_voltage"] = function: 00000000CD4E7470
GetSelf meta["__index"]["listen_command"] = function: 00000000CD4E68B0
GetSelf meta["__index"]["listen_event"] = function: 00000000CD4E6950
GetSelf meta["__index"]["get_AC_Bus_1_voltage"] = function: 00000000CD4E6E80
GetSelf meta["__index"]["AC_Generator_1_on"] = function: 00000000CD4E6CA0
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CD4E6860
GetSelf meta["__index"]["SetDamage"] = function: 00000000CD4E69F0
GetSelf meta["__index"]["AC_Generator_2_on"] = function: 00000000CD4E6D40
GetSelf meta["__index"]["get_AC_Bus_2_voltage"] = function: 00000000CD4E7330
GetSelf meta["__index"]["DC_Battery_on"] = function: 00000000CD4E6DE0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CD4E6770

avSimpleMachIndicator

avSimpleRWR
GetSelf meta["__index"]["reset"] = function: 00000000CD1FFE80
GetSelf meta["__index"]["set_power"] = function: 00000000CD1FFE30
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CD1FF950
GetSelf meta["__index"]["SetDamage"] = function: 00000000CD1FFAE0
GetSelf meta["__index"]["listen_event"] = function: 00000000CD1FFA40
GetSelf meta["__index"]["get_power"] = function: 00000000CD1FFD90
GetSelf meta["__index"]["listen_command"] = function: 00000000CD1FF9A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CD1FF860

avSimpleRadar

avSimpleRadarTimer

avSimpleTurnSlipIndicator fails

avSimpleVariometer

avSimpleWeaponSystem
GetSelf meta["__index"]["get_station_info"] = function: 00000000CD517F60
GetSelf meta["__index"]["listen_event"] = function: 00000000CD517300
GetSelf meta["__index"]["drop_flare"] = function: 00000000CD518140
GetSelf meta["__index"]["set_ECM_status"] = function: 00000000CD518B30
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CD517210
GetSelf meta["__index"]["get_ECM_status"] = function: 00000000CD518A90
GetSelf meta["__index"]["launch_station"] = function: 00000000CD5176F0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CD517120
GetSelf meta["__index"]["get_chaff_count"] = function: 00000000CD5180A0
GetSelf meta["__index"]["emergency_jettison"] = function: 00000000CD517E20
GetSelf meta["__index"]["set_target_range"] = function: 00000000CD517CE0
GetSelf meta["__index"]["set_target_span"] = function: 00000000CD517790
GetSelf meta["__index"]["get_flare_count"] = function: 00000000CD518000
GetSelf meta["__index"]["get_target_range"] = function: 00000000CD517D80
GetSelf meta["__index"]["get_target_span"] = function: 00000000CD517830
GetSelf meta["__index"]["SetDamage"] = function: 00000000CD5173A0
GetSelf meta["__index"]["drop_chaff"] = function: 00000000CD5189F0
GetSelf meta["__index"]["select_station"] = function: 00000000CD517650
GetSelf meta["__index"]["listen_command"] = function: 00000000CD517260
GetSelf meta["__index"]["emergency_jettison_rack"] = function: 00000000CD517EC0

avSlipBall

avSpot_SearchTimer

avTACAN fails

avTACAN_AN_ARN118

avTVSensor

avTW_Prime

avTransponder

avUGR_4K

avUHF_ARC_164
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

avUV_26

avVHF_ARC_186:
GetSelf meta["__index"]["listen_command"] = function: 00000000CE503600
GetSelf meta["__index"]["is_frequency_in_range"] = function: 00000000CE504030
GetSelf meta["__index"]["set_frequency"] = function: 00000000CE5039F0
GetSelf meta["__index"]["is_on"] = function: 00000000CE503B80
GetSelf meta["__index"]["get_frequency"] = function: 00000000CE503740
GetSelf meta["__index"]["performClickableAction"] = function: 00000000CE5035B0
GetSelf meta["__index"]["set_modulation"] = function: 00000000CE503A90
GetSelf meta["__index"]["set_channel"] = function: 00000000CE503B30
GetSelf meta["__index"]["listen_event"] = function: 00000000CE5036A0
GetSelf meta["__index"]["SetCommand"] = function: 00000000CE5034C0


avVHF_FuG16ZY

avVHF_SCR_522A

avVMS fails

avVMS_ALMAZ_UP

avWeap_ReleaseTimer_Activity


--]]