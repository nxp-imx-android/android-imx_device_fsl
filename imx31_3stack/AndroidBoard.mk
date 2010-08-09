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

ifeq ($(BOARD_HAVE_BLUETOOTH),true)
    PRODUCT_COPY_FILES += \
        $(LOCAL_PATH)/mxc_bt.sh:system/etc/bluez/mxc_bt.sh \
        $(LOCAL_PATH)/csr.psr:system/etc/bluez/csr.psr
endif

# freescale proprietary code
#
proprietary := $(LOCAL_DIR)/../proprietary

#PRODUCT_COPY_FILES += \
#  $(proprietary/libgps.so:system/lib/libgps.so \
#  $(proprietary/libcamera.so:system/lib/libcamera.so \

#  copy ubinize.ini
ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/ubinize.ini:ubinize.ini \
    $(LOCAL_PATH)/ubinize_reco.ini:ubinize_reco.ini
endif

include $(CLEAR_VARS)

file := $(TARGET_OUT_KEYLAYOUT)/mxckpd.kl

ALL_PREBUILT += $(file)

$(file): $(LOCAL_PATH)/mxckpd.kl | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := mxckpd.kcm

include $(BUILD_KEY_CHAR_MAP)

# vold conf
file := $(TARGET_OUT)/etc/vold.conf

ALL_PREBUILT += $(file)

$(file): $(LOCAL_PATH)/vold.conf | $(ACP)
	$(transform-prebuilt-to-target)
