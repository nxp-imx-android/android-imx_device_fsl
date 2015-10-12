LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAT_MODULE_TAGS = optional
LOCAL_SRC_FILES := $(call all-subdir-java-files)
LOCAL_MODULE := freescale-extended

include $(BUILD_JAVA_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE := freescale-extended.xml
LOCAL_MODULE_TAGS := eng
LOCAL_MODULE_CLASS := ETC
LOCAL_MODULE_PATH := $(TARGET_OUT_ETC)/permissions
LOCAL_SRC_FILES := $(LOCAL_MODULE)

include $(BUILD_PREBUILT)
