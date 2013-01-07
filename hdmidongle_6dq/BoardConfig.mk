#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/hdmidongle_6dq/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

TARGET_BOOTLOADER_BOARD_NAME := HDMIDONGLE
PRODUCT_MODEL := HDMIDONGLE-MX6DQ

TARGET_USERIMAGES_USE_EXT4 := false
TARGET_USERIMAGES_USE_UBIFS = true
BOARD_WLAN_VENDOR 			 := NULL

# Wifi
#for realtek vendor
ifeq ($(BOARD_WLAN_VENDOR), REALTEK)
WPA_SUPPLICANT_VERSION := VER_0_8_X_RTL
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_rtl
BOARD_WLAN_DEVICE := rtl8192cu
#BOARD_WLAN_DEVICE := rtl8192du
#BOARD_WLAN_DEVICE := rtl8192ce
#BOARD_WLAN_DEVICE := rtl8192de
#BOARD_WLAN_DEVICE := rtl8723as
#BOARD_WLAN_DEVICE := rtl8723au
#BOARD_WLAN_DEVICE := rtl8188es
WIFI_DRIVER_MODULE_NAME := 8192ce
WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/8192ce.ko"
WIFI_DRIVER_MODULE_ARG := ""
WIFI_FIRMWARE_LOADER := ""
WIFI_DRIVER_FW_PATH_STA := ""
WIFI_DRIVER_FW_PATH_AP := ""
WIFI_DRIVER_FW_PATH_P2P := ""
WIFI_DRIVER_FW_PATH_PARAM := ""

TARGET_KERNEL_MODULES := \
    kernel_imx/drivers/net/wireless/rtl8192ce/8192ce.ko:system/lib/modules/8192ce.ko  \
    kernel_imx/net/wireless/cfg80211.ko:system/lib/modules/extra/cfg80211.ko

BOARD_WPA_SUPPLICANT_DRIVER      	 := NL80211
endif

BOARD_HOSTAPD_DRIVER             	 := NL80211
WIFI_TEST_INTERFACE			 := "sta"

BOARD_HAVE_HARDWARE_GPS := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := false

# for recovery service
TARGET_SELECT_KEY := 28

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := device/fsl/hdmidongle_6dq/ubi/ubinize.ini
# for Micron MT29F32G08CBACAWP
TARGET_MKUBIFS_ARGS := -m 4096 -e 1040384 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 1024KiB $(UBI_ROOT_INI)
# for Micron MT29F32G08MAA
#TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
#TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)
endif

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := false

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

#UBI boot command line.
BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=28M fb0base=0x27b00000 vmalloc=400M androidboot.console=ttymxc3  mtdparts=gpmi-nand:20m(bootloader),20m(bootimg),20m(recovery),-(root) gpmi_debug_init ubi.mtd=3 enable_wait_mode=off androidboot.hardware=freescale

TARGET_BOOTLOADER_CONFIG := 6q:mx6q_hdmidongle_nand_android_config 6dl:mx6dl_hdmidongle_nand_android_config
