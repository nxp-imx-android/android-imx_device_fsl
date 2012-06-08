#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/imx6sl.mk

TARGET_BOOTLOADER_BOARD_NAME := ARM2
BOARD_SOC_CLASS := IMX6

# Wifi
BOARD_WLAN_DEVICE := ar6003
BOARD_HAS_ATH_WLAN := true
BOARD_WLAN_ATHEROS_SDK := system/wlan/atheros/compat-wireless
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_0_9_ATHEROS
HOSTAPD_VERSION := VER_0_9_ATHEROS
WIFI_DRIVER_MODULE_PATH         := "/system/lib/modules/ath6kl_sdio.ko"
WIFI_DRIVER_MODULE_NAME         := "ath6kl_sdio"
WIFI_DRIVER_MODULE_ARG          := "suspend_mode=2 ath6kl_p2p=1"
WIFI_DRIVER_P2P_MODULE_ARG      := "suspend_mode=2 ath6kl_p2p=1 debug_mask=0x2413"
WIFI_SDIO_IF_DRIVER_MODULE_PATH := "/system/lib/modules/cfg80211.ko"
WIFI_SDIO_IF_DRIVER_MODULE_NAME := "cfg80211"
WIFI_SDIO_IF_DRIVER_MODULE_ARG  := ""
ATH_LINUXPATH := $(PWD)/kernel_imx
ATH_CROSS_COMPILE_TYPE:= $(PWD)/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-
WIFI_COMPAT_MODULE_PATH  := "/system/lib/modules/compat.ko"
WIFI_COMPAT_MODULE_NAME  := "compat"
WIFI_COMPAT_MODULE_ARG   := ""
WIFI_TEST_INTERFACE      := "sta"

BOARD_MODEM_VENDOR := AMAZON

TARGET_TS_CALIBRATION := true
TARGET_TS_DEVICE := "mxc_ts"

BOARD_RECOVERY_PARTITION_SIZE = 10M
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 209715200
BOARD_HAVE_BLUETOOTH := true
BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_HAVE_IMX_CAMERA := false
#BOARD_CAMERA_LIBRARIES := libcamera
BOARD_HAVE_WIFI := true
BOARD_HAVE_MODEM := true
BOARD_MODEM_HAVE_DATA_DEVICE := true
BOARD_HAVE_HARDWARE_GPS := false
BOARD_HAS_SENSOR := false
SENSOR_MMA8451 := false
BOARD_HAVE_HARDWARE_GPS := false
USE_ATHR_GPS_HARDWARE := false
USE_QEMU_GPS_HARDWARE := false
#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := false
SENSOR_MMA8451 := false
# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true
BOARD_KERNEL_BASE :=  0x80800000
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0
TARGET_KERNEL_DEFCONF := imx6s_android_defconfig
TARGET_BOOTLOADER_CONFIG := mx6sl_arm2_android_config
