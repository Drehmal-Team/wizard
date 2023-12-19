## Basic Python Installer

### install.py

Script to install everything needed for Drehmal with as little friction as possible.

##### Goals:

- Checks host OS to base install location(s) on
- Downloads the map file
- Downloads the resource pack
- Downloads and installs fabric
- Downloads and installs client-side mods
- Creates a named Minecraft launcher profile

All in all, running this script will **download and fully install** Drehmal. The only thing the user needs to do is open their Minecraft launcher, select the new profile and hit play.

Currently uses Google drive as the source for the map. As many Google drive sources can be specified, and they will be used as fallbacks if limits are reached.

##### Todo List

- ❌ Test on Linux
- ❌ Test on MacOs
- ✅ Refactor code into explicit functions
- ✅ Set Drehmal Resource Pack as active
- ✅ Additional Google Drive map sources
- ❌ Add non-gdrive map sources (eg. drehmal.net sharded archives)
- ✅ Cleanup installation files (fabric launcher, map tarball)
- ❌ (?) Create backend server pointing to up to date resources
- ❌ Additional code comments

### split.py

Script to shard and unshard the map folder into multiple folders for use with size-restricted hosts (eg. drehmal.net). Though this is made _for_ the Drehmal map, it can work with any folder input.

The script is currently functional, but not as user friendly as it should be -- requires some developer knowledge. That is _okay_ as it'll only be used by the Drehmal team, but it isn't ideal. As-is, it's mostly a proof of concept to figure out a memory-efficient way of splitting a >5GB file.

##### Goals:

- Walk through the input folder, copying files into subdirectories of an output folder; Each subdirectory has a maximum size
- Compress each subdir into a tarball (.tar.gz)
- Extract each compressed subdir
- Compile the extracted subdirectories

##### Todo List

- ❌ Allow user to specify folder paths for:
  - Input folder (`./map`)
  - Output split folder (`./split`)
  - Output archive folder (`./archive`)
  - Input archive folder (`./archive`)
  - Output extracted folder (`./extracted_map`)
- ❌ Additional code comments
