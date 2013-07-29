#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/hdmidongle_6dq/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
# hdmidongle_6dq default built for NAND device
BUILD_TARGET_FS ?= ubifs
include device/fsl/imx6/imx6_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/hdmidongle_6dq/fstab_nand.freescale:root/fstab.freescale
else
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/hdmidongle_6dq/fstab.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS

TARGET_BOOTLOADER_BOARD_NAME := HDMIDONGLE
PRODUCT_MODEL := HDMIDONGLE-MX6DQ

BOARD_WLAN_VENDOR 			 := REALTEK

# Wifi
#for realtek vendor
ifeq ($(BOARD_WLAN_VENDOR), REALTEK)
WPA_SUPPLICANT_VERSION := VER_0_8_X_RTL
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_rtl
BOARD_WLAN_DEVICE := UNITE
#BOARD_WLAN_DEVICE := rtl8192du
#BOARD_WLAN_DEVICE := rtl8192ce
#BOARD_WLAN_DEVICE := rtl8192de
#BOARD_WLAN_DEVICE := rtl8723as
#BOARD_WLAN_DEVICE := rtl8723au
#BOARD_WLAN_DEVICE := rtl8188es
WIFI_DRIVER_MODULE_NAME := 8192ce
WIFI_DRIVER_MODULE_PATH := "/system/lib/modules/8192ce.ko"
WIFI_DRIVER_MODULE_ARG := "ifname=wlan0 if2name=p2p0"
WIFI_FIRMWARE_LOADER := ""
WIFI_DRIVER_FW_PATH_STA := ""
WIFI_DRIVER_FW_PATH_AP := ""
WIFI_DRIVER_FW_PATH_P2P := ""
WIFI_DRIVER_FW_PATH_PARAM := ""

TARGET_KERNEL_MODULES := \
    kernel_imx/drivers/net/wireless/rtl8192ce/8192ce.ko:system/lib/modules/8192ce.ko

BOARD_WPA_SUPPLICANT_DRIVER      	 := NL80211
endif

BOARD_HOSTAPD_DRIVER             	 := NL80211
WIFI_TEST_INTERFACE			 := "sta"

BOARD_HAVE_HARDWARE_GPS := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := false

# for recovery service
TARGET_SELECT_KEY := 28

# BOARD_KERNEL_CMDLINE
BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=28M fb0base=0x27b00000 vmalloc=400M androidboot.console=ttymxc3 enable_wait_mode=off androidboot.hardware=freescale

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := device/fsl/hdmidongle_6dq/ubi/ubinize.ini
# for Micron MT29F32G08CBACAWP
TARGET_MKUBIFS_ARGS := -m 4096 -e 1040384 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 1024KiB $(UBI_ROOT_INI)
# for Micron MT29F32G08MAA
#TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
#TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)

# Note: this NAND partition table must align with MFGTool's config.
#BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) ubi.mtd=3
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:20m(bootloader),20m(bootimg),20m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := false

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3


TARGET_BOOTLOADER_CONFIG := 6q:mx6q_hdmidongle_nand_android_config 6dl:mx6dl_hdmidongle_nand_android_config
TARGET_KERNEL_DEFCONF := imx6_hdmidongle_android_defconfig
