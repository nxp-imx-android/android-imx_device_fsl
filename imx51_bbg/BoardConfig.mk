#
# Product-specific compile-time definitions.
#

include device/fsl/imx5x/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := imx51_bbg

BOARD_SOC_CLASS := IMX5X
BOARD_SOC_TYPE := IMX51
BOARD_SOC_REV := TO2

WIFI_DRIVER_MODULE_PATH :=  "/system/lib/modules/ar6000.ko"
WIFI_DRIVER_MODULE_ARG      := ""
WIFI_DRIVER_MODULE_NAME     := "ar6000"
WIFI_FIRMWARE_LOADER        := ""

HAVE_FSL_IMX_GPU := true
HAVE_FSL_IMX_IPU := true

BOARD_CAMERA_NV12 := false

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT2 := true
