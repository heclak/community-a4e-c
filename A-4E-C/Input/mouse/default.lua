return {

keyCommands = {
{combos = {{key = 'MOUSE_BTN2'}}, down = iCommand_ExplorationStart, name = _('Enable visual recon mode'), category = _('View Cockpit')},
{combos = {{key = 'MOUSE_BTN3'}}, down = iCommandViewTransposeModeOn, up = iCommandViewTransposeModeOff, name = _('Camera transpose mode (press and hold)'), category = _('View Cockpit')},
{down = iCommandCockpitClickModeOnOff,			name = _('Clickable mouse cockpit mode On/Off'), category = _('General')},
},

axisCommands = {
-- mouse axes
{combos = {{key = 'MOUSE_X'}}, action = iCommandPlaneViewHorizontal, name = _('Camera Horizontal View')},
{combos = {{key = 'MOUSE_Y'}}, action = iCommandPlaneViewVertical, name = _('Camera Vertical View')},
{combos = {{key = 'MOUSE_Z'}}, action = iCommandPlaneZoomView, name = _('Camera Zoom View')},

},
}
