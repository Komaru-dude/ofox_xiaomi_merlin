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
			LOGMSG "The ROM has changed the recovery, it seems.";
			resetprop "found_fox_overwriting_rom" "";
			F=/tmp/fox_backup.img;
			if [ -f "$F" ]; then	
				LOGMSG "Restoring OrangeFox from backup ...";
				cat $F /dev/zero > /dev/block/bootdevice/by-name/recovery 2>/dev/null;
				rm $F;
 			fi
		else
			TESTING_LOG "POST_ROM_FLASH: the ROM did not change the recovery, it seems.";
		fi
	else
     		TESTING_LOG "POST_ROM_FLASH: not checking for overwrite/restore";
	fi
}

#
LOGMSG "Starting $0 ...";
check_replace;
exit 0;
