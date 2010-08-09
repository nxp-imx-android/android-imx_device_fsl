LOCAL_PATH := $(call my-dir)

include device/fsl/imx5x/AndroidBoardCommon.mk

file := $(TARGET_OUT_KEYLAYOUT)/mxckpd.kl
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/mxckpd.kl | $(ACP)
	$(transform-prebuilt-to-target)

file := $(TARGET_ROOT_OUT)/init.rc
ALL_PREBUILT += $(file)
$(file) : $(LOCAL_PATH)/init.rc | $(ACP)
	$(transform-prebuilt-to-target)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mxckpd.kcm
include $(BUILD_KEY_CHAR_MAP)

# prebuilt Broadcom GPS library
#
include $(CLEAR_VARS)
LOCAL_MODULE := glgps
LOCAL_MODULE_PATH := $(TARGET_OUT)/bin
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := glconfig.xml
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

# bluetooth script and pskey
ifeq ($(BOARD_HAVE_BLUETOOTH),true)
include $(CLEAR_VARS)
LOCAL_MODULE := mxc_bt.sh
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/bluez
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := csr.psr
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/bluez
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)
endif

# freescale proprietary code
#
proprietary := $(LOCAL_DIR)/../proprietary

#  copy ubinize.ini
ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
include $(CLEAR_VARS)
LOCAL_MODULE := ubinize.ini
LOCAL_MODULE_PATH := $(PRODUCT_OUT)
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)

include $(CLEAR_VARS)
LOCAL_MODULE := ubinize_reco.ini
LOCAL_MODULE_PATH := $(PRODUCT_OUT)
LOCAL_MODULE_CLASS := ETC
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)
endif

#freescale logo
include $(CLEAR_VARS)
LOCAL_MODULE := freescale_logo.rle
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_ROOT_OUT)
LOCAL_SRC_FILES := $(LOCAL_MODULE)
include $(BUILD_PREBUILT)
