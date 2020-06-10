![Community A-4E-C for DCS World](https://user-images.githubusercontent.com/46121009/57830942-41b3da00-77e6-11e9-8e8c-1b7274927bb0.jpg)

The Community A-4E-C represents more than three years of work on behalf of the development team. We’re proud to present the most comprehensive DCS World module to date, boasting such capabilities as air-to-ground radar and carrier operations. The A-4 was a cold war workhorse, providing a capable, reliable light attack aircraft to dozens of nations around the world. From the Sinai Desert to the Jungles of Vietnam, the A-4 was a common sight above cold war battlefields.

We thank the DCS World community for their support over the years, and dedicate the module to our friend, mentor and lead coder, Eric “Gospadin” Mudama. His passion and brilliance left a mark on us all, and this labor of love which would not have been possible without him.

**Please DO NOT redistribute this mod without permission!**

## Contributing Developers

Gospadin, gyrovague, kryb / Archimaede, plusnine, Merker, Jones, Farlander, Heclak, Nero, Dr. Manius

## Special Thanks

SkateZilla, uboats, The Original HoggitDev Team, LevelPulse, Cubeboy, Luciano, Malamem, [Eric Haugen](http://erichaugen.bandcamp.com)

## Features

- Clickable cockpit
- Air-to-ground radar
- Shrike anti-radiation missile
- Carrier landing and takeoff
- New weapons:
  - AN- series WWII munitions: M66, M81, M88
  - MK4 HIPEG 20 mm gunpod
  - Mk-77 napalm canister
  - SUU-7 bomblet dispenser

### Version 1.4 Changelog: Featured Items

- Updated carrier launch procedures for more facile carrier launches from the Stennis
- Configuration for catapult behavior added to module options in the DCS main menu. From the DCS World main menu, see Options > Special > A-4E-C
- Updated cockpit model, interior and exterior lighting
- Updated collision model, critical damage, and IR profile
- Improved systems modeling
- Added SRS functionality to radio
- Complete rewrite of inputs to accommodate additional input scenarios
- Updated and added new liveries and RoughMet maps
- Added new Instant Action missions
- Removed AN-30, AN-57, and AN-65 models and textures (official versions of these munitions are now provided by DCS World)
- Lots and lots of bug fixes

[See full changelog](https://github.com/heclak/community-a4e-c/blob/master/CHANGELOG.md)

### Known Bugs

#### Dispensing high volumes of bomblets (40+) from SUU-7/CBU-1/CBU-2 causes serious performance dip and/or crashes to desktop

- Drop bomblets in lower release settings via the kneeboard (RShift+K by default), mission editor, or the Automatic Weapons Release System (AWRS).

#### TrackIR becomes non-functional when loading into different aircraft cockpits

- This tends only to happen in single player games. Restarting DCS World usually solves this problem.

Find a bug? [Let us know!](https://github.com/heclak/community-a4e-c/issues)

## Installation

Failure to perform these steps will result in DCS World not recognizing the module, inability to use the module, input errors when using the module, or client integrity check failures on multiplayer servers that require them. Never install the A-4E-C files directly into your DCS World installation files!

### STEP 1: Upgrading from an older release

If you are upgrading from an older version of the A4-E-C, perform these following actions. You must delete the currently installed A-4E-C files before installing the new version, as some important files have been removed for this release, and your input binding must be reset and rebound in order to accommodate this release’s enhanced control scheme. If this is a new installation, skip this step and move on to Step 2.

- Delete the contents of your old A4-E-C installation folder: `C:\Users\username\Saved Games\DCS\Mods\aircraft\A-4E-C`
- Delete your A4-E-C input settings by opening the following folder: `C:\Users\username\Saved Games\DCS\Input\A4-E-C`
- Delete the joystick, keyboard, mouse and trackir folders.

### STEP 2: Installing the module files.

- Download the latest official A4-E-C release package. Do not download directly from the Github repository.
- Unzip the contents of the `A4-E-C` folder in the zip into the following folder: `C:\Users\username\Saved Games\DCS`
- If you have installed other DCS World mods, you might already have the `Mods` and `aircraft` folders indicated in the file path. If this is the case, merge the A4-E-C folder into any existing folders, so as to avoid overwriting any other DCS modules you might have installed in these folders.

Your correctly installed files should look something like the following image, substituting your Windows account name where the image displays Partario. If you're using the release branch of DCS World, the folder is `DCS` instead of `DCS.openbeta`.

![Image of A-4E-C installation](https://user-images.githubusercontent.com/46121009/84217257-3b358600-aafe-11ea-9203-20d787b09662.png)

### STEP 3: Launch DCS World and verify installation

When you are confident your files are correctly installed, launch DCS World. If your installation was successful, the A4-E-C’s theme icon appears as a option in the main menu:

![Image of DCS World Menu with A-4E installed](https://cdn.discordapp.com/attachments/518815071858589697/720094260699070464/unknown.png)

## Installation Troubleshooting

- Never, ever install the A-4E-C files directly into your DCS World installation files! This will cause your DCS World to not locate the module, create conflicts with other modules, and other problems.

- If you have multiple DCS-related folders in your `C:\Users\username\Saved Games`, for example, `DCS`, `DCS.openbeta` or `DCS.openalpha`, locate your DCS World installation folder and locate the `dcs_variant.txt` file. If this file is present, its contents determines the folder structure your DCS World installation is using.

## Frequently Asked Questions

**Q: Is it really free?**

- Yes, it’s really free!

**Q: How large is the module?**

- The download file is 584 MB. Installation size is 606 MB.

**Q: Can I donate to the A-4E-C project?**

- We cannot accept donations, but we appreciate your words of support! There are so many good causes out there. Consider donating to one of those instead!

**Q: Can I get involved with the A-4E-C project?**

- Yes! Join our Discord server and introduce yourself! We can always use a hand from game artists, programmers or reliable testers as we move the project forward. If you think you have skills to contribute, don’t hesitate!

**Q: Is there a user manual or tutorials available?**

- [Heclak's Community A-4E Guide](https://docs.google.com/presentation/d/1cUH7jpAoGHm-IzUDnv_NDhiZlvX55Q9WvpgR1d9ksYY/edit?usp=sharing) is a great resource

**Q: Is there a paint kit I can use to create my own A-4E-C liveries?**

- Yes! This [A-4E-C Paintkit](https://drive.google.com/open?id=19w_bD8xHJiZpAi1JbA2xyPDJpl9dje-4) includes the aircraft’s top, bottom and fuel tanks. See the included liveries for lua examples. If you created liveries for older versions of the A4-E-C, you might want to update them to accommodate new changes in the external model in the newer version.

**Q: Can I use radio functions?**

- We are unable to implement fully functioning radios, as we do not have access to DCS Software Development Kit (SDK). The SDK is only available to official 3rd-party DCS developers, so the likelihood this functionality can be added in the future is slim. Other mods with functional radios tend to piggy-back on FC3 modules, changing only animation arguments, and not module functionality. The A-4E-C is a wholly original module, so we can't add radios unless ED decides to open the functionality to the list of commonly accessible functions to modders.

**Q: Can I do aerial refuelling? Can I fly the A-4E-C as a tanker?**

- Unfortunately, any meaningful aerial refuelling scenario of any kind involving the A-4E-C would also require access to the SDK.

**Q: What about the AGM-12 Bullpup or AGM-62 Walleye?**

- Implementing guided weapons would also require access to the SDK. Additionally, the specific airframe/cockpit that we have modelled is not equipped to accommodate the AGM-62 Walleye. A-4Es that were able to carry the AGM-62 Walleye had the ground radar display replaced with a TV monitor for use with the AGM-62 Walleye.

**Q: What kinds of interactions does the A-4E-C have with the Supercarrier?**

- At the moment, most of the active A4E-C developers don’t own the Supercarrier module, and it is still extremely new. We’ll be looking at things in the next patch, but without access to the SDK, additional functionality with the Supercarrier should be thought of as anything but guaranteed.