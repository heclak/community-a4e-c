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

### Version 1.3 Changelog

- Added carrier catapult mechanics
- Added radar warning receiver system with original sounds
- Aircraft chocks now available, allowing carrier cold starts
- Added collision mesh (aircraft no longer invincible)
- Enhanced shrike functionality, with original sounds
- Reworked cockpit lighting
- Fixed TrackIR issues
- New menu music by Eric Haugen [http://erichaugen.bandcamp.com](http://erichaugen.bandcamp.com)

[See full changelog](CHANGELOG.md)

### Known Bugs

#### Dispensing high volumes of bomblets (40+) from SUU-7/CBU-1/CBU-2 causes serious performance dip and/or crashes to desktop

- Drop bomblets in lower release settings via the kneeboard or mission editor

#### TrackIR becomes non-functional when loading into different aircraft cockpits

- This tends only to happen in single player games. Restart DCS World

#### Some aircraft systems are non-functional

- Certain systems are either unimplemented or unable to be replicated by the developers at this time. These include, but are not limited to radio, in-flight refueling, D-704 Buddy refueling pod, and Walleye guided missiles.

Find a bug? Let us know! [Report bugs here](https://github.com/heclak/community-a4e-c/issues)

## Installation

Download the latest A-4E-C installation file from the [releases page](https://github.com/heclak/community-a4e-c/releases/)

Unzip the contents of the zip file into the following folder: `C:\Users\username\Saved Games\DCS`

_To assist JSGME users, we’ve included the “mods/aircraft/” folders in the zip. You can safely merge these folders with your DCS World user folder._

### Updating to the latest version

To update your A-4E-C to the latest version. You **must delete** the currently installed A-4E-C folder before placing the new version in its place. This is to remove any old files that are no longer used in the updated version. Not doing so will cause problems with your installation.

## Troubleshooting

If you have used multiple instances of DCS World (especially users who have used DCS_updater.exe to change versions of their installation), you may need to experiment to locate the correct DCS World user folder, e.g. `C:\Users\username\Saved Games\DCS`

The correct folder might not match the version of DCS World you are using. You can quickly identify which folder is in use by your computer by launching DCS world, creating and saving a mission file in the mission editor and noting its file name and location.

Do not attempt to install the A-4E-C module files directly into your DCS World installation folder. This will cause the A-4E-C to fail, and your client will fail any file integrity checks made by multiplayer servers!

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