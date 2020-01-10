LOCAL_PATH := $(call my-dir)

include device/fsl/common/build/dtbo.mk
include device/fsl/common/build/imx-recovery.mk
include device/fsl/common/build/gpt.mk
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/media-profile/media-profile.mk
ifneq ($(PRODUCT_IMX_CAR),true)
include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/sensor/fsl-sensor.mk
endif

ifneq ($(BOARD_OTA_BOOTLOADERIMAGE),)
  INSTALLED_RADIOIMAGE_TARGET += $(PRODUCT_OUT)/bootloader.img
  BOARD_PACK_RADIOIMAGES += bootloader.img
endif

