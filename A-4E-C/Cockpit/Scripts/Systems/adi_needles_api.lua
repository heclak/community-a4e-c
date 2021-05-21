dofile(LockOn_Options.script_path.."devices.lua")


adi_needles_api = {
    glideslope_needle_param = get_param_handle("BDHI_ILS_GS"),
    localiser_needle_param = get_param_handle("BDHI_ILS_LOC"),


    glideslope_param = get_param_handle("API_ADI_GS_TARGET"),
    localiser_param = get_param_handle("API_ADI_LOC_TARGET"),
    device_param = get_param_handle("API_ADI_NEEDLES_DEVICE_SELECTED"),

    device_priority = {
        [0] = 0,
        [devices.SHRIKE] = 3,
        [devices.MCL] = 2,
        [devices.NAV] = 1,
    },
}

function adi_needles_api:setTarget(device, glideslope, localiser)
    self:claimNeedles(device)

    if device == self.device_param:get() then
        self.glideslope_param:set(glideslope)
        self.localiser_param:set(localiser)
    end
end

function adi_needles_api:getLocaliserTarget()
    return self.localiser_param:get()
end

function adi_needles_api:getGlideslopeTarget()
    return self.glideslope_param:get()
end

function adi_needles_api:claimNeedles(device)
    local current_device = self.device_param:get()

    if device == current_device then
        return
    end

    --If our device has higher priority steal the needles.
    if self.device_priority[device] > self.device_priority[current_device] then
        self.device_param:set(device)
    end
end

function adi_needles_api:releaseNeedles(device)
    --Can only release the needles if they are yours.
    if device == self.device_param:get() then
        self.device_param:set(0)
        self.glideslope_param:set(-1)
        self.localiser_param:set(-1)
    end
end
