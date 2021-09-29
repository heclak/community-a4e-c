dofile(LockOn_Options.common_script_path.."devices_defs.lua")

indicator_type       = indicator_types.COMMON
purposes 			 = {render_purpose.GENERAL}--,render_purpose.HUD_ONLY_VIEW} --render_purpose.SCREENSPACE_INSIDE_COCKPIT
--screenspace_scale    = 4;
init_pageID  = 0

page_subsets = {
[0] = LockOn_Options.script_path.."APR-25_RWR\\Indicators\\Indicator_page.lua"
}

pages = {
[0] = {0}
}

need_to_be_closed = true -- close lua state after initialization 