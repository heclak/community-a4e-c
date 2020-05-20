# Changelog

Please list the changes you've made in this file. We should try to follow the guidelines listed here. https://keepachangelog.com

## Unreleased

### Added

- 3D/Cockpit Model
  - added radar glow
  - updated cockpit lighting. Added red floodlights on both sides of the ejection seat
  - made clickable (oxygen switch, walleye/shrike selector, air-conditioning panel)
  - new sidewinder volume knob
  - added destination slew knobs for navigation computer panel
  - new compass controller panel model (clickable but currently not functional)
  - revised engine control panel with clickable switches
  - new AFCS test panel model (currently non-functional)
  - updated misc switch panel for accuracy
  - external fuel quantity check is now a button
  - new light indicator model for manual fuel control, jato, and doppler memory mode indicators
  - implement clickable spot for hiding the control stick (#9)
  - Added clickspots to toggle rear view mirrors in the cockpit
  - added animated brake pedals to cockpit
- 3D/External Model
  - New anti-collision light model and effect
- reworked ECM control systems
  - upgraded AN/APR-23 to AN/APR-25
  - added separate APR-27 simulation
  - added ALQ-51A
  - added ALQ-51A BIT Test
- air cond panel is now clickable
- added emergency fuel shutoff control
  - engine will shutdown if lever is set to 'emer off'
  - engine will not start with lever in 'emer off' position
- added fuel dump capability
- added command for manual flight control override. Update brake hydraulic system
- added refuelling probe light
- added radar scope glow. radar scope glow is linked to brilliance setting
- added option to disable catapult location checks (client side checks)
- toggle switches and multiposition switches are now animated
- added initial implementation of huffer simulation and sounds. moved external power logic to the huffer. 
- added native NVG and NVG keybindings
- added clickable shoulder harness handle and secondary ejection handle
- added function for APN-153 to calculate wind vector and pass to ASN-41
- ASN-41 will now display wind vector when in D1 or D2 mode
- Initial implementation of manual and primary fuel control mode
  - manual fuel control warning light will come on when engine fuel control is in manual mode
  - manual mode will occur when fuel control switch is in the manual position
  - manual mode will occur when engine rpm is less than approximately 5-10 percent
- added sdef for engine sounds to allow for customisation for engine sounds
- added ability to export radar display. Display name is "A4E_RADAR"
- Made JATO ARM-OFF and JATO JETTISON-SAFE switches clickable. Switches are clickable but no logic is coded in the systems due to lack of JATO.
- Added axis binding for gunsight elevation control
- added support to take off from the Sao Paulo A12 and Charles de Gaulle carriers
- added navigation log page to kneeboard
- added option to remove ECM control panel from cockpit via mission editor
- Liveries:
  - added Trainer USMC VMAT-102
  - added Trainer USN Bare Metal 1956
  - added USMC VMA-124 Memphis Marines
  - added USN VA-45 Blackbirds
  - added USN USN VA-212 Rampant Raiders
  - added Trainer: USN VC-5 Checkertails
- Textures/Exterior:
  - added Roughmet gloss-level options
  - added hardpoint bottoms textures
  - added MER rack textures
- Missions
  - Added Nevada missions

### Changed

- new collision model and updated critical damage values
- updated hydraulic system to be dependent on engine rpm
- changed layout of option menu
- moved clickable definitions to separate file (clickable_defs.lua)
- tweaked switch behaviour to be consistent between left/right clicks
- weapons and RWR sounds will now be played through the pilot headphones. Sounds will sound like it is coming through the helmet when "hear like headphones" is used"
- AI model now uses 3D argument lights
- updated AN/ASN-153 warmup and test sequence timings (1 minute for test and 5 minutes for warmup)
- changed ASN-41 to require a push-and-turn to change values (same in real world, left + right-click and drag or left-click and scroll)
- new UI elements for version 1.4
- updated MER model and textured
- Hide stick option is now consolidated with main sim options. Remove option to hide stick from A-4E-C special options menu.
- rewrite more accurate simulation of APN-153 warmup time. Change APN-153 TEST sequence.
- changed brightness of lights to match lighting changes in 2.5.6
- updated hydraulic system pressurization to occur when engine startup has reached idle rpm. (#189)
  - Although idle rpm is set at 55%, the sim approaches but does not reach 55.0 or greater upon startup. Lower the hydraulic checks to 54.9 will guarantee the trigger to occur for engine startups.
- 3D/External model
  - updated navigation lights
  - fixed uv for pylons, bypass fan, fuselage bottom
  - new model and animation for rotary beacons
- Textures/Cockpit:
  - updated boards, labels, buttons
  - updated cockpit gass
  - updated internal photograph
  - fixed gauge edge bleed
  - misc. minor 2019 improvements
- Textures/Exterior:
  - removed/re-packaged loose files
  - replaced exterior lights textures
  - fixed interior fan, engine exhaust pipe, engine intakes
- Liveries:
  - updated Aggressor camos for better matching with weapons connections
  - updated Blue Angels with custom Roughmet
  - updated NZ with more accurate markings
  - renamed "Unmarked" so it loads as the default instead of Argentina.
- Missions:
  - updated Caucasus missions with new liveries, times and weathers
  - updated Persian Gulf missions with new liveries, times and weather
- UI:
  - New main menu splash screen image
  - New briefing windows images
- Input:
  - Major rewrite of keybinding files. HOTAS profiles will now use diff files instead
  - Duplicate keybinds are removed
  - Standardise naming convention of binding names and categories
  - fixed some standardisation for "else" and capitalisation for "Special For Joystick"
  - new binding diff file for CH Fighterstick and removed old binding file for Warthog joystick. Updated throttle binding.
  - added diff bindings for Sidewinder Force Feedback 2
  - added default binding for Logitech Wireless Gamepad F710 in XInput mode

### Deprecated

### Removed

### Fixed

- ECM panel indicators will now work with master test light button
- gear handle light will no longer light up when primary ac power is not available
- spoilers are now linked to the hydraulic system
- flaps and gear are now dependent on utility hydraulic
- fixed bouncing nose gear
- fixed briefing map to auto load with A-4E-C missions
- restructured sounds folder for sound asset isolation. Sounds should no longer affect other modules.
- cockpit damage is revised to fix issue where the sim counts the aircraft as dead but the pilot is still alive.
- fixed issue where red flood lights flashes to full brightness when turning on
- fixed aileron trim function for MS FFB2 joystick (#137) (AFCS is still not compatible with MS FFB2)
- fixed windspeed and wind direction displayed on ASN-41 and BDHI when in test mode
- fixed issue where A-4E-C does not appear in encyclopedia
- corrected warthog bindings for flaps up and flaps down
- fix bug where countermeasure values were not updated after rearming or with unlimited weapons
- make canopy functional after ground crew repair
- fixed external anti-collision lights not turning off when master light switch is turned off or power is disconnected. (#199)
- fixed hookpoint for better catapult wire tracking.
- fixed issue where probe light is not connected to the master exterior light switch
- 3D/Cockpit Model
  - fixed canopy uv mapping
  - fixed white floodlight canopy glare
  - fixed nav panel digit glitch
  - fixed incorrect appearance for control hydraulic annuciator on state (#176)
  - fixed green glow from radar while radar is powered off and in the dark. (#57)
  - fixed issue with pylon 1 not being removed on AI model
  - fixed issue with shrike pylons not appearing correctly in multiplayer

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
