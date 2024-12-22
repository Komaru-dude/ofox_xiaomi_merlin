#!/system/bin/sh
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2024 The OrangeFox Recovery Project
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

source /system/bin/begonia_funcs.sh;

rom_has_hw_encryption() {
local D=/FFiles/temp/vendor_tmp;
local S=/dev/block/bootdevice/by-name/vendor;
local F=/FFiles/temp/beanpod.blob;
    	mkdir -p $D;
    	cd /FFiles/temp/;
    	mount -r $S $D;
	cp $D/bin/hw/android.hardware.keymaster@4.0-service.beanpod $F;
    	umount $D;
	rmdir $D;

	local T=$(grep libshim $F);
	if [ -n "$T" ]; then
		TESTING_LOG "Hardware encryption found";
		resetprop "ro.orangefox.variant" "hw_encryption";
		resetprop "fox.hardware.encryption" "1";
		echo "1";
		return;
	fi

	TESTING_LOG "Hardware encryption NOT found!";
	resetprop "ro.orangefox.variant" "sw_encryption";
	resetprop "fox.hardware.encryption" "0";
	echo "0";
}

check_hw_encryption() {
local src="/hw_encrypt/android.hardware.keymaster@4.0-service.beanpod";
local src2="/sw_encrypt/android.hardware.keymaster@4.0-service.beanpod";
local dest="/vendor/bin/hw/android.hardware.keymaster@4.0-service.beanpod";
local F=$(rom_has_hw_encryption);
	TESTING_LOG "rom_has_hw_encryption=$F"
	if [ "$F" = "1" ]; then
		cp -af $src $dest;
	else
		cp -af $src2 $dest;
	fi
	chmod 0755 $dest;
}

#
TESTING_LOG "Running $0";
check_hw_encryption;
TESTING_LOG "Finished with $0";
exit 0;
#
