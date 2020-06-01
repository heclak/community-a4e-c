---
layout: default
---

![Community A-4E-C for DCS World](https://user-images.githubusercontent.com/46121009/57830942-41b3da00-77e6-11e9-8e8c-1b7274927bb0.jpg)

The Community A-4E-C represents more than three years of work on behalf of the development team. We’re proud to present the most comprehensive DCS World module to date, boasting such capabilities as air-to-ground radar and carrier operations. The A-4 was a cold war workhorse, providing a capable, reliable light attack aircraft to dozens of nations around the world. From the Sinai Desert to the Jungles of Vietnam, the A-4 was a common sight above cold war battlefields.

We thank the DCS World community for their support over the years, and dedicate the module to our friend, mentor and lead coder, Eric “Gospadin” Mudama. His passion and brilliance left a mark on us all, and this labor of love which would not have been possible without him.

**Please DO NOT redistribute this mod without permission!**

## Contributing Developers

Gospadin, gyrovague, kryb / Archimaede, plusnine, Merker, Jones, Farlander, Heclak, Nero, Dr. Manius

## Special Thanks

SkateZilla, uboats, The Original HoggitDev Team

## Features

- Clickable cockpit
- Air-to-ground radar
- Shrike anti-radiation missile
- Carrier landing and takeoff
- New weapons:
  - AN- series WWII munitions: M30, M57, M65, M66, M81, M88
  - MK4 HIPEG 20 mm gunpod
  - Mk-77 napalm canister
  - SUU-7 bomblet dispenser

### Version 1.4 Featured Changes

- updated carrier launch procedures for more flexible carrier usage
- updated 3D cockpit model and lighting
- new external 3D lighting
- updated liveries with new roughmet files
- complete rewrite of input bindings for consistency
- new collision model and updated critical damage values
- improved systems simulation
- and lots of bug fixes

### Version 1.3 Changelog

- Added carrier catapult mechanics
- Added radar warning receiver system with original sounds
- Aircraft chocks now available, allowing carrier cold starts
- Added collision mesh (aircraft no longer invincible)
- Enhanced shrike functionality, with original sounds
- Reworked cockpit lighting
- Fixed TrackIR issues
- New menu music by Eric Haugen [http://erichaugen.bandcamp.com](http://erichaugen.bandcamp.com)

[See full changelog](https://github.com/heclak/community-a4e-c/blob/master/CHANGELOG.md)

### Known Bugs

#### Dispensing high volumes of bomblets (40+) from SUU-7/CBU-1/CBU-2 causes serious performance dip and/or crashes to desktop

- Drop bomblets in lower release settings via the kneeboard or mission editor

#### TrackIR becomes non-functional when loading into different aircraft cockpits

- This tends only to happen in single player games. Restart DCS World

#### Some aircraft systems are non-functional

- Certain systems are either unimplemented or unable to be replicated by the developers at this time. These include, but are not limited to radio, in-flight refueling, D-704 Buddy refueling pod, and Walleye guided missiles.

Find a bug? Let us know! [Report bugs here](https://github.com/heclak/community-a4e-c/issues)

## Installation

Failure to perform these steps will result in DCS World not recognizing the module, inability to use the module, or input errors when using the module. Never install the A-4E-C files directly into your DCS World installation files!

STEP 1: If you are upgrading from an older version of the A4-E-C, perform these following actions. Otherwise, skip them and move on to Step 2.

- Delete the contents of your old A4-E-C installation folder: `C:\Users\username\Saved Games\DCS\Mods\aircraft\A-4E-C`
- Delete your A4-E-C input settings by opening the following folder: `C:\Users\username\Saved Games\DCS\Input\A4-E-C`
- Delete the joystick, keyboard, mouse and trackir folders.

STEP 2: Install the module files.

- Download the latest official A4-E-C release package. Do not download directly from the Github repository.
- Unzip the contents of the `A4-E-C` folder in the zip into the following folder: `C:\Users\username\Saved Games\DCS`
- If you have installed other DCS World mods, you might already have the `Mods` and `aircraft` folders indicated in the file path. If this is the case, merge the A4-E-C folder into any existing folders, so as to avoid overwriting any other DCS modules you might have installed in these folders.

Your correctly installed files should look something like the following image, substituting your Windows account name where the image displays Partario. If you're using the release branch of DCS World, the folder is `DCS` instead of `DCS.openbeta`.

### Updating to the latest version

To update your A-4E-C to the latest version. You **must delete** the currently installed A-4E-C folder before placing the new version in its place. This is to remove any old files that are no longer used in the updated version. Not doing so will cause problems with your installation.

## Installation Troubleshooting

- Never install the A-4E-C files directly into your DCS World installation files! This can cause your DCS World to not locate the module, create conflicts with other modules, or other problems like failing client integrity checks required by online servers.

- If you have multiple DCS-related folders in your `C:\Users\username\Saved Games`, for example, `DCS`, `DCS.openbeta` or `DCS.openalpha`, locate your DCS World installation folder and open the `dcs_variant.txt` file. If this file is present, it determines the folder structure your DCS World installation is actively using. Ensure the `A-4E-C` folder and its files are installed to the same folder structure the `dcs_variant.txt` file specifies.

## Frequently Asked Questions

**Q: Is it really free?**

- Yes, it’s really free!

**Q: How large is the module?**

- The download file is 442 MB. Installation size is 515 MB.

**Q: Can I donate to the A-4E-C project?**

- We cannot accept donations, but we appreciate your words of support!

**Q: Is there a paint kit I can use to create my own A-4E-C liveries?**

- Indeed, there is! (Requires Adobe Photoshop CC): [Download Paintkit](https://drive.google.com/open?id=19w_bD8xHJiZpAi1JbA2xyPDJpl9dje-4)

**Q: Is there a user manual or tutorials available?**

- Heclak's Community A-4 Guide is a great resource: [Community A-4E-C Guide](https://docs.google.com/presentation/d/1cUH7jpAoGHm-IzUDnv_NDhiZlvX55Q9WvpgR1d9ksYY/edit?usp=sharing)

**Q: Can I use radio functions?**

- We are unable to implement working radios as we do not have access to DCS SDK. This is only available for official 3rd devs so no chance of having radios working. Some mods have functional radios as they are using FC3 modules and wrapping a new model around it. We are a fully custom module (like how 3rd party modules are made) so we can't add radios unless the SDK is opened to the public.

**Q: Can I do aerial refuelling?**

- No. Aerial refuelling cannot be done without functioning radios and we can’t do that because we don’t have access to the SDK.

**Q: Can I fly the A-4E-C as a tanker and refuel other aircraft?**

- No. DCS does not have support for this feature and we are unlikely to be able to support this as we are not an official third party partner.

**Q: When will you be adding the AGM-12 Bullpup?**

- Probably never. Implementing the AGM-12 Bullpup or other guided weapons will require access to the DCS SDK. This is only available to official 3rd party devs so we do not have the required support to implement this.

**Q: When will you be adding the AGM-62 Walleye?**

- Probably never. Implementing the AGM-62 Walleye will require access to the DCS SDK. This is only available to official 3rd party devs so we do not have the required support to implement this. Additionally, the specific airframe/cockpit that we have modelled does not have the ability to carry the AGM-62 Walleye. A-4Es that were able to carry the AGM-62 Walleye had the ground radar display replaced with a TV monitor for use with the AGM-62 Walleye. For that fact, it would not be possible for this aircraft to use the AGM-62 Walleye and it is not in the plans to implement it.