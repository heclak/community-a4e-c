function normalise(color)
    t = {}
    for i,v in ipairs(color) do
        t[i] = v / 255.0
    end

    return t
end


-- Shared file between materials.lua and indication_page.lua

blob_color = {0, 255, 80, 255}
blob_color_filter = normalise({32, 2, 0})

reticle_color = {254,249,220,120}
reticle_color_filter = normalise({255,74,0})