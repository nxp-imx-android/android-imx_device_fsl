LOCAL_PATH := $(call my-dir)

include device/fsl/common/build/kernel.mk
include device/fsl/common/build/uboot.mk
include device/fsl/evk_8mm/AndroidUboot.mk
include device/fsl/evk_8mm/AndroidTee.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/sensor/fsl-sensor.mk
