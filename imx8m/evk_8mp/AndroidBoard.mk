LOCAL_PATH := $(call my-dir)

include device/fsl/common/build/dtbo.mk
include device/fsl/common/build/imx-recovery.mk
include device/fsl/common/build/gpt.mk
#TODO add imx8mp target
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/sensor/fsl-sensor.mk
