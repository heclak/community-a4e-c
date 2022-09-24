![Community A-4E-C for DCS World, v2.1.0](DISCORD IMAGE URL FOR UPDATE)

## About the A-4E-C Project

The A-4 was a cold war workhorse which proved to be a capable, reliable light attack aircraft to dozens of nations around the world. From the jungles of southeast Asia, to the desert of Sinai, to the coasts of South America, the scooter was a common sight above battlefields around the world for decades.

2.1.0 UPDATE SUMMARY HERE.

***DO NOT redistribute this mod without permission!***

### Contributing Developers

Gospadin, Heclak, Joshua Nelson, plusnine, Farlander, gyrovague, kryb/Archimaede, Merker, Jones, Nero

### Community Contributors

SkateZilla, uboats, Dr. Manius, LevelPulse, Cubeboy, Talo, GVad, OpticFlow, pohlinkzei, Coragem, nima3333, Sidekick65, SPINEG, Shadowfrost, Sport, Historiker, rudel-chw, Luciano, Malamem, HellesBelles, Bungo, Corsair016, FlyingHueman, JacobBadShot, JP Gabobo, Drofseh, Rob, ataribaby, Tanuki44, gcask, The Original HoggitDev Team, [Eric Haugen](http://erichaugen.bandcamp.com)

## Features

- Realistic external flight model and engine simulation
- Clickable cockpit
- Carrier landing and takeoff
- Air refueling
- AN/APN-153 Doppler Navigation Radar
- AN/ASN-41 Navigation Computer
- AN/ARC-51 UHF Radio
- AN/ARN-52 TACAN
- AN/ARA-63 MCL (ICLS)
- AN/APN-141 Radar Altimeter
- AN/APG-53A Radar
- AN/APR-23 Radar Homing and Warning System (ECM)
- AN/ALE-29A Chaff Dispensing System
- Automatic Flight Control System (AFCS)
- Approach Power Compensator (APC)
- AWE-1 Aircraft Weapons Release System (AWRS)
- CP-741/A Bombing Computer (CCRP)
- AGM-45A Shrike anti-radiation missile (SEAD)
- New weapons:
  - AN- series WWII munitions: M66, M81, M88
  - MK4 HIPEG 20mm gunpod
  - Mk-77 napalm canister
  - SUU-7 bomblet dispenser
- Unique sounds inside and outside the aircraft
- User manual (PDF and Kneeboard)

### Version 2.1.0 Changelog: Featured Items

#### Added
- **Flight Model:**
- **Systems:**
  - AN/APR-23 RHWS (ECM)
    - With the AN/APR-23 Function Selector Switch set to REC and the APR-25 Switch in the ON position, a baseline system hum and response audio from a wide variety of radar-equipped units is produced at a volume determined by the the (inner) AN/APR-23 PRF Volume knob.
    - When the APR-27 Switch is in the ON position, detected missile launches from SA-2 S-75 "Fan Song" will produce an oscillating alert tone at a volume determined by the (outer) AN/APR-23 Missile Alert Volume knob.
    - The system's bit test is available to perform. With the AN/APR-23 Function Selector Switch set to REC, press the APR-27 Test button to initiate the bit test.
- **Missions:**
- **Liveries:**
  - Community A-4E V: Blue Team, 2022 (Fictional)
  - Community A-4E V: Red Team, 2022 (Fictional)
  - USN VX-5 Vampires, 1986 (Fictional)
  - USMC Naval Weapons Evaluation Facility, 1974
  - Operational-era USN and USMC liveries now have a customized, well-worn LAU-10 launcher.
- **Weapons and Loadouts:**
- **Quality of Life:**
  - Absolute and slew axis inputs for AN/APR-23 Missile Alert Volume, AWRS Drop Interval Knob, Gunsight Elevation Control, Gunsight Light Control, Instrument Lights Control, Shrike/Sidewinder Volume Knob, TACAN Volume Knob, and White Floodlights Control. Some non-axis inputs associated with these have been renamed. Users with extensive control schemes should adjust their controls to resolve any conflicts. *(thanks gcask)*
  - Single inputs for AN/ARN-52 TACAN Mode switch.
  - Single and else inputs for Throttle Position Lock.
  - Single inputs for the Canopy Lever. You can close the canopy with LSHIFT+C, and open it LSHIFT+LCTRL+C. *(thanks Tanuki44)*
  - Single inputs for the AWRS Quantity Selector Switch, AWRS Drop Interval Knob, and AWRS Mode Selector Switch.
  - Inputs for APR-27 Test and APR-27 Light buttons.
  - Input options across the module can now be bound to mouse buttons.
  - When the aircraft has power, the Seat Adjustment Switch can be used to move the baseline pilot head position up and down in the cockpit. *(thanks nima3333)*
  - Kneeboard Manual:
    - Added a chart of weapon stations and their associated loadout options.
    - Added additional guidance on AN/APR-23 RHWS (ECM) operation.
- **Sounds:**
  - AN/APR-23 RHWS (ECM):
    - AAA: New sounds are produced in response to the Fire Can SON-9 fire director radar.
    - Aircraft: New sounds are produced in response to aircraft search and tracking radars.
    - EWRs and Ships: Unique sound sets are produced in response to ground and ship EWRs. A new sound is also produced in response to ship tracking radars.
    - SAMs: New sounds are produced in response to the P19 "Flat Face" and S-200 ST-68U "Tin Shield" and SA-2 S-75 "Fan Song" sarch and tracking radars. Some Fan Song units will sound different, simulating the sound of different radar bands used in the field. New sounds are also produced in response to the SA-3 S-125 "Low Blow", SA-5 S-200 "Square Pair", and SA-6 Kub "Straight Flush" units. The number of different sounds a each radar produces varies by unit, so pilots will need to learn what their ears are telling them about what type SAM is targeting them, and how much launch warning that SAM provides from its PRF audio.
    - SPAAA Vehicles: New sounds are produced in response to the Gepard, Vulcan M163, and ZSU-23-4 Shilka "Gun Dish" radars.
  - Tire skidding for the left and right tries is audible.
  - Seat adjustment hydraulic motor.

#### Fixed
- **Flight Model:**
- **Systems:**
- **Missions:**
- **Liveries:**
  - Community A-4E III: Forever Free livery displays two digits on the flaps.
- **Weapons and Loadouts:**
  - CBU-2B/A weight is calculated correctly. Weapon release and spread cause fewer collision-based self-destructs when the weapon is released.
- **Quality of Life:**
  - Throttle Increment and Throttle Decrement inputs function properly. A new slider in the special menu is available to adjust throttle rate for these inputs from 1 to 5%.
  - Kneeboard Manual:
    - Waypoints on the navigation page enumerate 11 waypoints, and can't overrun the instructions on the page.
    - Corrected erroneous procedures for ground radar.
    - 300 gallon tanks on the center pylon enumerates properly on the kneeboard loadout page.
    - Corrected erroneous procedures for air refueling.
  - VR hand positions: Users are encouraged to enable *Use Hand Controllers*, *Hand controllers use Cockpit Stick*, and *Hand Controllers use Cockpit Throttle*, and *Hand Interaction Only When Palm Grip is Obtained*. Be aware that it is easy to accidently power down the engine if you touch it with your virtual index finger while holding the grip button. Always approach the throttle with your finger above it.
- **Sounds:**

#### Changed
- **Flight Model:**
- **Systems:**
- **Missions:**
  - Changed a few liveries in the included mission sets to better reflect available livery sets.
- **Liveries:**
  - Unmarked and Community A-4E liveries are now available to a wider selection of countries.
  - Updated USN VC-1 Challengers.
  - Updated a few knob textures.
- **Weapons and Loadouts:**
- **Quality of Life:**
  - Default inputs for Throttle Position Lock are set to RCTRL+HOME (Step Up) and RCTRL+END (Step Down).
  - Emergency Stores Release Handle default input changed to LCTRL+J. *(think J for jettison!)*
  - Differential wheelbrake inputs default inputs are changed to LCTRL+W (left) and LALT+W (right).
  - The controls indicator's nosewheel caster indicator now displays logarithmically, making it easier to see those early changes in castering and better reflect nosewheel sensetivity to turn rate. *(thanks, Drofseh)*.
  - Trim speed settings in the special menu are now adjustable by individually for pitch, roll and yaw, with percentage sliders for each instead of presets from a drop-down. *(thanks Drofseh)*
  - Refactored the special menu for easier editing in the future.
- **Sounds:**
  - Improved input response and dynamic range of AN/APR-23 PRF Volume, AN/APR-23 Missile Alert Volume, Shrike/Sidewinder Volume, and TACAN Volume knobs.
  - Reduced the relative volume of the APR-25 operational "hum".

[See full changelog](https://github.com/heclak/community-a4e-c/blob/master/CHANGELOG.md)

### Known Bugs and Incompatibilities

- Incompatible with AH-6J Little Bird, CH-47 Chinook, and CH-53E Super Stallion mods (DCS bug).
- Pilot occasionally blacks out when throttling up to hook up to catapult on SuperCarrier.
- Dispensing high volumes of bomblets (40+) from SUU-7/CBU-1/CBU-2 can cause performance dips or crashes to desktop.

[See full issue list](https://github.com/heclak/community-a4e-c/issues/)

## Installation

Failure to perform these steps will result in DCS World not recognizing the module, inability to use the module, input errors when using the module, or client integrity check failures on multiplayer servers that require them. Never install the A-4E-C files directly into your DCS World installation files! Installation size is around 1 GB.

### STEP 1: Upgrading from an older release

- If you are upgrading from an older version of the A-4E-C, completely uninstall your old version. If this is a brand new installation, skip this and move on to Step 2.

- First, uninstall the module's files from `%HOMEPATH%\\Saved Games\DCS\Mods\aircraft\A-4E-C`

- Next reset your A-4E-C input bindings by deleting the contents of `%HOMEPATH%\\Saved Games\DCS\Config\Input\A-4E-C`

### STEP 2: Installing the module files

- Download [the latest official A-4E-C release package](https://github.com/heclak/community-a4e-c/releases/). Do not download directly from the Github repository.

- Place the `Mods\aircraft\A-4E-C` folder in into your Windows user folder's Saved Games folder for DCS, e.g. `%HOMEPATH%\Saved Games\Saved Games\DCS`

- If you have installed other DCS World mods, you might already have the `Mods` and `aircraft` folders indicated in the file path. If so, merge the new A-4E-C folder into the existing folders.

- **Never install the A-4E-C files directly into your DCS World installation files!**

### STEP 3: Verify installation

Launch DCS World. If your installation was successful, the A-4E-C theme icon appears as a option in the main menu:

![Image of DCS World Menu with A-4E-C Theme](https://cdn.discordapp.com/attachments/518815335013679104/926862242182488136/unknown.png)

### Installation Troubleshooting

Your correctly installed files should look something like the following image, substituting your Windows account name where the image displays *Partario*. If you're using the openbeta branch of DCS World, the folder might be `DCS.openbeta` instead of `DCS`:

![Image of A-4E-C installation](https://cdn.discordapp.com/attachments/518815335013679104/886633761670828112/unknown.png)

- If you have multiple DCS-related folders in your `%HOMEPATH%\\Saved Games`, for example, `DCS`, or `DCS.openbeta`, and are unsure which folder your DCS World installation is using, locate the `dcs_variant.txt` file in the game files. If this file is present, its contents determines the folder structure your DCS World installation is using. Alternately, load DCS world and use the mission editor to create and save a mission. Search this mission file using Windows explorer to locate the proper folder structure.

- If you have installed the module correctly but it still isn't showing up, ensure it's enabled in the DCS Module Manager. Note that the A-4E-C is not alphabetically arranged along with the official modules in this list, and will be enumerated near the end of the list.

- If you are receiving an authorization error at launch, **you have installed the module incorrectly**. Revisit the installation instructions above. Be sure to remove any and all improperly installed files before correctly installing the module.

- If the A-4E-C icon in the DCS main menu shows a default DCS logo, is missing the theme background and music (or you experience crashes when loading a mission), you have incorrectly downloaded the module. [Download the latest official A-4E-C release package](https://github.com/heclak/community-a4e-c/releases/).

- If you can load a mission, but can't take control of the A-4E-C, ensure you have installed [Microsoft's Visual Studio 2015, 2017 and 2019 Redistributable libraries](https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0). Restart your computer after installation of the appropriate libraries. For most users, this is `vc_redist.x64.exe`. Alternately, ensure your DCS version is at least 2.7.9.1080.

- If you can't find the A-4E-C in the Mission Editor, ensure the historical mode filter is disabled by toggling the clock icon at the bottom of the screen, as shown in the following screenshot:

![Image of the Mission Editor pointing out the location of the Historical Filter](https://cdn.discordapp.com/attachments/518814186739073024/759230033960763422/unknown.png)

### In-Cockpit Troubleshooting

- When setting up your controls, press `LCTRL+Enter` to enable the controls indicator. Control binding information and tips for setting up your devices are provided in the kneeboard manual (`RSHIFT+K`).

- Always keep the canopy open when communicating with the ground crew.

- If you find can't move the throttle, must first adjust the throttle step position. In order to do this, the throttle axis input must be at ZERO. Even if you are a keyboard user, the keyboard controls are adjusting a virtual throttle axis that must be returned to zero before the throttle step position can be adjusted. Use the controls indicator to move the red "ghost" throttle to zero before adjusting the throttle step position.

- Ground steering is accomplished by differential braking. There is no nosewheel steering. The nosewheel caster position is visible on the controls indicator. If you don't have rudder pedals, or are struggling with your keybinds, try the Simple Braking (Rudder Assisted) option in the DCS Special Menu for the A-4E-C.

### Multiplayer Troubleshooting

- A DCS standalone server hosting missions with the A-4E-C must have the A-4E-C module installed.

- A server can host players who do not have the A-4E-C module installed on missions that feature it, you will need to be ready to get a little hands-on with your mission files. The Mission Editor dictates that any mission with an A4-E-C in it requires the module (just as it would any other aircraft), and it's `.miz` mission files are, in fact, `.zip` files.

- Make a copy of your `.miz` file, and rename it with a `.zip` file extension, and unzip it.

- Inside, you will find a `mission` file (no extension). Open this file in your text editor of choice (Notepad works just fine), and search for `requiredModules`. Remove the A-4E-C's entry, as shown in this example:

```
["requiredModules"] =
{
     ["A-4E-C"] = "A-4E-C",
}
```

Once you have completed the edit, save the `mission` file, and re-create a new `.zip` (carefully maintaining proper folder structure, *of course*). Rename your modified mission `.zip` back to a DCS `.miz` file extension instead.

- Finally, test your altered mission by yourself or with a friend to ensure it loads properly, and that clients are able to load into the mission or server without the A4-E-C installed. In this instance, DCS will display any A4-E-C units as an untextured Su-27. Players without the module cannot take control of unit, just as if they did not own any other DCS module in a multiplayer mission.

## Frequently Asked Questions

### Q: Is it really free?

**Yes**! The A-4E-C will remain forever free!

### Q: Are there any plans to obtain the Eagle Dynamics SDK, make the module official, or make the module a part of the default DCS install package?

**No**, the A-4E-C will continue on as a free and open-source resource anyone can download and install to enjoy.

### Q: Can I donate to the A-4E-C project?

**No**, we cannot accept donations, but we appreciate your words of support! There are so many good causes out there. Consider donating to one of those instead!

### Q: Can I get involved with the A-4E-C project?

**Yes**! First, join the [Community A-4E-C Discord server](https://discord.gg/tQZbkTQ) and introduce yourself! We can always use a hand from game artists, programmers or reliable testers as we continue to move the project forward. If you think you have something to contribute, don't hesitate to reach out in the chat.

### Q: Are there manuals or tutorials?

**Yes**! Locating the NATOPS manual for an A-4E/F is the gold standard for understanding this aircraft, but there is a lot of helpful guidance in the included kneeboard manual. To access the manual:
- Once inside the cockpit, open the kneeboard by pressing `RSHIFT+K`
- Read the PDF manual in `%HOMEPATH%\\Saved Games\DCS\Mods\aircraft\A-4E-C\Docs` or [read the kneeboard manual online](https://drive.google.com/drive/folders/1_DPA00CWoRfIsqgh7HYabvpFrOdtBxPi)

The [Community A-4E-C Discord server](https://discord.gg/tQZbkTQ) contains a video hall of fame for high-quality, up-to-date tutorials for all major systems by some of the Community's finest members.

### Q: Is there a paint kit I can use to create my own A-4E-C liveries?

**Yes**! This [A-4E-C Paintkit](https://drive.google.com/open?id=19w_bD8xHJiZpAi1JbA2xyPDJpl9dje-4) includes the aircraft's top, bottom and fuel tanks. See the included liveries for helpful examples setting up your *description.lua* files.

- Liveries created for versions of the A-4E-C prior to 2.0 must update the material names in their *description.lua*. You can use the included `description.lua` files to update

- Install original or downloaded liveries just as you would for any other module, in `%HOMEPATH%\\Saved Games\DCS\Liveries\A-4E-C`

- ***Never put your hard work at risk by installing liveries to the module's files!***

### Q: Can I fly the A-4E-C as a tanker?

**No**, not at this time.

### Q: Will guided weapons like AGM-12 Bullpup or AGM-62 Walleye be added?

The AGM-12C Bullpup is a possibility with more work, but no promises just yet! Our A-4E-C cockpit model lacks the TV monitor used for the Walleye display.

### Q: Why doesn't the A-4E-C have a nosewheel steering button?

There is insufficient evidence to suggest that the A-4E had NWS. According to our research, the revisions and reworks relating to the NWS were applied only to -F models. If you find evidence that -E models did in fact have NWS, please share it!

### Q: Are there any plans to simulate other variants or later models of the A-4?

**No**, there are no plans nor keen interest to pursue this, especially since there is a lot left to add and improve one with our beloved A-4E-C. Additionally, the advanced avionics in later models would not be able to be completed in a satisfying manner.

### Q: Why doesn't the A-4E-C work with my favorite mission or multiplayer scripting system?

Some scripts or other utilities need to be informed of the A-4E-C's existence or other specificities in order to accommodate it. If you know of a mod or script that should accommodate it, be sure to let the author know!

### Q: What's the theme song in the DCS main menu?

*Crow*, by [Eric Haugen](https://erichaugen.bandcamp.com/releases)
