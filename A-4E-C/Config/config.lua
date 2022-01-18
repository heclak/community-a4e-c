positions = {
    [1] = {x = 1.7, y = -0.5, z = -0.85},
    [2] = {x = 0.6, y = -0.13, z = -1.55},
    [3] = {x = 0.25, y = -0.135, z = -1.9},
    [4] = {x = -0.05, y = -0.14, z = -2.2},
    [5] = {x = -0.2, y = -0.14, z = -2.4},
    [6] = {x = -0.35, y = -0.145, z = -2.6},
    [7] = {x = -0.50, y = -0.15, z = -2.8},
    [8] = {x = -0.60, y = -0.16, z = -3.0},
    [9] = {x = -0.80, y = -0.16, z = -3.2},
    [10] = {x = -0.95, y = -0.16, z = -3.4},
}

--[[
positions = {
    [1] = {x = 1.7, y = -0.5, z = -0.85},
    [2] = {x = 0.6, y = -0.13, z = -1.55},
    [3] = {x = 0.25, y = -0.135, z = -1.9},
    [4] = {x = -0.05, y = -0.14, z = -2.2},
    [5] = {x = -0.3, y = -0.14, z = -2.4},
    [6] = {x = -0.45, y = -0.145, z = -2.6},
    [7] = {x = -0.65, y = -0.15, z = -2.8},
    [8] = {x = -0.80, y = -0.16, z = -3.0},
    [9] = {x = -1.0, y = -0.16, z = -3.2},
    [10] = {x = -1.15, y = -0.16, z = -3.4},
}


positions = {
    [1] = {x = 1.6, y = -0.5, z = -0.85},
    [2] = {x = 0.6, y = -0.24, z = -1.55},
    [3] = {x = 0.25, y = -0.24, z = -1.9},
    [4] = {x = -0.05, y = -0.245, z = -2.2},
    [5] = {x = -0.3, y = -0.25, z = -2.4},
    [6] = {x = -0.5, y = -0.255, z = -2.6},
    [7] = {x = -0.7, y = -0.26, z = -2.8},
    [8] = {x = -0.85, y = -0.27, z = -3.0},
    [9] = {x = -1.05, y = -0.27, z = -3.2},
    [10] = {x = -1.15, y = -0.27, z = -3.4},
}



]]


splines_both = {

    --left
    {
        {
            pos = {positions[1].x, positions[1].y, positions[1].z},
            vel = {0.0, 1.0, -1.0},
            radius = 0.3,
            opacity = 1.0,
        },
        {
            pos = {positions[1].x - 4.0, positions[1].y + 0.3, positions[1].z - 0.7},
            vel = {1.0, 0.0, -1.0},
            radius = 0.5,
            opacity = 1.0,
        },
    
    },
    
    {
        {
            pos = {positions[2].x, positions[2].y, positions[2].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.25,
            opacity = 1.0,
        },

        {
            pos = {positions[2].x - 3.2, positions[2].y + 0.15, positions[2].z - 0.2},
            vel = {-1.0, 0.0, 0.0},
            radius = 0.5,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[3].x, positions[3].y, positions[3].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[3].x - 2.6, positions[3].y + 0.10, positions[3].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[4].x, positions[4].y, positions[4].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[4].x - 2.2, positions[4].y + 0.05, positions[4].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[5].x, positions[5].y, positions[5].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[5].x - 2.0, positions[5].y + 0.05, positions[5].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[6].x, positions[6].y, positions[6].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[6].x - 1.8, positions[6].y + 0.05, positions[6].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[7].x, positions[7].y, positions[7].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[7].x - 1.6, positions[7].y + 0.05, positions[7].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[8].x, positions[8].y, positions[8].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[8].x - 1.4, positions[8].y + 0.05, positions[8].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[9].x, positions[9].y, positions[9].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[9].x - 1.3, positions[9].y + 0.05, positions[9].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.4,
            opacity = 1.0,
        },
    
    },

    {
        {
            pos = {positions[10].x, positions[10].y, positions[10].z},
            vel = {-1.0, 0.5, 0.0},
            radius = 0.15,
            opacity = 1.0,
        },

        {
            pos = {positions[10].x - 1.2, positions[10].y + 0.05, positions[10].z - 0.2},
            vel = {-1.0, -0.5, 0.0},
            radius = 0.3,
            opacity = 1.0,
        },
    
    },
}

function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

splines = {}

for i,v in pairs(splines_both) do
    table.insert(splines, v)
end

for i,v in pairs(splines_both) do

    new_spline = {}

    for j, point in pairs(v) do
        spline = deepcopy(point)

        spline.pos[3] = -spline.pos[3]
        spline.vel[3] = -spline.vel[3]

        table.insert(new_spline, spline)
    end

    table.insert(splines, new_spline)
end

ejection_velocity = 2.0
--wing_tank_offset = -0.82-- CG (with full fuse) -> 0.026
--fuselage_tank_offset = 2.20 --CG -> 0.194
--external_tank_offset = 0.89

logger_file = "C:/tmp/EL_AOA_1.csv"