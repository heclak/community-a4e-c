return {

axisCommands = {
-- headtracker axes
{combos = {{key = 'HEADTRACKER_PITCH'}}, action = iCommandViewVerticalAbs, name = _('Absolute Camera Vertical View')},
{combos = {{key = 'HEADTRACKER_YAW'}}, action = iCommandViewHorizontalAbs, name = _('Absolute Camera Horizontal View')},
{combos = {{key = 'HEADTRACKER_X'}}, action = iCommandViewHorTransAbs, name = _('Absolute Horizontal Shift Camera View')},
{combos = {{key = 'HEADTRACKER_Y'}}, action = iCommandViewVertTransAbs, name = _('Absolute Vertical Shift Camera View')},
{combos = {{key = 'HEADTRACKER_Z'}}, action = iCommandViewLongitudeTransAbs, name = _('Absolute Longitude Shift Camera View')},
{combos = {{key = 'HEADTRACKER_ROLL'}}, action = iCommandViewRollAbs, name = _('Absolute Roll Shift Camera View')},
{combos = nil, action = iCommandViewZoomAbs, name = _('Zoom View')},
},
}
