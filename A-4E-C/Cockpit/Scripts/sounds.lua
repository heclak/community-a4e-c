--[[
sounds ids 1 ... n
]]
local count = 0
local function counter()
	count = count + 1
	return count
end

SOUND_NOSOUND = -1
TOGGLECLICK_LEFT_FWD = counter()
TOGGLECLICK_LEFT_MID = counter()
TOGGLECLICK_LEFT_AFT = counter()
TOGGLECLICK_RIGHT_FWD = counter()
TOGGLECLICK_RIGHT_MID = counter()
TOGGLECLICK_RIGHT_AFT = counter()
TOGGLECLICK_MID_FWD = counter()
KNOBCLICK_LEFT_FWD = counter()
KNOBCLICK_LEFT_MID = counter()
KNOBCLICK_LEFT_AFT = counter()
KNOBCLICK_RIGHT_FWD = counter()
KNOBCLICK_RIGHT_MID = counter()
KNOBCLICK_RIGHT_AFT = counter()
KNOBCLICK_MID_FWD = counter()
PUSHPRESS = counter()
PUSHRELEASE = counter()
--NEW SOUNDS
TAILHOOK_HANDLE_DOWN = counter()
TAILHOOK_HANDLE_UP = counter()
STARTER_PUSH = counter()
STARTER_RELEASE = counter()
GEAR_LEVER_UP = counter()
GEAR_LEVER_DOWN = counter()
EJECTION_ARM = counter()
EJECTION_DISARM = counter()
CANOPY_LEVER_OPEN = counter()
CANOPY_LEVER_CLOSE = counter()
THROTTLE_DETENT = counter()