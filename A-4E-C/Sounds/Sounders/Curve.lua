Curve = {}
Curve.__index = Curve
setmetatable(Curve,
{
    __call = function (cls, ...)
        return cls.new(...)
    end
})

function Curve.new(curve, min, max)
    local self = setmetatable({}, Curve)

    self.min = min
    self.max = max
    self.curve = curve
    self.dx = ( max - min ) / (#curve - 1.0)

    return self
end

function Curve:value(x)

    
    if #self.curve == 1 then
        return self.curve[1]
    end

    


    local index = (x - self.min) / self.dx

    local lower = math.floor(index)
    local upper = math.ceil(index)


    if lower == upper then
        upper = upper + 1
    end

    if lower < 0 then
        return self.curve[1]
    end

    if upper >= #self.curve then
        return self.curve[#self.curve]
    end


    local lowerX = lower * self.dx + self.min
    local upperX = upper * self.dx + self.min


    local y2 = self.curve[upper+1]
    local y1 = self.curve[lower+1]

    return (x - lowerX) * (( y2 - y1 ) / (upperX - lowerX)) + y1
end