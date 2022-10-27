num_contacts = 15
num_lines = 100
scope_radius = 0.035 * 0.9

function get_contacts()
    local contacts = 	{}

    for index = 1,num_contacts  do
        if index  < 10 then
            i = "_0".. index .."_"
        else
            i = "_".. index .."_"
        end

        contacts[index] =
        {
            elevation 	= get_param_handle("RWR_CONTACT" .. i .. "ELEVATION"),
            azimuth 		= get_param_handle("RWR_CONTACT" .. i .. "AZIMUTH"),
            power 		= get_param_handle("RWR_CONTACT" .. i .. "POWER"),
            unit_type			= get_param_handle("RWR_CONTACT" .. i .. "UNIT_TYPE"),
        
            general_type		= get_param_handle("RWR_CONTACT" .. i .. "GENERAL_TYPE"),
            priority		= get_param_handle("RWR_CONTACT" .. i .. "PRIORITY"),
            signal		= get_param_handle("RWR_CONTACT" .. i .. "SIGNAL"),
            time		= get_param_handle("RWR_CONTACT" .. i .. "TIME"),
            source		= get_param_handle("RWR_CONTACT" .. i .. "SOURCE"),
            
            unit_type_sym= get_param_handle("RWR_CONTACT" .. i .. "UNIT_TYPE_SYM"),
            unit_type_sym_num= get_param_handle("RWR_CONTACT" .. i .. "UNIT_TYPE_SYM_NUMERIC"),
            
            unit_type_is_num= get_param_handle("RWR_CONTACT" .. i .. "UNIT_TYPE_IS_NUMERIC"),
            power_sym 	= get_param_handle("RWR_CONTACT" .. i .. "POWER_SYM"),
            lock_sym 	= get_param_handle("RWR_CONTACT" .. i .. "LOCK_SYM"),
        }
    end

    return contacts
end

function get_lines()
    local lines = {}
    for i = 1, num_lines do
        lines[#lines + 1 ] = {
            x1_param = get_param_handle("RWR_LINE_X1_"..tostring(i)),
            y1_param = get_param_handle("RWR_LINE_Y1_"..tostring(i)),
            x2_param = get_param_handle("RWR_LINE_X2_"..tostring(i)),
            y2_param = get_param_handle("RWR_LINE_Y2_"..tostring(i)),
        }
    end
    return lines
end

SOLID = 0
DASHED = 1
DOTTED = 2

rwr_api = {
    contacts = get_contacts(),
    lines = get_lines(),
    lines_used = 0,
    line_settings = {
        [SOLID] = {gap = nil, length = nil},
        [DASHED] = {gap = 0.04, length = 0.08},
        [DOTTED] = {gap = 0.04, length = 0.04 },
    },

    ecm_param = get_param_handle("RWR_ECM_ON"),
}

function rwr_api:set_ecm(value)
    if value then
        self.ecm_param:set(1.0)
    else
        self.ecm_param:set(0.0)
    end
end

function rwr_api:get_ecm()
    return self.ecm_param:get() > 0.5
end

function rwr_api:get(i, item)
    
    if self.contacts[i] == nil then
        print_message_to_user(i)
    end
    
    return self.contacts[i][item]:get()
end

function rwr_api:reset()
    self.lines_used = 0
    for i =1, num_lines do
        self.lines[i].x1_param:set(0.0)
        self.lines[i].y1_param:set(0.0)
        self.lines[i].x2_param:set(0.0)
        self.lines[i].y2_param:set(0.0)
    end
end

function rwr_api:set(azimuth, power, type)

    if power ~= 0.0 then
        local line_settings = self.line_settings[type]
        self:draw_line(azimuth, power, line_settings.gap, line_settings.length)
    end
end

function rwr_api:set_line(i, x1, y1, x2, y2)
    self.lines[i].x1_param:set(x1)
    self.lines[i].y1_param:set(y1)
    self.lines[i].x2_param:set(x2)
    self.lines[i].y2_param:set(y2)
end

function rwr_api:draw_line(angle, radius, gap, length)
    
    if gap == nil or length == nil then
        rwr_api:create_line_raw(0.0, angle, radius)
    else
        local repeat_length = gap + length
        local n = math.floor(radius / repeat_length)

        for i = 0, (n-1) do
            rwr_api:create_line_raw(repeat_length * i, angle, length)
        end
    end
end

function rwr_api:create_line_raw(offset_radius, angle, length)

    offset_radius = offset_radius * scope_radius
    length = length * scope_radius

    self.lines_used = self.lines_used + 1

    angle = angle + math.pi/2.0

    local cosa = math.cos(angle)
    local sina = math.sin(angle)
    
    local r = offset_radius + length

    self.lines[self.lines_used].x1_param:set(offset_radius * cosa)
    self.lines[self.lines_used].y1_param:set(offset_radius * sina)
    self.lines[self.lines_used].x2_param:set(r * cosa)
    self.lines[self.lines_used].y2_param:set(r * sina)
end