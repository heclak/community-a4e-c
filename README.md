![Community A-4E-C for DCS World](https://user-images.githubusercontent.com/46121009/57830942-41b3da00-77e6-11e9-8e8c-1b7274927bb0.jpg)

The Community A-4E-C represents more than three years of work on behalf of the development team. We’re proud to present the most comprehensive DCS World module to date, boasting such capabilities as air-to-ground radar and carrier operations. The A-4 was a cold war workhorse, providing a capable, reliable light attack aircraft to dozens of nations around the world. From the Sinai Desert to the Jungles of Vietnam, the A-4 was a common sight above cold war battlefields.

After severel years of development, we are pleased to announce version 2.0 of the module, with a realistic flight model, the addition of a CP-741/a CCRP bombing computer, increased DCS functionality, increased carrier compatibility, and myriad new sounds and keybinds to increase your ease of use and immersion when flying this now-venerable module.

We thank the DCS World community for their support over the years, and dedicate the module to our friend, mentor and lead coder, Eric “Gospadin” Mudama. His passion and brilliance left a mark on us all, and this labor of love which would not have been possible without him.

**Please DO NOT redistribute this mod without permission!**

## Contributing Developers

Gospadin, Heclak, Joshua Nelson, plusnine, Farlander, gyrovague, kryb/Archimaede, Merker, Jones, Nero

## Special Thanks

SkateZilla, uboats, Dr. Manius, LevelPulse, Cubeboy, Talo, Gvad, Sidekick65, HellesBelles, SPINEG, Sport, rudel-chw, Luciano, Malamem, Rob, ataribaby, The Original HoggitDev Team, [Eric Haugen](http://erichaugen.bandcamp.com)

## Features

- Realistic external flight model and engine simulation
- Clickable cockpit
- Carrier landing and takeoff
- Air-to-air refueling
- AN/APG-53A Radar (air-to-ground)
- AN/APN-153 Doppler Nav
- AN/ASN-41 Nav Computer  
- AFCS
- ARC-51A UHF Radio
- ARN-52 TACAN 
- ARA-63 MCL (ICLS)
- CP-741/a Bombing computer (CCRP)
- Shrike anti-radiation missile
- New weapons:
  - AN- series WWII munitions: M66, M81, M88
  - MK4 HIPEG 20 mm gunpod
  - Mk-77 napalm canister
  - SUU-7 bomblet dispenser
- Unique sounds inside and outside the aircraft

### Version 2.0 Changelog: Featured Items

- Features: External Flight Model (EFM) with flight dynamics, suspension, slat simulation, cockpit shake, wing vapour and more.
- Features: Realistic engine simulation
- Features: Added SuperCarrier compatibility
- Features: Added ARC-51A UHF Radio functions (thanks Harald)
- Features: Added ARN-52 TACAN and ARA-63 MCL (ICLS) functions
- Features: Added CP-741/a bombing computer (set CMPTR on weapon selector and use slick bombs)
- Features: Added air-to-air refueling capabilities
- Features: Added nosewheel steering and differential braking
- Features: Added SUU-25 Parachute illumination pod for night ops
- Systems: AFCS Added stability augmentation (be sure to enable this yaw-dampening system on the AFCS panel before takeoff!)
- Systems: Added sidewinders to loadout options on outer pylons
- Systems: Added SUU-25 parachute illumination pod to loadout options
- Systems: Added empty fuel tanks to loadout options
- Systems: Added fuel flow system
- Systems: Added oxygen system (pilots must now beware of hypoxia!)
- Systems: Added drift to AN/ASN-41 Nav Computer
- Misions: Added instant action missions (thanks Sidekick65, Cubeboy and SPINEG)
- Misions: Added runway strike and anti-ship strike roles
- Textures: Exterior texture improvements, added normal maps (thanks HellesBelles for their contribution)
- Textures: Cockpit improvements, added normal maps (thanks Sport for their contribution)
- Textures: Added a diverse array of new helmets and pilot uniforms and patches across liveries
- Liveries: Added Argentina and Chile as available countries for the A-4E-C
- Liveries: Added Argentine Brigada (thanks GVad, for these paints and much more)
- Liveries: Added Community III: Forever Free livery
- Liveries: Reformatted livery description.lua templates (livery creators, see our updated paintkit)
- Liveries: Inaccuracies corrected (within the available modex systems, with great apologies to the non-USN/USMC operators)
- Quality of Life: Added loads of new keybinds (thanks to the userbase for documenting many of these.)
- Quality of Life: Added cockpit controls indicator
- Quality of Life: Added several new helpful kneeboard pages (thanks to Rob for drafting several pages)
- Quality of Life: Trim reset now provides a smooth transition
- Quality of Life: Added in-cockpit sounds and improved user feedback
- Quality of Life: Revised special menu options
- Quality of Life: Fixed FFB stick support
- Quality of Life: Slats locking option for aerobatic performance teams
- Quality of Life: Smokewinder pod easier to operate (weapon select independent)
- Quality of Life: Lots, and lots, and we mean LOTS of bug fixes

[See full changelog](https://github.com/heclak/community-a4e-c/blob/master/CHANGELOG.md)

### Known Bugs

- Pilot blacks out when hooking into SuperCarrier (throttle up hard to cat-in!)
- Fuel system cuts off if auto pause is left on for too long
- Throttle position occasionally stuck in OFF position after rearm
- APC system is underresponsive
- Some missions created in DCS 2.7 or later render navigation system inoperable
- TEST press can cause ECM panel lights to stick on
- IN RANGE lamp flickers when TEST is pressed
- AN/ASN-41 navigation BDHI needle animations swapped in test mode
- Switch position slightly off for Fuel Trans Bypass and Dead Recon

[see full issue list](https://github.com/heclak/community-a4e-c/issues/)

#### Dispensing high volumes of bomblets (40+) from SUU-7/CBU-1/CBU-2 causes serious performance dip and/or crashes to desktop

- Drop bomblets in lower release settings via the kneeboard (RShift+K by default), mission editor, or the Automatic Weapons Release System (AWRS).

## Installation

Failure to perform these steps will result in DCS World not recognizing the module, inability to use the module, input errors when using the module, or client integrity check failures on multiplayer servers that require them. Never install the A-4E-C files directly into your DCS World installation files!

### STEP 1: Upgrading from an older release

If you are upgrading from an older version of the A-4E-C, perform these following actions. You must completely delete the currently installed A-4E-C files before installing the new version, as some important files have been removed for this.

Additionally your input bindings must be reset and rebound in order to accommodate this release’s enhanced control scheme. If this is a new installation, you can skip this step and move on to Step 2.

- Delete the contents of your old A-4E-C installation folder: `C:\Users\username\Saved Games\DCS\Mods\aircraft\A-4E-C`
- Delete your A-4E-C input settings by opening the following folder: `C:\Users\username\Saved Games\DCS\Config\Input\A-4E-C`
- Delete the joystick, keyboard, mouse and trackir folders.

### STEP 2: Installing the module files.

- Download the latest official A-4E-C release package. Do not download directly from the Github repository.
- Place the included `Mods\aircraft\A-4E-C` folder in into your `C:\Users\username\Saved Games\DCS` folder.
- If you have installed other DCS World mods, you might already have the `Mods` and `aircraft` folders indicated in the file path. If this is the case, merge the new A-4E-C folder into the existing folders.

Your correctly installed files should look something like the following image, substituting your Windows account name where the image displays Partario. If you're using the release branch of DCS World, the folder is `DCS` instead of `DCS.openbeta`.

![Image of A-4E-C installation](https://user-images.githubusercontent.com/46121009/84217257-3b358600-aafe-11ea-9203-20d787b09662.png)

### STEP 3: Launch DCS World and verify installation

When you are confident your files are correctly installed, launch DCS World. If your installation was successful, the A-4E-C theme icon appears as a option in the main menu:

![Image of DCS World Menu with A-4E installed](https://cdn.discordapp.com/attachments/518815071858589697/720094260699070464/unknown.png)

## Installation Troubleshooting

- Never, ever install the A-4E-C files directly into your DCS World installation files! This will cause your DCS World to not locate the module, create conflicts with other modules, and other problems.

- If you have multiple DCS-related folders in your `C:\Users\username\Saved Games`, for example, `DCS`, or `DCS.openbeta`. If you are unsure which folder your DCS World installation is using, locate the `dcs_variant.txt` file in the game files. If this file is present, its contents determines the folder structure your DCS World installation is using.

- If you are recieving an authorization error, you have installed the module incorrectly. Double check the installation instructions above, ensure you have have installed the module to the correct folder, and do not have any improperly installed files remaining in your DCS world game files. Any conflicts will result in the persistence of this this error.

- If you find you can't take control of the aircraft, ensure you have installed Microsoft's Visual Studio 2015, 2017 and 2019 Redistributable libraries. Windows users running DCS world are typically running x64, so you will want to download and install vc_redist.x64.exe (~15 MB) from the following page, install the library, and then restart your computer: (https://support.microsoft.com/en-us/topic/the-latest-supported-visual-c-downloads-2647da03-1eea-4433-9aff-95f26a218cc0)

- If you cannot find the A-4E-C as a unit option in the Mission Editor, Ensure the historical mode filter is disabled in the mission editor by toggling the clock icon at the bottom of the screen, as shown in the following screenshot:

![Image of the Mission Editor pointing out the location of the Historical Filter](https://cdn.discordapp.com/attachments/518814186739073024/759230033960763422/unknown.png)

## Frequently Asked Questions and Troubleshooting

**Q: Is it really free?**

- Yes, it’s really free!

**Q: How large is the module?**

- The download file is ~700 MB. Installation size is ~800 MB.

**Q: Can I donate to the A-4E-C project?**

- We cannot accept donations, but we appreciate your words of support! There are so many good causes out there. Consider donating to one of those instead!

**Q: Can I get involved with the A-4E-C project?**

- Yes! [Join the Community A-4E-C Discord server](https://discord.gg/tQZbkTQ) and introduce yourself! We can always use a hand from game artists, programmers or reliable testers as we continue to move the project forward. If you think you have something to contribute, don’t hesitate!

**Q: Is there a user manual or tutorials available?**

- There is some helpful pilot guidance included in the kneeboard. The NATOPS manual for the A-4E is the gold standard, but [Heclak's Community A-4E Guide](https://docs.google.com/presentation/d/1cUH7jpAoGHm-IzUDnv_NDhiZlvX55Q9WvpgR1d9ksYY/edit?usp=sharing) is a great resource for operating the sim (althought it may take us some time to get it up to date with 2.0's features), and [Sidekick65's YouTube Channel](https://www.youtube.com/channel/UC4kJt_8Jw9ByL10ar6b8rQg) features many good tutorials on systems and weaponry. 

**Q: Is there a paint kit I can use to create my own A-4E-C liveries?**

- Yes! This [A-4E-C Paintkit](https://drive.google.com/open?id=19w_bD8xHJiZpAi1JbA2xyPDJpl9dje-4) includes the aircraft’s top, bottom and fuel tanks. See the included liveries for lua examples. If you created liveries for older versions of the A-4E-C, you might want to update them to accommodate new changes in the external model in the newer version.

**Q: Can I fly the A-4E-C as a tanker?**

- The A-4E-C serving as a player-piloted tanker would also require access to the SDK.

**Q: What about the AGM-12 Bullpup or AGM-62 Walleye?**

- Implementing guided weapons would also require access to the SDK. Additionally, the specific airframe/cockpit that we have modelled is not equipped to accommodate the AGM-62 Walleye. A-4Es that were able to carry the AGM-62 Walleye had the ground radar display replaced with a TV monitor for use with the AGM-62 Walleye.

**Q: Why is my standalone server rejecting missions with the A-4E-C?**

- A standalone server requires an installation of the A-4E-C module in order to host missions that feature it.

**Q: Is there a way I can host missions with the A-4E-C on my multiplayer server that won't lock out players who do not have the module installed?**

- Yes, but it's a little involved. It's not DCS that is locking players out, but the Mission Editor deciding that any mission with an A4-E-C placed down is going to require the module. 

- As there's no in-engine way of de-flagging this, you'll need to get hands-on with your mission files. 
You may or may not already know that the *.miz* mission files are, in fact, *.zip* files. So, take the mission file you desire to edit, and make a copy with a *.zip* extension. Find somewhere handy to unzip it.
- Inside, you will find a *mission* file (no extension). Open this file in your text-editor of choice, and search required to find the mission's list of required modules, and then remove the A-4E-C entry from the list, as shown in Line 32 in this screenshot:

![Image of a mission file with the A4-E-C required module on Line 32](https://cdn.discordapp.com/attachments/757126581729886328/847194735167799346/unknown.png)

- Save the mission file, and re-create a new *.zip* (carefully maintaining proper folder structure, *bien sur*) and renaming it with a *.miz* file extension.
- Test your altered mission by yourself or with a friend to ensure it loads properly, and that clients are able to load into the mission or server without the A4-E-C installed. In this instance, DCS should display any A4-E-C units as default-livery Su-27s, and players without the module should not be able to take control of the module, as if they did not own a for-pay aircraft.

**Q: Are there any plans to make the module official, obtain the Eagle Dynamics SDK, or make the module a part of the default DCS install package?**

- No, there are no plans nor keen interest to pursue this. The project will continue as a free and open-source resource you can download and install to enjoy.

**Q: Why doesn't the A-4E-C work with my favorite mission or multiplayer scripting system?**

- Some scripts or other utilities need to be informed of the A-4E-C's existence in order to accommodate it. If you have a favorite popular mod, script that should accommodate it, be sure to let the author know!

**Q: What's the song in the menu?**
- Crow, by [Eric Haugen](https://erichaugen.bandcamp.com/releases)
