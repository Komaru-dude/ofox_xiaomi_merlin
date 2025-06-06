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
FDEVICE="merlinx"

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
        export ALLOW_MISSING_DEPENDENCIES=true
        export FOX_ENABLE_APP_MANAGER=1
	export TARGET_DEVICE_ALT="merlinx"
	export FOX_TARGET_DEVICES="merlinx,merlin"
	export FOX_USE_BASH_SHELL=1
	export FOX_ASH_IS_BASH=1
	export FOX_BASH_TO_SYSTEM_BIN=1
	export FOX_USE_TAR_BINARY=1
	export FOX_USE_XZ_UTILS=1
	export FOX_USE_LZ4_BINARY=1
	export FOX_USE_ZSTD_BINARY=1
	export FOX_USE_SPECIFIC_MAGISK_ZIP=~/Magisk/Magisk-v27.0.zip
	export FOX_VANILLA_BUILD=1
	export FOX_DELETE_INITD_ADDON=1
	export FOX_USE_BUSYBOX_BINARY=1
        export OF_MAINTAINER="Komaru-dude"

	# make all builds dynamic
	export FOX_USE_DYNAMIC_PARTITIONS=1
	if [ "$FOX_USE_DYNAMIC_PARTITIONS" = "1" ]; then
		export FOX_VARIANT="HWe"; # this will support only hardware encryption
	fi
else
	if [ -z "$FOX_BUILD_DEVICE" -a -z "$BASH_SOURCE" ]; then
		echo "I: This script requires bash. Not processing the $FDEVICE $(basename $0)"
	fi
fi
#
