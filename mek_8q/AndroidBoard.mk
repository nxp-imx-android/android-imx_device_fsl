LOCAL_PATH := $(call my-dir)

include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
ifneq ($(PRODUCT_IMX_CAR),true)
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/sensor/fsl-sensor.mk
endif
include device/fsl/mek_8q/AndroidUboot.mk
