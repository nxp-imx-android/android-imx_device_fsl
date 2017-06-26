LOCAL_PATH := $(call my-dir)

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif

include device/fsl-proprietary/media-profile/media-profile.mk
include device/fsl-proprietary/sensor/fsl-sensor.mk
include device/fsl/evk_8mq/AndroidUboot.mk
