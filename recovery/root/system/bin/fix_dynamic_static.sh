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

TESTING_LOG "Dynamic ROM";
setprop "is_dynamic_rom" "true"; # save as a prop
resetprop "fox_dynamic_device" "1";

# --- #
TESTING_LOG "Running $0";
exit 0;
#
