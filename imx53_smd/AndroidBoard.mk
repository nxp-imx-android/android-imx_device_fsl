LOCAL_PATH := $(call my-dir)

include device/fsl/imx5x/AndroidBoardCommon.mk

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif

include device/fsl-proprietary/media-profile/media-profile.mk
include device/fsl-proprietary/gpu/fsl-gpu.mk
include device/fsl-proprietary/sensor/fsl-sensor.mk
