

Air_Data_Computer = {
    tas_handle = get_param_handle("ADC_TAS"),
    alt_handle = get_param_handle("ADC_ALT"),
    alt_setting_handle = get_param_handle("ADC_ALT_SETTING"),
}

function Air_Data_Computer:getTAS()
    return self.tas_handle:get()
end

function Air_Data_Computer:getBaroAlt()
    return self.alt_handle:get()
end

function Air_Data_Computer:setAltSetting(value)
    return self.alt_setting_handle:set(value)
end



