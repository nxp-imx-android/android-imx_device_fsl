#
# Product-specific compile-time definitions.
#

TARGET_BOARD_PLATFORM := imx6
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH := arm
TARGET_KERNEL_ARCH := $(TARGET_ARCH)
TARGET_UBOOT_ARCH := $(TARGET_ARCH)
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a9
ARCH_ARM_HAVE_TLS_REGISTER := true

TARGET_NO_BOOTLOADER := true
TARGET_NO_KERNEL := false
TARGET_NO_RECOVERY := false
TARGET_NO_RADIOIMAGE := true

BOARD_BOOTIMG_HEADER_VERSION := 1
BOARD_MKBOOTIMG_ARGS = --header_version $(BOARD_BOOTIMG_HEADER_VERSION)

BOARD_SOC_CLASS := IMX6

#BOARD_USES_GENERIC_AUDIO := true
BOARD_USES_ALSA_AUDIO := true
BOARD_HAVE_BLUETOOTH := true
USE_CAMERA_STUB := false

BOARD_HAVE_WIFI := true

BOARD_NOT_HAVE_MODEM := false
BOARD_MODEM_VENDOR := HUAWEI
BOARD_MODEM_ID := EM750M
BOARD_MODEM_HAVE_DATA_DEVICE := true
BOARD_HAVE_IMX_CAMERA := true
BOARD_HAVE_USB_CAMERA := false

TARGET_USERIMAGES_BLOCKS := 204800

# Enable dex-preoptimization to speed up first boot sequence
ifeq ($(HOST_OS),linux)
   ifeq ($(TARGET_BUILD_VARIANT),user)
	ifeq ($(WITH_DEXPREOPT),)
	    WITH_DEXPREOPT := true
	endif
   endif
endif
# for ums config, only export one partion instead of the whole disk
UMS_ONEPARTITION_PER_DISK := true

PREBUILT_FSL_IMX_CODEC := true
PREBUILT_FSL_IMX_OMX := false
PREBUILT_FSL_IMX_GPU := true

# override some prebuilt setting if DISABLE_FSL_PREBUILT is define
ifeq ($(DISABLE_FSL_PREBUILT),GPU)
PREBUILT_FSL_IMX_GPU := false
else ifeq ($(DISABLE_FSL_PREBUILT),ALL)
PREBUILT_FSL_IMX_GPU := false
endif

# Indicate use vivante drm based egl and gralloc
BOARD_GPU_DRIVERS := vivante

# Indicate use NXP libdrm-imx or Android external/libdrm
BOARD_GPU_LIBDRM := libdrm_imx

# for kernel/user space split
# comment out for 1g/3g space split
# TARGET_KERNEL_2G := true

BOARD_DTBOIMG_PARTITION_SIZE := 4194304
BOARD_BOOTIMAGE_PARTITION_SIZE := 50331648
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 50331648

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1879048192
BOARD_CACHEIMAGE_PARTITION_SIZE := 444596224
BOARD_VENDORIMAGE_PARTITION_SIZE := 117440512
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE = ext4
TARGET_COPY_OUT_VENDOR := vendor
TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx6sl
# default shipping android version or8.0
PRODUCT_SHIPPING_API_LEVEL := 26

BOARD_FLASH_BLOCK_SIZE := 4096
TARGET_RECOVERY_UI_LIB := librecovery_ui_imx

-include device/google/gapps/gapps_config.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_ms_codec/BoardConfig.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_real_dec/BoardConfig.mk
