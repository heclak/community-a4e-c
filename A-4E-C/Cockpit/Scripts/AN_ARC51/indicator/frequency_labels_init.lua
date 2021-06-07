dofile(LockOn_Options.common_script_path.."devices_defs.lua")
dofile(LockOn_Options.common_script_path.."ViewportHandling.lua")
dofile(LockOn_Options.script_path.."utils.lua")


indicator_type = indicator_types.COMMON
init_pageID = 1
purposes = {render_purpose.GENERAL,render_purpose.HUD_ONLY_VIEW} -- GENERAL,HUD_ONLY_VIEW,SCREENSPACE_INSIDE_COCKPIT,SCREENSPACE_OUTSIDE_COCKPIT,GROUND_UNIT_OPERATOR,GROUND_UNIT_OPERATOR_SCREENSPACE
--subset ids
BASE    = 1

page_subsets  = {
[BASE]    		= LockOn_Options.script_path.."AN_ARC51/indicator/frequency_labels_page.lua",
}
pages = 
{
	{
	 BASE,
	 },
}