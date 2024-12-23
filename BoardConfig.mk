#
# Copyright (C) 2022 The Android Open Source Project
# Copyright (C) 2022 SebaUbuntu's TWRP device tree generator
#
# Copyright (C) 2023-2024 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/xiaomi/begonia

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a76

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_2ND_CPU_VARIANT_RUNTIME := cortex-a76

# AVB
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3
BOARD_AVB_RECOVERY_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_RECOVERY_ALGORITHM := SHA256_RSA2048
BOARD_AVB_RECOVERY_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_RECOVERY_ROLLBACK_INDEX_LOCATION := 1

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := begonia
TARGET_NO_BOOTLOADER := true

# File systems
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_COPY_OUT_VENDOR := vendor
TARGET_USES_MKE2FS := true

# Kernel
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 androidboot.selinux=permissive androidboot.usbconfigfs=true loop.max_part=7

ifeq ($(FOX_USE_STOCK_KERNEL),1)
# prebuilt MIUI kernel 4.14.186-g759c88b6c5dc
   KERNEL_DIRECTORY := $(DEVICE_PATH)/prebuilt/stock
else
   KERNEL_DIRECTORY := $(DEVICE_PATH)/prebuilt
endif

BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_PREBUILT_DTBIMAGE_DIR := $(KERNEL_DIRECTORY)/dtbs
BOARD_PREBUILT_DTBOIMAGE := $(KERNEL_DIRECTORY)/dtbo.img
TARGET_PREBUILT_KERNEL := $(KERNEL_DIRECTORY)/Image.gz-dtb
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_BOOTIMG_HEADER_VERSION := 2
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_RAMDISK_OFFSET := 0x07c08000
BOARD_KERNEL_TAGS_OFFSET := 0x0bc08000
BOARD_DTB_OFFSET := 0x0bc08000
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)

# Platform
TARGET_BOARD_PLATFORM := mt6785

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop

# Recovery
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
TARGET_RECOVERY_DEVICE_DIRS += $(DEVICE_PATH)
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# TWRP Configuration
RECOVERY_SDCARD_ON_DATA := true
TW_THEME := portrait_hdpi
TW_EXTRA_LANGUAGES := true
TW_SCREEN_BLANK_ON_BOOT := true
TW_INPUT_BLACKLIST := "hbtp_vm"
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 2047
TW_DEFAULT_BRIGHTNESS := 1024
TW_EXCLUDE_APEX := true
TW_INCLUDE_NTFS_3G := true
TW_INCLUDE_RESETPROP := true
TW_INCLUDE_REPACKTOOLS := true
TW_EXCLUDE_DEFAULT_USB_INIT := true
TW_CUSTOM_CPU_TEMP_PATH := /sys/devices/virtual/thermal/thermal_zone4/temp

# deal with broken stuff
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Debug flags
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true

# support "fastboot update <zip-file>"
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt

# Private test builds?
ifeq ($(LOCAL_TEST_BUILD),1)
  PRODUCT_COPY_FILES += $(call find-copy-subdir-files,*,$(DEVICE_PATH)/Testing/,$(TARGET_COPY_OUT_RECOVERY)/root/system/bin/)
endif

# retrofitted dynamic partitions?
ifeq ($(FOX_USE_DYNAMIC_PARTITIONS),1)
  KEYMASTER_BEANPOD_DIR := $(DEVICE_PATH)/recovery/root/hw_encrypt
  BOARD_SUPER_PARTITION_BLOCK_DEVICES := vendor system
  BOARD_SUPER_PARTITION_METADATA_DEVICE := system
  BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE := 1610612736
  BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE := 3758096384
  BOARD_SUPER_PARTITION_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_VENDOR_DEVICE_SIZE) + $(BOARD_SUPER_PARTITION_SYSTEM_DEVICE_SIZE))
  BOARD_SUPER_PARTITION_GROUPS := xiaomi_dynamic_partitions
  BOARD_XIAOMI_DYNAMIC_PARTITIONS_SIZE := $(shell expr $(BOARD_SUPER_PARTITION_SIZE) - 4194304)
  BOARD_XIAOMI_DYNAMIC_PARTITIONS_PARTITION_LIST := odm product system system_ext vendor

  TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/fstab_files/recovery-dynamic.fstab
  PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/fstab_files/twrp-dynamic.flags:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.flags
  BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
else
  KEYMASTER_BEANPOD_DIR := $(DEVICE_PATH)/recovery/root/sw_encrypt
  TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/fstab_files/recovery-non-dynamic.fstab
  PRODUCT_COPY_FILES += $(DEVICE_PATH)/recovery/fstab_files/twrp-non-dynamic.flags:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/twrp.flags
endif

PRODUCT_COPY_FILES += $(KEYMASTER_BEANPOD_DIR)/android.hardware.keymaster@4.0-service.beanpod:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/bin/hw/android.hardware.keymaster@4.0-service.beanpod

# copy recovery/fstab_files/ from the device directory (if it exists)
ifneq ($(wildcard $(DEVICE_PATH)/recovery/fstab_files/.),)
    PRODUCT_COPY_FILES += \
        $(call find-copy-subdir-files,*,$(DEVICE_PATH)/recovery/fstab_files/*,$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/)
endif
#
