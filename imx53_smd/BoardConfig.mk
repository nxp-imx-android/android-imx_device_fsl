#
# Product-specific compile-time definitions.
#

include device/fsl/imx5x/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := SMD

BOARD_SOC_CLASS := IMX5X
BOARD_SOC_TYPE := IMX53
PRODUCT_MODEL := IMX53-SMD

# Wifi
BOARD_WLAN_VENDOR			:= ATHEROS
# for atheros vendor
ifeq ($(BOARD_WLAN_VENDOR),ATHEROS)
BOARD_WLAN_DEVICE			:= ar6003
BOARD_HAS_ATH_WLAN 			:= true
WPA_SUPPLICANT_VERSION			:= VER_0_8_ATHEROS
WIFI_DRIVER_MODULE_PATH          	:= "/system/lib/modules/ath6kl_sdio.ko"
WIFI_DRIVER_MODULE_NAME          	:= "ath6kl_sdio"
WIFI_DRIVER_MODULE_ARG           	:= "suspend_mode=2 ar6k_clock=26000000 ath6kl_p2p=1"
WIFI_DRIVER_P2P_MODULE_ARG       	:= "suspend_mode=2 ar6k_clock=26000000 ath6kl_p2p=1 debug_mask=0x2413"
WIFI_SDIO_IF_DRIVER_MODULE_PATH  	:= "/system/lib/modules/cfg80211.ko"
WIFI_SDIO_IF_DRIVER_MODULE_NAME  	:= "cfg80211"
WIFI_SDIO_IF_DRIVER_MODULE_ARG   	:= ""
WIFI_COMPAT_MODULE_PATH			:= "/system/lib/modules/compat.ko"
WIFI_COMPAT_MODULE_NAME			:= "compat"
WIFI_COMPAT_MODULE_ARG			:= ""
endif
#for intel vendor
ifeq ($(BOARD_WLAN_VENDOR),INTEL)
BOARD_HOSTAPD_PRIVATE_LIB		?= private_lib_driver_cmd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB 	?= private_lib_driver_cmd
WPA_SUPPLICANT_VERSION			:= VER_0_7_X_INTEL
HOSTAPD_VERSION				:= VER_0_7_X_INTEL
WIFI_DRIVER_MODULE_PATH          	:= "/system/lib/modules/iwlagn.ko"
WIFI_DRIVER_MODULE_NAME          	:= "iwlagn"
WIFI_DRIVER_MODULE_PATH			?= auto
endif
BOARD_WPA_SUPPLICANT_DRIVER      	:= NL80211
BOARD_HOSTAPD_DRIVER             	:= NL80211
WIFI_TEST_INTERFACE			:= "sta"
WIFI_DRIVER_FW_PATH_STA			:= "sta"
WIFI_DRIVER_FW_PATH_AP			:= "ap"
WIFI_DRIVER_FW_PATH_P2P			:= "p2p"

BOARD_HAVE_VPU := true
HAVE_FSL_IMX_GPU2D := true
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_IPU := true
BOARD_MODEM_VENDOR := AMAZON

BOARD_HAVE_HARDWARE_GPS := true
USE_ATHR_GPS_HARDWARE := true
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28
TARGET_USERIMAGES_USE_EXT4 := true

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_QCOM_ATH3K := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/fsl/imx53_smd/bluetooth

USE_OPENGL_RENDERER := true
BOARD_EGL_CFG := device/fsl-proprietary/gpu/egl/egl.cfg

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 androidboot.hardware=freescale video=mxcfb0:dev=ldb,LDB-XGA,if=RGB666,bpp=32 video=mxcfb1:dev=sii902x_hdmi,1280x720M@60,bpp=32 ion=128M,64M fbmem=10M gpu_memory=128M vmalloc=576M

BOARD_KERNEL_BASE := 0x70800000

TARGET_BOOTLOADER_CONFIG := mx53_smd_android_config

TARGET_RECOVERY_UI_LIB := librecovery_ui_imx53_smd

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
