#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/arm2_6dq/build_id.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
include device/fsl/imx6/BoardConfigCommon.mk

# arm2_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

TARGET_BOOTLOADER_BOARD_NAME := ARM2

BOARD_SOC_CLASS := IMX6
PRODUCT_MODEL := ARM2-MX6DQ

# Wifi
BOARD_WLAN_VENDOR 			 := ATHEROS
# for atheros vendor
ifeq ($(BOARD_WLAN_VENDOR),ATHEROS)
BOARD_WLAN_DEVICE := ar6003
BOARD_HAS_ATH_WLAN := true
BOARD_WLAN_ATHEROS_SDK := system/wlan/atheros/compat-wireless
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_0_9_ATHEROS
HOSTAPD_VERSION := VER_0_9_ATHEROS
WIFI_DRIVER_MODULE_PATH         := "/system/lib/modules/ath6kl_sdio.ko"
WIFI_DRIVER_MODULE_NAME         := "ath6kl_sdio"
WIFI_DRIVER_MODULE_ARG          := "suspend_mode=3"
WIFI_DRIVER_P2P_MODULE_ARG      := "suspend_mode=3 ath6kl_p2p=1 debug_mask=0x2413"
WIFI_SDIO_IF_DRIVER_MODULE_PATH := "/system/lib/modules/cfg80211.ko"
WIFI_SDIO_IF_DRIVER_MODULE_NAME := "cfg80211"
WIFI_SDIO_IF_DRIVER_MODULE_ARG  := ""
WIFI_COMPAT_MODULE_PATH  := "/system/lib/modules/compat.ko"
WIFI_COMPAT_MODULE_NAME  := "compat"
WIFI_COMPAT_MODULE_ARG   := ""
WIFI_TEST_INTERFACE      := "sta"
endif

BOARD_HAVE_VPU := true
BOARD_MODEM_VENDOR := AMAZON

BOARD_HAVE_HARDWARE_GPS := true
USE_ATHR_GPS_HARDWARE := true
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
#BOARD_HAS_SENSOR := true
#SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := false

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 androidboot.hardware=freescale
TARGET_BOOTLOADER_CONFIG := 6q:mx6q_arm2_android_config 6dl:mx6dl_arm2_config
