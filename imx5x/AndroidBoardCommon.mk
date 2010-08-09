LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := Dell_Dell_USB_Keyboard.kcm
include $(BUILD_KEY_CHAR_MAP)

include $(CLEAR_VARS)
LOCAL_SRC_FILES := mxckpd.kcm
include $(BUILD_KEY_CHAR_MAP)
