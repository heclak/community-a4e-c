

Air_Data_Computer = {
    tas_handle = get_param_handle("ADC_TAS"),
}

function Air_Data_Computer:getTAS()
    return self.tas_handle:get()
end



