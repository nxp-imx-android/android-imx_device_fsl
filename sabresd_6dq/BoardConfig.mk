#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/sabresd_6dq/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
# sabresd_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk


TARGET_BOOTLOADER_BOARD_NAME := SABRESD
PRODUCT_MODEL := SABRESD-MX6DQ

# Wifi
BOARD_WLAN_VENDOR 			 := ATHEROS
# for atheros vendor
ifeq ($(BOARD_WLAN_VENDOR),ATHEROS)
BOARD_WLAN_DEVICE			 := ar6003
BOARD_HAS_ATH_WLAN 			 := true
WPA_SUPPLICANT_VERSION			 := VER_0_8_ATHEROS
WIFI_DRIVER_MODULE_PATH          	 := "/system/lib/modules/ath6kl_sdio.ko"
WIFI_DRIVER_MODULE_NAME          	 := "ath6kl_sdio"
WIFI_DRIVER_MODULE_ARG           	 := "suspend_mode=3 wow_mode=2 ar6k_clock=26000000 ath6kl_p2p=1"
WIFI_DRIVER_P2P_MODULE_ARG       	 := "suspend_mode=3 wow_mode=2 ar6k_clock=26000000 ath6kl_p2p=1 debug_mask=0x2413"
WIFI_SDIO_IF_DRIVER_MODULE_PATH  	 := "/system/lib/modules/cfg80211.ko"
WIFI_SDIO_IF_DRIVER_MODULE_NAME  	 := "cfg80211"
WIFI_SDIO_IF_DRIVER_MODULE_ARG   	 := ""
WIFI_COMPAT_MODULE_PATH			 := "/system/lib/modules/compat.ko"
WIFI_COMPAT_MODULE_NAME			 := "compat"
WIFI_COMPAT_MODULE_ARG			 := ""
endif
#for intel vendor
ifeq ($(BOARD_WLAN_VENDOR),INTEL)
BOARD_HOSTAPD_PRIVATE_LIB		 ?= private_lib_driver_cmd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB 	 ?= private_lib_driver_cmd
WPA_SUPPLICANT_VERSION			 := VER_0_8_X
HOSTAPD_VERSION				 := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd_intel
WIFI_DRIVER_MODULE_PATH          	 := "/system/lib/modules/iwlagn.ko"
WIFI_DRIVER_MODULE_NAME          	 := "iwlagn"
WIFI_DRIVER_MODULE_PATH			 ?= auto
endif
BOARD_WPA_SUPPLICANT_DRIVER      	 := NL80211
BOARD_HOSTAPD_DRIVER             	 := NL80211
WIFI_TEST_INTERFACE			 := "sta"

BOARD_MODEM_VENDOR := AMAZON

BOARD_HAVE_HARDWARE_GPS := true
USE_ATHR_GPS_HARDWARE := true
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

# uncomment below lins if use NAND
#TARGET_USERIMAGES_USE_UBIFS = true


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := device/fsl/sabresd_6dq/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init video=mxcfb0:dev=ldb,bpp=32 video=mxcfb1:off video=mxcfb2:off fbmem=10M fb0base=0x27b00000 vmalloc=400M androidboot.console=ttymxc0 androidboot.hardware=freescale bluetooth

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/fsl/sabresd_6dq/bluetooth

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3


TARGET_BOOTLOADER_CONFIG := 6q:mx6q_sabresd_android_config 6dl:mx6dl_sabresd_android_config


