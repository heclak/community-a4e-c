local gettext = require("i_18n")
_ = gettext.translate


BreatheCyclesPerMinute = 10

oxyPressurePointer = {valmin = 0, valmax = 500, T1 = 0.225, T2 = 0.112, bias = {{valmin = 0, valmax = 500, bias = 0.1}}}
flowBlinker = {valmin = 0, valmax = 1, dvalue = 0.9}

O2_Starvation_limit = 11000
StarvDeathTime = 300

ElecConsumerParamsWarnLight = {0.5, true}



breathCyclesPerMinute = 12 -- 10-18 per minute (from wikipedia)
exhaleToInhaleRatio = 1.4 -- 1.3 in calm state (from wikipedia)

oxygenVolumePointer = {isLagElement = true, valmin = 0, valmax = 10, T1 = 0.1, wmax = 1, bias = {{valmin = 0, valmax = 10, bias = 0.02}}}
oxygenPressurePointer = {valmin = 0, valmax = 500, T1 = 1, T2 = 0.22, bias = {{valmin = 0, valmax = 500, bias = 1}}}

oxygenTestRate = 1 -- liter per second

O2_Starvation_limit = 11000
StarvDeathTime = 600

OXYGEN_FAILURE_TOTAL	= 0

Damage = {	{Failure = OXYGEN_FAILURE_TOTAL, Failure_name = "OXYGEN_FAILURE_TOTAL", Failure_editor_name = _("Oxygen system total failure"),  Element = 10, Integrity_Treshold = 0.25, work_time_to_fail_probability = 0.5, work_time_to_fail = 3600*300}}
