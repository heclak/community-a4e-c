function normalise(color)
    t = {}
    for i,v in ipairs(color) do
        t[i] = v / 255.0
    end

    return t
end


-- Shared file between materials.lua and indication_page.lua

blob_color = {0, 255, 80, 200}
blob_color_filter = normalise({32, 2, 0})