#!/system/bin/sh

#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2023-2024 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
#

source /system/bin/begonia_funcs.sh

# check for overwrite and restore
check_replace() {
local F=$(getprop "restore_fox_after_flashing");
	if [ "$F" = "1" -o "$F" = "true" ]; then
		F=$(getprop "found_fox_overwriting_rom");
		if [ "$F" = "1" ]; then
			LOGMSG "PRE_ROM_FLASH: the ROM will change the recovery, it seems. Backing up OrangeFox to restore after flashing the ROM...";
			dd bs=1048576 if="/dev/block/bootdevice/by-name/recovery" of="/tmp/fox_backup.img";
		else
			TESTING_LOG "PRE_ROM_FLASH: the ROM has NOT changed the recovery, it seems.";
		fi
	else
     		TESTING_LOG "PRE_ROM_FLASH: not checking for overwrite/restore";
	fi
}

#
LOGMSG "Starting $0 ...";
check_replace;
exit 0;

