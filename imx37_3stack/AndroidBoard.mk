LOCAL_PATH := $(call my-dir)

# keyboard layouts
#
# PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/imx51_3stack_keypad.kl:system/usr/keylayout/imx51_3stack_keypad.kl

# board specific init.rc
#
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.rc:root/init.rc

# prebuilt CSR wifi driver
#
#PRODUCT_COPY_FILES += \
#    $(LOCAL_PATH)/wlan.ko:system/lib/modules/wlan.ko

# prebuilt CSR GPS library
#
#PRODUCT_COPY_FILES += \

# freescale proprietary code
#
proprietary := $(LOCAL_DIR)/../proprietary

#PRODUCT_COPY_FILES += \
#  $(proprietary/libgps.so:system/lib/libgps.so \
#  $(proprietary/libcamera.so:system/lib/libcamera.so \

#  copy ubinize.ini
ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/ubinize.ini:ubinize.ini
endif

# vold conf
file := $(TARGET_OUT)/etc/vold.conf

ALL_PREBUILT += $(file)

$(file): $(LOCAL_PATH)/vold.conf | $(ACP)
	$(transform-prebuilt-to-target)
