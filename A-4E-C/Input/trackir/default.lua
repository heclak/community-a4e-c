return {
axisCommands = {
{combos = {{key = 'TRACKIR_PITCH'}}, action = iCommandViewVerticalAbs, name = _('Absolute Camera Vertical View')},
{combos = {{key = 'TRACKIR_YAW'}}, action = iCommandViewHorizontalAbs, name = _('Absolute Camera Horizontal View')},
{combos = {{key = 'TRACKIR_X'}}, action = iCommandViewHorTransAbs, name = _('Absolute Horizontal Shift Camera View')},
{combos = {{key = 'TRACKIR_Y'}}, action = iCommandViewVertTransAbs, name = _('Absolute Vertical Shift Camera View')},
{combos = {{key = 'TRACKIR_Z'}}, action = iCommandViewLongitudeTransAbs, name = _('Absolute Longitude Shift Camera View')},
{combos = {{key = 'TRACKIR_ROLL'}}, action = iCommandViewRollAbs, name = _('Absolute Roll Shift Camera View')},
{combos = nil, action = iCommandViewZoomAbs, name = _('Zoom View')},
},
}
