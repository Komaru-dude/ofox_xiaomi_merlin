#!/system/bin/sh
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2019-2024 The OrangeFox Recovery Project
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
# This script requires bash (with the binary in /system/bin/ - not /sbin/) - build with FOX_BASH_TO_SYSTEM_BIN=1
#

source /system/bin/begonia_funcs.sh;

# do the work
process_fstab_files() {
  local F="/system/etc/recovery.fstab";
  local TF="/system/etc/twrp.flags";
  local src_fstab="/system/etc/recovery-non-dynamic.fstab";
  local src_flags="/system/etc/twrp-non-dynamic.flags";

  local D1=$(is_dynamic_fox);
  local D=$(rom_has_dynamic_partitions);  
  if [ "$D" = "1" ]; then
  	src_fstab="/system/etc/recovery-dynamic.fstab";
  	src_flags="/system/etc/twrp-dynamic.flags";
  	TESTING_LOG "Dynamic ROM";
  	setprop "is_dynamic_rom" "true"; # save as a prop
  	if [ "$D1" = "0" ]; then # this is a non-dynamic OrangeFox build
		LOGMSG "The installed ROM has retrofitted dynamic partitions.";
	else
		resetprop "fox_dynamic_device" "1";
  	fi
  else
    	TESTING_LOG "Non-dynamic ROM";
  	setprop "is_dynamic_rom" "false"; # save as a prop
  	if [ "$D1" = "1" ]; then # this is a dynamic OrangeFox build
		TESTING_LOG "The installed ROM is non-dynamic.";
  		resetprop "fox_dynamic_device" "0";
	fi
  fi
  
  # sort out the fstab files
  TESTING_LOG "Copying $src_fstab to $F";
  cp -a $src_fstab $F;

  TESTING_LOG "Copying $src_flags to $TF";
  cp -a $src_flags $TF;
  
#  do_cleanup;
}

# --- #
TESTING_LOG "Running $0";
process_fstab_files;
setenforce 0;
exit 0;
#
