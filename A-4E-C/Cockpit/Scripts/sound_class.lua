



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

function Sound_Player.new(sndhost, sound_file, param, type, min_speed, max_speed, factor, fade)
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

function Sound_Player:update()
    if self.type == SOUND_CONTINUOUS then
        self:updateContinuous()
    elseif self.type == SOUND_ONCE then
        self:updateOnce()
    elseif self.type == SOUND_ALWAYS then
        self:updateAlways()
    end
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