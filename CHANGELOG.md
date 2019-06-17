# Changelog

Please list the changes you've made in this file. We should try to follow the guidelines listed here. https://keepachangelog.com

## Unreleased

### Added

### Changed

### Deprecated

### Removed

### Fixed

## Version 1.3.1 - 17 June 2019

### Added

- Added new quick start (instant action) missions (4 in Caucasus, 4 in Persian Gulf).
- New keybindings
  - Added "clickable cockpit" binding to mouse
  - Added AWRS keybinds
  - Added axis for white floodlights
  - Fixed lighting axis
  - Added APC keybinds
  - Added engine start/stop keybinds for joystick
  - Added View padlock bindings
  - Added BOMB ARM and BDHI keybinds
  - Added new incremental controls for lighting

### Changed

- Corrected cockpit position with respect to external model (Gunsight alignment is slightly affected but the offset should be negligible)
- Aircraft will now be hooked into the catapult if spawned on the catapult.

### Deprecated

- removed unused FC3 keybindings for HUD and HUD modes

### Removed

- Some unused keybindings may be removed. Primarily leftover FC3 keybindings.

### Fixed

- fixed floating nosegear
- Fixed init code where left wing tip nav light turns invisible when the master light switch is toggled at the start
- Updated anti-collision rotation angle to 180 degrees
- Fixed RWR initial volume to match volume position
- Added aggressor liveries to AUSAF
- Fixed condition where flaps indicator is invisible when power is not available
- replaced EDM8 files with EDM10 files as support for EDM8 was dropped with 2.5.5.31917
- updated theme to get loading image automatically loaded when A-4E-C is used

### List of new keybindings

#### Mouse

- Clickable Mouse Cockpit Mode On/Off

#### Keyboard

- Lock view (cycle padlock)
- Unlock view (stop padlock)
- All missiles padlock
- Threat missile padlock
- Lock terrain view
- AWRS: Toggle multiplier
- AWRS: Quantity select increase
- AWRS: Quantity select decrease
- AWRS: Mode Select CCW
- AWRS: Mode Select CW
- APC: Power - OFF
- APC: Power - Stby
- APC: Power - Engage
- APC: Temp - Cold
- APC: Temp - Std
- APC: Temp - Hot
- BDHI - NAV CMPTR
- BDHI - TACAN
- BDHI - NAV PAC
- BOMB ARM - NOSE & TAIL
- BOMB ARM - OFF
- BOMB ARM - TAIL
- Function Selector: OFF
- Function Selector: ROCKETS
- Function Selector: GM UNARM
- Function Selector: SPRAY TANK
- Function Selector: LABS
- Function Selector: BOMBS & GM ARM
- Interior Lights: White Floodlight Increase
- Interior Lights: White Floodlight Decrease
- Interior Lights: Instrument Lights Increase
- Interior Lights: Instrument Lights Decrease
- Interior Lights: Console Lights Increase
- Interior Lights: Console Lights Decrease

#### Joystick

- Lock view (cycle padlock)
- Unlock view (stop padlock)
- All missiles padlock
- Threat missile padlock
- Lock terrain view
- Engine Start
- Engine Stop
- AWRS: Toggle multiplier
- AWRS: Quantity select increase
- AWRS: Quantity select decrease
- AWRS: Mode Select CCW
- AWRS: Mode Select CW
- APC: Power - OFF
- APC: Power - Stby
- APC: Power - Engage
- APC: Temp - Cold
- APC: Temp - Std
- APC: Temp - Hot
- APC: Power - STBY/OFF
- APC: Power - STBY/ENGAGE
- APC: Temp - STD/COLD
- APC: Temp - STD/HOT
- BDHI - NAV CMPTR
- BDHI - TACAN
- BDHI - NAV PAC
- BDHI - TACAN/NAV CMPTR
- BDHI - TACAN/NAV PAC
- BOMB ARM - NOSE & TAIL
- BOMB ARM - OFF
- BOMB ARM - TAIL
- BOMB ARM - OFF/NOSE & TAIL
- BOMB ARM - OFF/TAIL
- Function Selector: OFF
- Function Selector: ROCKETS
- Function Selector: GM UNARM
- Function Selector: SPRAY TANK
- Function Selector: LABS
- Function Selector: BOMBS & GM ARM
- Interior Lights: White Floodlight Increase
- Interior Lights: White Floodlight Decrease
- Interior Lights: Instrument Lights Increase
- Interior Lights: Instrument Lights Decrease
- Interior Lights: Console Lights Increase
- Interior Lights: Console Lights Decrease

