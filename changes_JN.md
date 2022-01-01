### Added
- Flight Model
  - Realistic Flight Dynamics (it's pretty nifty)
  - Realistic Suspension
  - Differential Brakes
  - Nose wheel steering
  - Realistic Engine Simulation
  - Realistic force based slat simulation
  - Damage to engine and aerodynamic surfaces (physically simulated only)
  - Cockpit shake effect
  - Wing vapour effect
  - Compatibility with regular carrier
  - Carrier hook up keybind (Ship Takeoff Position)
  - Basic compatibility with Supercarrier
  - Added Salute option to radio menu
  - Added Request Launch option to radio menu
  - Added stabiliser trim
  - Flight control actuators
  - Wheel brake axis for both brakes.
  - Inital implementation of ground effect.
  - Dynamically simulated slats.
  - Added gravity to slats (not just spring force)
  - Basic wing overstress

- Sounds
  - Gear door
  - Gear locking
  - Gear hydraulic
  - Flap stop
  - Flap hydraulic
  - Slat stop
  - Gear airflow
  - Flap airflow
  - Speedbrake airflow
  - Spoiler airflow
  - Cockpit rattle at high AOA
  - Avionics Whine
  - Emergency Levers
  - Illumination Potentiometers
  - Radar Screen Cover
  - Speedbrake switch
  - Flaps lever
  - Spoiler airflow
  - Harness lever
  - Engine ignitor sound
  - Airbrake movement sound.
  - Landing gear overspeed sound.
  - New engine igniter sound scheme
  - Huffer airflow valve
  - Fuel sloshing
  - Added touchdown sound
  - Wing stress
  - External engine sounds
  - Wind rushing sound
  - Cockpit engine sounds (preliminary)

- CP-741/A Bombing Computer:
    - Initial Implementation
    - In range light illuminates when within a distance that pulling up 45 degrees would release the bombs.
    - Weapon Function Selector: CMPTR Animation position. The CP-741/A is now on this position- 

- Radio, TACAN and MCL:
    - Enabled Radio (see kneeboard pages for presets, thanks to the *TheRealHarold* for filling in the missing pieces of the puzzle on this one)
    - Manual Carrier Landing (MCL/ICLS) system and its bit test
    - TACAN for moving objects (tankers and ships) and portable tacan stations

    Note for TACAN and MCL(ICLS). The method used relies on the mission file. This means
    for a TACAN or MCL to be detected the unit (or unit with the same unit name) must exist
    in the mission file. Replacement objects can be spawned in to replace dead units however
    they must have a name which contains the original name to be correctly found by the TACAN
    and MCL system. This method should work 99% of the time with regular missions however if
    you run into trouble it is worth checking the following conditions:
        - Unit with TACAN/MCL exists in the mission file (placed in editor)
        - Equivalent unit with a name which contains the original name of the unit placed in the editor (for example UNIT3 would find a unit named UNIT3_OTHERSTUFF, if UNIT3 needed to be respawned)
        - Unit does not share a channel regardless of X or Y band

- New Radar:
  - Radar can cast many more rays per frame.
  - Gaussian beam shape is simulated using monte carlo sampling.
  - Range lines can now be lit by the reticle knob.
  - Range lines are now drawn on top of the radar returns.
  - Updated screen simulation to be more realistic.
  - Updated storage to be more realistic.
  - Updated radar reflection values for cities and other reflective terrain features.
  - Ships can now be detected on radar.
  - Added reticle bulb to see the range lines easier.
  - Added keybinds for the radar display knobs.
  - Kneeboard pages: 3-7 -> 3-10.
  - Option in special menu is present if you wish to move back to the legacy version.

- AN/ASN-41 Nav computer:
  - Now integrates from starting position functioning correctly
  - Integration happens in D1 and D2 only, set to D1 or D2 to have the correct position. Switching to STBY will pause the integration
  - APN-153 radar is vital to preventing drift
  - Minor errors are introduced for sensors producing drift over time
  - Normal drift is about 2 - 3 nautical miles per hour
  - Drift will increase with lots of maneouvers

- New fuel system
  - Fuel system simulates all the pumps in the system. This lays the ground work for some interesting failures/damage
  - Negative g effects on fuel flow
  - Zero g effects on fuel flow
  - Boost pump failure effects
  - Engine pump failure effects
  - Wing pump failure effects
  - Emergency transfer simulated
  - Enabled lights for boost and transfer
  - Implemented fuel panel switch functions
  - New bypass switch will bypass the wing tank in case of wing leak.
  - Flight refuel switch will no longer bypass wing tank, this enables/disables external tank flight refueling.

- AFCS and APC:
  - Re-wrote AFCS for EFM integration
  - Re-wrote and tuned APC for EFM integration
  - AFCS rolls out when disabling heading mode
  - AFCS test (WIP: indicators do not function correctly at the moment)
  - Yaw damper (stab aug switch on AFCS panel)


- Kneeboard:
  - ILS Navigation channels for land bases.
  - Startup checklist
  - Taxi checklist
  - Takeoff checklist
  - Emergency procedures
  - Bomb table and CP-741/A procedure
  - Case III landing and APC procedure
  - Added kneeboard pages for detail on takeoff, taxi, and landings. ('RShift+K')
  - Aligned 'Throttle Panel' category to kneeboard
  - Added PDF manual and improved kneeboard documentation.

- Slider for FFB sticks at which deflection of the stick to switch into AFCS CSS mode.
- Added SUU-25 Parachute illumination pod for night ops.
- Empty Fuel Tanks
- Sidewinders to outboard stations (thanks to the evidence of VF-45)
- Added Chile to list of Countries.
- Very basic oxygen system **(hypoxia is enabled)**
- Air data computer AXC-666 for AN/ASN-41 and CP-741/A, no external functionality but lays some ground work for more realistic simualtion
- Controls Indicator
- Added radio channel presets printouts to radio panel.
- Added custom view positioning for VR HMDs. Position is lowered and moved slightly forwarded from the previous position
- Added aircraft tasks (Reconnaissance, Escort)
- Added radio frequency printouts on the AN/ARC-51 label. Labels are dynamically generated from the mission file
- Added new miscellaneous switch panel on right console
- Added VR config to allow the use of VR controllers (throttle function is incomplete)
- Added roles for mission editor.
- Added gunsight and radar night time setup.
- Added warning for incompatibility with CH-53.
- Added Steering assist.
- A new mode switch for carrier launches - DEFAULT mode supports the Stennis and Supercarrier. A new mode, AUTO makes speed and mass calculations when launching from  aircraft carrier mods (for example, the HMAS Melbourne) more realistic. A new keybind for Catapult Power Mode is provided (Default: 'LCtrl+U')

- Added AIM-9 sidewinder sounds (this fixes the bug where the some useres were missing sidewinder tones).
- Added unique fuel tank to 'Brazil Marinha do Brasil VF-1 LoViz, 2018' livery
- Basic support for FFB joysticks

- Liveries:
  - Community A-4E-C III "Forever Free"
  - Argentine Brigada IV
  - Argentine Brigada V
  - Added 3 new USN liveries for USS Forrestal 1967.
  - Added Community IV: Sea Otter, 2021 (Fictional)
  - Added Australian Navy Squadron 805, 1972 *(thanks HellesBelle)*
  - Added Brazil Marinha do Brasil VF-1 LoViz, 2018
  - Added Finland FiAF, 1984 (Fictional) *(thanks FinCenturion)*
  - Added Malaysia TUDM M32-29 No.9 Squadron, 2004 *(thanks JacobBadshot)*
  - Added RAF Empire Pilots Test School Raspberry Ripple (Fictional) *(thanks FlyingHueman)*
  - Added RNZAF Golden T-Bird No.2, Squadron Ohakea, 1986 *(thanks Corsair016)*

- Keybinds:
  - Slats lock toggle keybind (for fomation flying)
  - Added new default keybinds for AFCS, BDHI, chaff, fuel system, gunsight, master exterior light switch
  - AFCS
  - TACAN
  - Fuel System
  - Oxygen System
  - Radar Altimeter
  - ECM
  - ARC-51 Radio
  - Gunsight
  - Master test switch
  - Altimiter pressure
  - Missile volume knob
  - ASN-41 Keybinds
  - Weapon Function Selector
  - Other misc keybinds.

- Quick Start Missions: 
    - Adverse weather carrier landing 
    - Carrier landing
    - Bomb trucking
    - Aerial Refueling
    - Other missions from sidekick65, SPINEG, Cubeboy.

- 3d Model:
  - Added MCL Panel
  - Added Misc Switches Panel
  - Implemented AFCS Test panel switches

- Textures:
  - Added helmet textures.
  - Individualised Pilot appearances
  - Damage textures
  - Cockpit normal maps
  - Retouched cockpit interior
  - Countermeasures dispensers
  - Normal Maps

### Changed

- General Changes:
  - Menu icon.
  - Menu screen.
  - Updated installation and troubleshooting instructions.
  - Added Argentina/ARG to countries and assigned appropriate liveries

- Flight Model:
  - Surfaces, horizontal stab, elevator, vertical stab, rudder, to not use beta, as this previously caused an ill defined wind axes to body transformation at high beta values causing the lift/drag values to be inverted.
  - Significantly increased slats lift.
  - Increased induced drag at high AoA (unrealistic negation of lift and drag caused by the issue above at > 90 deg AoA or beta).
  - Increased wing drag onset at > 40 degrees AoA.
  - Beta calculated per surface rather than using the overall airframe beta. This fixes some edge of the envelope nastiness
  - XY moment of inertia to match real value (effects tumbling).
  - Slats lift increased slightly.
  - Engine damage has now more dynamic effect.
  - Improved ground handling and break handling.
  - Slow release for brakes when using keyboard rather than instantly going to zero. This allows the brakes to be feathered below the point where the wheels lock.

- Systems:
  - AFCS will not engage with rudder uncentred.
  - Re-wrote AFCS for EFM integration.
  - ILS mode on TACAN has been changed to A/A and functions as such.
  - Changed radar to be compatibile with SRS pull request.
  - ASN-41 Navigation Computer:
    - AN/ASN-41 error was being cancelled due to mathematical operation. This has been rectified. The drift will now be significant (1-2 nautical miles per hour, depending on manoeuvres).
    - Slew knob can be used to change the destination coordinates in STBY, D1, and D2 modes
    - Push-to-set knobs no longer change coordinates in D1 and D2 modes
  - Fuel System:
    - New bypass switch will bypass the wing tank in case of wing leak.
    - Flight refuel switch will no longer bypass wing tank, this enables/disables external tank flight refueling.

- Cockpit:
  - Rudder pedal animation no longer tied to rudder position.
  - Updated mirror code for better rear visibility in mirrors.
  - Lowered default cockpit view to allow visibility of the zero mil position.
  - Nosewheel steering range adjusted to match animation.

- Textures:
  - Textures renamed to be standardised, to prevent all known mod conflicts.
  - Exterior:
    - Roughmets.
    - Wheels and gear
    - New weathering.
    - Cockpit textures  in external view. *(thanks JP Gabobo)*
    - Engine Exhaust
  - Interior:
    - Weapon Function Selector labels.
    - Canopy Seal.
    - Gunsight.
    - Metallic objects.
    - Radar screen and filter.
    - Ejection seat and handle.
    - ADI ball and climb indicator.

- Sounds:
  - LABS tone is played when the Bomb Release Button is depressed CMPTR mode.
  - Improved sound mixing.
  - Updated main menu intro sound.
  - Sound mixing.
  - More realistic engine ignitor timing.

- Liveries:
  - Standardised liveries lua
  - Improved inaccuracies and naming across liveries

- Keybinds and Controls:
  - Keybinds recategorised correctly
  - Improved keybinding names.
  - "Ship Takeoff Position" changed to "Catapult Hook-Up"
  - Renamed fuel pressurisation
  - Updated default controller bindings for warthog throttle and CH Fighter Stick.
  - Moved keybinds to increase EFM maintainability: **this unforuntately destroys all your existing keybinds**
  - Aligned controls indicator to bottom-left (friendlier for VR).
  - Keyboard: aileron response now resets.
  - Keyboard: commands for roll and pitch no longer reset to centre.

- Missions:
  - Quickstart missions weather updated for 2.7
  - TACAN and MCL training mission
  - The radio manual frequency now starts at the channel 1 preset.
  - Enabled cockpit lights by default between the hours of 1700 and 0500.

- Curvature for brake. This emulates the force one would feel while braking. The brakes now lock while rolling fast at ~75%.
### Deprecated
- SFM Fake afterburner
- Everything on the special menu, except cockpit shake
---b1

### Removed
- SFM Carrier Launch Mechanism
---b1
- Bunch of deprecated special menu options.
- Landing gear overspeed message.
- Removed ability for the Gunsight to slave to the radar. The gunsight must now be set to zero when using the CP-741/A bombing computer.
--b2
- Old fuel system
--b3
- Duplicate multiplayer chat command
--b4
--b5
--b5.1
- Loadouts that were non-functional
- Nose Wheel Steering
- Weapons that do not have their supplementary systems modelled.
---RC1
---RC2
---RC3


### Fixed
- Hook clickable
- Flap blowback valve
- Carrier Launch Mechanism present on runways (see removed)
- Carrier trap from airstart causes explosion
- Aircraft drift during carrier operations
---b1
- Trim setting in the customisation menu
- FFB pitch trim not working.
- FFB not working AFCS.
- Hook controls not bindable on peripherals.
- Stab Aug switch saying unimplemented.
- Bomblet drag issue for the CBU 1 and 2 allowing the A-4 to go supersonic.
- Radio volume knob starting at 0.
---b2
- USMC Livery fixes
- Fixed bort numbers on some USMC liveries
- Readme PDF corruption in official build
- Smokewinders
- Brake issue causing brakes to jump to 50% application
- Radar altimiter index knob.
---b3
- Connecting to the SuperCarrier will no longer get stuck
- Empty tanks fueling correctly at tanker
- AFCS to roll out correctly when disabled during heading turn
---b4
- M-81 and M-88 bomb negative pylon drag after release from MER/TER rack
- Engine windmilling at low speed
- Airspeed indicator uses calibrated airspeed instead of equivalent airspeed.
- Fuel trans light not displaying when integral wing tank empty
- Wheel animations
- Mid Air refueling not completing with external tanks
---b5
- Engine sounds for some DCS modules being overwritten by A-4E sounds
---b5.1
- Incorrect LABS tone function where the tone stops when the readied stations are empty.
- Mis-labeling of radar PLAN/PROFILE switches.
- Issue #399 where airframe stress sounds need to be clamped.
- Issue where ARC-51 GXMIT returned nil state.
- Spoilers not engaging at 70% RPM *(thanks pohlinkzei)*.
- Issue #408 MK-77 jettison crash.
- TACAN/MCL beacons still transmitting when the unit is dead.
---RC1
- Radar keybinds for experimental radar.
- Fixed radar keybind that was not showing.
- Blacking out when in the wake turbulance of another aircraft.
- Volume of some sounds not being correctly adjusted.
- Fixed typo in Brazil Marinha do Brasil VF-1 15 ANOS, 2013
- Fixed roughmets for 'RNZAF Golden T-Bird No.2, Squadron Ohakea, 1986' livery
- Kneeboard errors.
---RC2
- Partially fixed long standing performance degrade due to the large number of blobs for the radar.
- Issue #392 allowing the deck offset and angle to be adjusted based on ship type. *(thanks OpticFlowX)*
- Reversion from CSS (or inital engage) to ATTITUDE should roll the aircraft level when within 5 degrees. *(thanks OpticFlowX)*
- JTAC was missing from radio menu.
- Fixed kneeboard page 1-2 overprinting.
---RC3




