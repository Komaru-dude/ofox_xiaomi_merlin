#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2023 The OrangeFox Recovery Project
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
FDEVICE="begonia"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep \"$FDEVICE\")
   if [ -n "$chkdev" ]; then
      FOX_BUILD_DEVICE="$FDEVICE"
   else
      chkdev=$(set | grep BASH_ARGV | grep \"$FDEVICE\")
      [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
   fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
   fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
        export FOX_ENABLE_APP_MANAGER=1
        export ALLOW_MISSING_DEPENDENCIES=true
	export TARGET_DEVICE_ALT="begoniain"
	export FOX_TARGET_DEVICES="begoniain,begonia"
        export OF_SCREEN_H=2340
        export OF_STATUS_H=80
	export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
	export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
	export OF_SKIP_MULTIUSER_FOLDERS_BACKUP=1
	export OF_FBE_METADATA_MOUNT_IGNORE=1
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_USE_NANO_EDITOR=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_ZIP_BINARY=1
	export FOX_USE_SED_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export OF_USE_GREEN_LED=0

	# patch avb20 - some ROM recoveries try to overwrite custom recoveries
	export OF_PATCH_AVB20=1

	# quick backup defaults
        export OF_QUICK_BACKUP_LIST="/boot;/data;/system_image;/vendor_image;"

	# whether to permit free access to internal storage
	export OF_RUN_POST_FORMAT_PROCESS=1

	export FOX_BUGGED_AOSP_ARB_WORKAROUND="1546300800"; # Tuesday, January 1, 2019 12:00:00 AM GMT+00:00

	# necessary to decrypt most begonia ROMs
	export OF_FIX_DECRYPTION_ON_DATA_MEDIA=1
	export OF_LEGACY_PROCESS_FSTAB=1

       	# ensure that /sdcard is bind-unmounted before f2fs data repair or format
       	export OF_UNBIND_SDCARD_F2FS=1

	# flashlight doesn't work
	export OF_FLASHLIGHT_ENABLE=0

	# no MIUI stuff
	export OF_DISABLE_OTA_MENU=1

	# let's see what are our build VARs
	if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
  	   export | grep "FOX" >> $FOX_BUILD_LOG_FILE
  	   export | grep "OF_" >> $FOX_BUILD_LOG_FILE
   	   export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
  	   export | grep "TW_" >> $FOX_BUILD_LOG_FILE
 	fi
else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
#
