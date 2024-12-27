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

CP_CMD="/system/bin/cp";

rom_has_hw_encryption() {
local D=/FFiles/temp/vendor_tmp;
local S=/dev/block/bootdevice/by-name/vendor;
local F=/FFiles/temp/beanpod.blob;
local T;
    	mkdir -p $D;
    	cd /FFiles/temp/;

	mount -r $S $D;
	# this shouldn't happen
	if [ "$?" != "0" ]; then
		TESTING_LOG "Error mounting $S on $D.";
		rmdir $D;
		echo "-1";
		return;
	fi

	local pod="$D/bin/hw/android.hardware.keymaster@4.0-service.beanpod";
	if [ -f $pod ]; then
		TESTING_LOG "Found keymaster beanpod.";
		$CP_CMD $pod $F;
	else
		T=$(getprop "is_dynamic_rom");
		if [ "$T" = "true" ]; then
			TESTING_LOG "I cannot find keymaster beanpod on dynamic ROM.";
			umount $D;
			rmdir $D;
			echo "-2";
			return;
		else
			TESTING_LOG "I cannot find the keymaster beanpod. Assuming software encryption.";
		fi
	fi

	# remove tmp dir
    	umount $D;
	rmdir $D;

	# check for hardware beanpod indicator
	if [ -f "$F" ]; then
		T=$(grep libshim $F);
		if [ -n "$T" ]; then
			TESTING_LOG "Hardware encryption found.";
			set_crypt_credentials "hard";
			echo "1";
			return;
		fi
	fi

	# software
	TESTING_LOG "Hardware encryption NOT found!";
	set_crypt_credentials "soft";
	echo "0";
}

check_hw_encryption() {
local HWe_pod="/hw_encrypt/android.hardware.keymaster@4.0-service.beanpod";
local SWe_pod="/sw_encrypt/android.hardware.keymaster@4.0-service.beanpod";
local vendor_bin_hw_pod="/vendor/bin/hw/android.hardware.keymaster@4.0-service.beanpod";
local F;
	 # bale out if this is a dynamic build (hardcoded hardware keymaster beanpod)
	F=$(is_dynamic_fox);
	if [ "$F" = "1" ]; then
		TESTING_LOG "Dynamic builds feature a hardcoded hardware keymaster beanpod.";
		return;
	fi

	F=$(rom_has_hw_encryption);
	TESTING_LOG "rom_has_hw_encryption=$F";
	if [ "$F" = "-1" -o "$F" = "-2" ]; then
		TESTING_LOG "Something happened (code=$F). Using the default beanpod.";
		F=/vendor/bin/hw/android.hardware.keymaster@4.0-service.beanpod;
		local T=$(grep libshim $F);
		if [ -n "$T" ]; then
			set_crypt_credentials "hard";
			TESTING_LOG "Default = hardware";
		else
			set_crypt_credentials "soft";
			TESTING_LOG "Default = software";
		fi
	elif [ "$F" = "1" ]; then
		TESTING_LOG "$CP_CMD $HWe_pod $vendor_bin_hw_pod";
		$CP_CMD -F $HWe_pod $vendor_bin_hw_pod;
		TESTING_LOG "Result=$?";
	else
		rm -f $vendor_bin_hw_pod;
		TESTING_LOG "$CP_CMD -F $SWe_pod $vendor_bin_hw_pod";
		$CP_CMD -F $SWe_pod $vendor_bin_hw_pod;
		TESTING_LOG "Result=$?";
	fi
	chmod 0755 $vendor_bin_hw_pod;
}

#
TESTING_LOG "Running $0";
check_hw_encryption;
TESTING_LOG "Finished with $0";
exit 0;
#
