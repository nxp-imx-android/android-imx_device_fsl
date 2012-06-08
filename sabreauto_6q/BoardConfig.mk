#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

BOARD_SOC_CLASS := IMX6
BOARD_SOC_TYPE := IMX6Q

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

WIFI_DRIVER_MODULE_NAME     := "ar6000"
HOSTAPD_VERSION             := VER_0_8_ATHEROS
WPA_SUPPLICANT_VERSION      := VER_0_8_ATHEROS
BOARD_WLAN_ATHEROS_SDK      := system/wlan/atheros/AR6kSDK.build_3.1_RC.563
BOARD_WPA_SUPPLICANT_DRIVER := AR6000
BOARD_WLAN_CHIP_AR6102	    := true
BOARD_WLAN_CHIP_AR6003	    := true
BOARD_WPA_SUPPLICANT_DRIVER := WEXT
# Select Wake on wireless mode for AR6003 suspend/resume policy
BOARD_WLAN_PM_SUSPEND       := 2

BOARD_HAVE_VPU := true
HAVE_FSL_IMX_GPU := true
HAVE_FSL_IMX_IPU := true
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

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := true
