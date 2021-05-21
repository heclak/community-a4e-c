--The purpose of this file is to interface with the EFM
-- beacon code for the TACAN.

tacan_efm_api = {
    x_param = get_param_handle("API_TCN_X"),
    y_param = get_param_handle("API_TCN_Y"),
    z_param = get_param_handle("API_TCN_Z"),
    object_name_param = get_param_handle("API_TCN_OBJECT_NAME"),
    object_id_param = get_param_handle("API_TCN_OBJECT_ID"),
    valid_param = get_param_handle("API_TCN_VALID"),
}

function tacan_efm_api:getPosition()
    return self.x_param:get(), self.y_param:get(), self.z_param:get()
end

function tacan_efm_api:isValid()
    return self.valid_param:get() > 0.5
end

function tacan_efm_api:setObjectName(name)
    self.object_name_param:set(name)
end

function tacan_efm_api:setObjectID(id)
    self.object_id_param:set(id)
end