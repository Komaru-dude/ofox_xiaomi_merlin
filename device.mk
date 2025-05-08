#
# Copyright (C) 2022 The Android Open Source Project
# Copyright (C) 2022 SebaUbuntu's TWRP device tree generator
#
# Copyright (C) 2023-2024 The OrangeFox Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/base.mk)

LOCAL_PATH := device/xiaomi/merlinx

# API
PRODUCT_SHIPPING_API_LEVEL := 29

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# framerate
TW_FRAMERATE := 60

# Crypto
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true

# platform
PLATFORM_SECURITY_PATCH := 2127-12-31
VENDOR_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
BOOT_SECURITY_PATCH := $(PLATFORM_SECURITY_PATCH)
PLATFORM_VERSION := 99.87.36
PLATFORM_VERSION_LAST_STABLE := $(PLATFORM_VERSION)

# Additional target Libraries
TARGET_RECOVERY_DEVICE_MODULES += \
    libkeymaster4 \
    libpuresoftkeymasterdevice

TW_RECOVERY_ADDITIONAL_RELINK_LIBRARY_FILES += \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libpuresoftkeymasterdevice.so

# OEM otacert
PRODUCT_EXTRA_RECOVERY_KEYS += \
    vendor/recovery/security/miui

PRODUCT_USE_DYNAMIC_PARTITIONS := true
  
PRODUCT_PROPERTY_OVERRIDES += \
ro.boot.dynamic_partitions=true \
ro.crypto.dm_default_key.options_format.version=2 \
ro.crypto.volume.filenames_mode=aes-256-cts \
ro.crypto.volume.metadata.method=dm-default-key \
ro.crypto.volume.options=::v2 \
ro.crypto.allow_encrypt_override=true

# fastbootd - doesn't work (device not detected)
TW_INCLUDE_FASTBOOTD := true
PRODUCT_PROPERTY_OVERRIDES += \
ro.fastbootd.available=true
 
PRODUCT_PACKAGES += \
android.hardware.fastboot@1.0-impl-mock \
android.hardware.fastboot@1.0-impl-mock.recovery \
fastbootd

# initial prop for variant
ifneq ($(FOX_VARIANT),)
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.orangefox.variant=$(FOX_VARIANT)
else
  PRODUCT_PROPERTY_OVERRIDES += \
	ro.orangefox.variant=default
endif
#