#### Joystick Axis

- Lighting: Instrument
- Lighting: Console
- Lighting: White Flood
- AWRS Drop Interval

## Version 1.3 - 11 March 2019

Contributors:  (Insert your name here!)

- Heclak
- Nero
- Merker
- Plusnine
- LevelPulse
- Storm (AIM-9P Fixes)

New Features:

- Chocks now hold aircraft in place, selectable via Ground Crew Interface (Tentative). Carrier starts now possible.
- Added joystick mapping axis for inst light and console light.
- Lights inside cockpit reworked. Now red.
- RwR now integrated. Including sounds.(AN/APR-23)
- A-4E can now be launched with the catapault. (see the A4E-Community Guide for details)
- Carriers can now have TACAN and ILS. (see the A4E-Community Guide for details)
- Reworked AWRS for more accurate system simulation
- Reworked CBUs release code for more accurate simulation
- New option to change trim speed in aircraft options menu
- New implementation of the AN/ALE-29A Chaff Dispensing System.
- New mission planner options for setting options for the AN/ALE-29A programmer
- New shrike search and lock system added. Behaviour is similar to AIM-9 Sidewinders arming procedure.
- New volume control for shrike and sidewinder volume (placeholder model)
- Added carrier catapult launch sounds (cockpit-only)
- New menu music
- Completely new collision and damage model. Fixes previous damage issues.
- Wheelbrakes can now be bound to a (single) Axis.
- Improved ground handling
- Options/special/A-4E: serveral options have been added like "hide Stick" and "trimspeed"

Bug Fixes:

- Red floodlight switch no longer stuck.
- No CTD when spawning on carrier.
- Fixed canopy visibility in cockpit when open.
- CBU visibility has been fixed.
- Huffer now works on carriers.
- Standby compass bug fixed. UV mapping of backlight rotated 180 degrees.
- Fixed RAT animation when deployed
- Fixed CBU bomblet visual placement in SUU-7 dispenser
- Fixed issue where turning a knob with the scroll wheel will cause it to jump back to the beginning when it reaches the end.
- Tweaked weight of SUU-7 dispenser
- Fixed anti-collision light switch on exterior lighting panel
- Fixed TrackIR issues
- Fixed pilot size

Other Changes:

- Console and Instrument Backlighting now controlled by appropriate knobs.
- AWRS now selects appropriate ripple quantities.
- Increased Pilot Size to reflect reference imagery.
- Updated keybinding. Countermeasures release is now known as the JATO firing button. Function is the same.

Weapon Systems:

- SALVO mode will now correctly only dispense one weapon from each readied station per weapon release pulse from AWRSAWRS QTY SEL will now correctly limit the number of times the weapons are released in the RIPPLE modes. 
- AWE-1(AWRS) now powered from the monitor dc bus. Master arm switch no longer turns off the AWE-1
- Weapons will no longer be released from centerline station when in STEP PAIRS or RIPPLE PAIRS
- Station of equal priority are now required for weapon release in PAIRS modes.
- CBU bomblets are now released in tubes (CBU-1/A, CBU-2/A, CBU-2/B)
- Added kneeboard page for CBU config to change the number of tubes of bomblets released per weapon pulse. (CBU-2/A, CBU-2B/A)
- Added options to set CBU config from the mission planner/editor
- Tweaked start condition of weapon system when spawning hot

Important:
You need to rebind your "Throttle Axis" and "Rudder Axis".
Read the A4E-Community Guide by heclak to avoid issues with the new carrier mechanics.
