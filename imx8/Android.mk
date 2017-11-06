LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := IMXLinks
LOCAL_MODULE_TAGS := optional

LOCAL_POST_INSTALL_CMD := \
    mkdir $(PRODUCT_OUT)/system/lib64/hw; \
    ln -sf /system/lib64/hw/bootctrl.avb.so $(PRODUCT_OUT)/system/lib64/hw/bootctrl.default.so

include $(BUILD_PHONY_PACKAGE)
