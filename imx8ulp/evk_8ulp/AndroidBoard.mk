LOCAL_PATH := $(call my-dir)

include $(CONFIG_REPO_PATH)/common/build/dtbo.mk
include $(CONFIG_REPO_PATH)/common/build/imx-recovery.mk
include $(CONFIG_REPO_PATH)/common/build/gpt.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
-include $(IMX_MEDIA_CODEC_XML_PATH)/mediacodec-profile/mediacodec-profile.mk
