-- API functions to manipulate radar scope display
-- To use, add this near the top of your system file:
-- dofile(LockOn_Options.script_path.."Systems/radar_scope_api.lua")
-- X,Y ranges from -1,-1 (bottom left) to 1,1 (top right)
-- opacity ranges from 0 (transparent/invisible) to 1 (completely opaque)

-- API initialization --
blob_ud_params={}
blob_lr_params={}
blob_op_params={}
max_blobs=2500
for i=1,max_blobs do
    blob_ud_params[i]=get_param_handle("RADAR_BLOB_"..tostring(i).."_UD")
    blob_lr_params[i]=get_param_handle("RADAR_BLOB_"..tostring(i).."_LR")
    blob_op_params[i]=get_param_handle("RADAR_BLOB_"..tostring(i).."_OP")
end
scribe_10nm_param=get_param_handle("RADAR_PROFILE_SCRIBE_10NM")
scribe_20nm_param=get_param_handle("RADAR_PROFILE_SCRIBE_20NM")


-- API functions --

function set_blob(idx,x,y,opacity)
    --[[
    if idx<1 or idx>max_blobs then
        print_message_to_user("error idx="..tostring(idx))
        return
    end
    --]]
    blob_op_params[idx]:set(opacity)
    blob_lr_params[idx]:set(x)
    blob_ud_params[idx]:set(y)
end

function set_blob_opacity(idx,opacity)
    --[[
    if idx<1 or idx>max_blobs then
        print_message_to_user("error idx="..tostring(idx))
        return
    end
    --]]
    blob_op_params[idx]:set(opacity)
end

function change_blob_opacity(idx,opacity_delta)
    local opacity=blob_op_params[idx]:get()
    opacity=opacity+opacity_delta
    if opacity>1 then
        opacity=1
    elseif opacity<0 then
        opacity=0
    end
    blob_op_params[idx]:set(opacity)
end

function set_blob_xy(idx,x,y)
    blob_lr_params[idx]:set(x)
    blob_ud_params[idx]:set(y)
end

-- pass 10, 20, or 0 (to disable)
function set_profile_scribe(range_nm)
    if range_nm==10 then
        scribe_10nm_param:set(1)
        scribe_20nm_param:set(0)
    elseif range_nm==20 then
        scribe_10nm_param:set(0)
        scribe_20nm_param:set(1)
    else
        scribe_10nm_param:set(0)
        scribe_20nm_param:set(0)
    end
end