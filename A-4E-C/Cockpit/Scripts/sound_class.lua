dofile(LockOn_Options.script_path.."utils.lua")


Sound_Player = {}
Sound_Player.__index = Sound_Player
setmetatable(Sound_Player,
{
    __call = function (cls, ...)
        return cls.new(...)
    end
})

SOUND_CONTINUOUS = 1
SOUND_ONCE = 2
SOUND_ALWAYS = 3
SOUND_ALWAYS_CONTROLLED = 4
SOUND_CONTINUOUS_STOPABLE = 5

function Sound_Player.new(sndhost, sound_file, param, type, min_speed, max_speed, factor, fade, volume_param)
    local self = setmetatable({}, Sound_Player)
    self.sound = sndhost:create_sound(sound_file)
    self.type = type or SOUND_ONCE
    self.param = get_param_handle(param)
    self.param_string = param
    self.played = false
    self.min_speed = min_speed or nil
    self.max_speed = max_speed or nil
    self.factor = factor or 3.0
    self.fade = fade or 0.0
    self.volume = 0.0
    self.airspeed_param = get_param_handle("FM_AIRSPEED")
    self.volume_param = get_param_handle(volume_param)

    --self.update_fnc = nil

    if self.type == SOUND_CONTINUOUS then
        self.update = self.updateContinuous
    elseif self.type == SOUND_ONCE then
        self.update = self.updateOnce
    elseif self.type == SOUND_ALWAYS then
        self.update = self.updateAlways
    elseif self.type == SOUND_CONTINUOUS_STOPABLE then
        self.update = self.updateContinuousStopable
    end

    return self
end

function Sound_Player.new_always_controlled(sndhost, sound_file, param, volume, pitch)
    local self = setmetatable({}, Sound_Player)
    self.sound = sndhost:create_sound(sound_file)
    self.type = SOUND_ALWAYS_CONTROLLED
    self.param = get_param_handle(param)
    self.param_string = param

    self.volume_curve = Curve(volume.curve, volume.min, volume.max)
    self.pitch_curve = Curve(pitch.curve, pitch.min, pitch.max)

    self.update = self.updateAlwaysControlled
    return self
end

function Sound_Player:updateOnce()
    --print_message_to_user(self.param:get())
    if not self.sound:is_playing() then
        if self.param:get() >= 1.0 then
            if not self.played then
                self.sound:play_once()
                --print_message_to_user("Playing Sound "..self.param_string.." once.")
                self.played = true
            end
        elseif self.param:get() <= 0.0 and self.played then
            self.played = false
        end
    end

    if self.volume_param ~= nil then
        self.sound:update(nil, self.volume_param:get(), nil)
    end

end

function Sound_Player:updateContinuousStopable()
    --print_message_to_user(self.param:get())
    if not self.sound:is_playing() then
        if self.param:get() >= 1.0 then
            if not self.played then
                self.sound:play_continue()
                --print_message_to_user("Playing Sound "..self.param_string.." once.")
                self.played = true
            end
        elseif self.param:get() <= 0.0 and self.played then
            self.played = false
        end
    elseif self.param:get() <= 0.0 then
        self.sound:stop()
        self.played = false
    end


    if self.volume_param ~= nil then
        self.sound:update(nil, self.volume_param:get(), nil)
    end

end

function Sound_Player:updateContinuous()
    if self.param:get() >= 1.0 then
        if not self.sound:is_playing() then
            self.sound:play_continue()
            --print_message_to_user("Playing Sound "..self.param_string.." continuous.")
            self.played = true
        end
    elseif self.param:get() <= 0.0 and self.played then
        self.sound:stop()
        self.played = false
    end

    if self.volume_param ~= nil then
        self.sound:update(nil, self.volume_param:get(), nil)
    end
end

function Sound_Player:updateAlways()
    if not self.sound:is_playing() then
        self.sound:play_continue()
        --print_message_to_user("Playing Sound "..self.param_string.." always.")
    end

    local desiredVolume = self.param:get()
    if self.fade ~= 0.0 then
        local diff = desiredVolume - self.volume
        local dv = 1.0 / self.fade

        if math.abs(diff) < dv then
            self.volume = desiredVolume
        elseif diff < 0.0 then
            self.volume = self.volume - dv
        elseif diff > 0.0 then
            self.volume = self.volume + dv
        end
    else
        self.volume = desiredVolume
    end

    self.sound:update(nil, math.pow(self.volume,self.factor) * self:airspeedGain() , 0.0)
end

function Sound_Player:updateAlwaysControlled()
    if not self.sound:is_playing() then
        self.sound:play_continue()
    end

    local x = self.param:get()
    --print_message_to_user(self.volume_curve:value(x))

    --print_message_to_user(self.pitch_curve:value(x))

    self.sound:update(self.pitch_curve:value(x), self.volume_curve:value(x), nil)
    --self.sound:update(nil, nil, nil)
end

--Lerp the gain from the desired airspeeds
function Sound_Player:airspeedGain()

    if self.min_speed == nil or self.max_speed == nil then
        return 1.0
    end

    local value = (self:airspeed() - self.min_speed) / (self.max_speed - self.min_speed)
    return math.pow(math.max(math.min(value, 1.0), 0.0), 3)
end

function Sound_Player:airspeed()
    return math.abs(self.airspeed_param:get())
end