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

# set to 1 during the testing phase, else set to 0
debug_mode=1;

# write a message to the log file
LOGMSG() {
	echo "I:$@" >> /tmp/recovery.log;
}

# test-phase log messages
TESTING_LOG() {
	[ "$debug_mode" = "1" ] && LOGMSG "$@";
}

# are we running the dynamic variant of OrangeFox?
is_dynamic_fox() {
local d=$(getprop "ro.boot.dynamic_partitions");
local e=$(getprop "ro.boot.dynamic_partitions_retrofit");
local v=$(getprop "ro.orangefox.variant");
	if  [ "$v" = "HWe" -o "$v" = "dynamic" -o "$v" = "HWE" ] || [ "$d" = "true" -a "$e" = "true" ]; then
		echo "1";
	else
		echo "0";
	fi
}

# report whether the ROM has dynamic partitions
rom_has_dynamic_partitions() {
# the device that we are building for
local BUILD_DEVICE=begonia;
  local markers=""$BUILD_DEVICE"_dynamic_partitions xiaomi_dynamic_partitions qti_dynamic_partitions "$BUILD_DEVICE"_dynpart xiaomi_dynpart qti_dynpart";
  local F=/tmp/blck_tmp;
  dd if=/dev/block/by-name/system bs=256k count=1 of=$F;
  strings $F | grep dyn > "$F.txt";
  for i in $markers
  do
	TESTING_LOG "Checking for $i in $F.txt";
	if grep $i "$F.txt" > /dev/null; then
		echo "1";
		[ "$debug_mode" != "1" ] && rm -f $F*;
		return;
     	fi
  done
  [ "$debug_mode" != "1" ] && rm -f $F*;
  echo "0";
}

# cleanup
do_cleanup() {
	TESTING_LOG "Cleaning up ...";
	rm -f /system/etc/recovery-*;
	rm -f /system/etc/twrp-*;  
}
#
