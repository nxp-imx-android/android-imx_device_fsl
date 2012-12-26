#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6sl.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
include device/fsl/imx6/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := EVK

BOARD_SOC_CLASS := IMX6
PRODUCT_MODEL := EVK_MX6SL

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
BOARD_WPA_SUPPLICANT_DRIVER      	 := NL80211
BOARD_HOSTAPD_DRIVER             	 := NL80211
WIFI_TEST_INTERFACE			 := "sta"

BOARD_MODEM_VENDOR := AMAZON

BOARD_HAVE_HARDWARE_GPS := true
USE_ATHR_GPS_HARDWARE := true
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
#BOARD_HAS_SENSOR := true
#SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := false

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

USE_CAMERA_STUB := true
BOARD_HAVE_IMX_CAMERA := false
PRODUCT_MODEL := EVK-MX6SL

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 androidboot.hardware=freescale
TARGET_BOOTLOADER_CONFIG := mx6sl:mx6sl_evk_android_config
