#
# Product-specific compile-time definitions.
#

include device/fsl/imx7/soc/imx7d.mk
include device/fsl/sabresd_7d/build_id.mk
include device/fsl/imx7/BoardConfigCommon.mk
-include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
# sabresd_mx7d default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx7/imx7_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = device/fsl/sabresd_7d/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/sabresd_7d/fstab_nand.freescale:root/fstab.freescale
else
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/sabresd_7d/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/sabresd_7d/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/sabresd_7d/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/sabresd_7d/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS
endif # BUILD_TARGET_FS

TARGET_BOOTLOADER_BOARD_NAME := SABRESD
PRODUCT_MODEL := SABRESD_MX7D

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx7
# UNITE is a virtual device support both atheros and realtek wifi(ar6103 and rtl8723as)
BOARD_WLAN_DEVICE            := UNITE
WPA_SUPPLICANT_VERSION       := VER_0_8_UNITE
TARGET_KERNEL_MODULES        := \
                                kernel_imx/net/wireless/cfg80211.ko:system/lib/modules/cfg80211_realtek.ko \
                                kernel_imx/drivers/net/wireless/rtlwifi/rtl8821as/8821as.ko:system/lib/modules/8821as.ko \
                                kernel_imx/drivers/net/wireless/bcmdhd/bcmdhd.ko:system/lib/modules/bcmdhd.ko

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB_QCOM              := lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_QCOM       := lib_driver_cmd_qcwcn
BOARD_HOSTAPD_PRIVATE_LIB_RTL               := lib_driver_cmd_rtl
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_RTL        := lib_driver_cmd_rtl
BOARD_HOSTAPD_PRIVATE_LIB_BCM               := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_BCM        := lib_driver_cmd_bcmdhd
#for intel vendor
ifeq ($(BOARD_WLAN_VENDOR),INTEL)
BOARD_HOSTAPD_PRIVATE_LIB                := private_lib_driver_cmd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd
WPA_SUPPLICANT_VERSION                   := VER_0_8_X
HOSTAPD_VERSION                          := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd_intel
WIFI_DRIVER_MODULE_PATH                  := "/system/lib/modules/iwlagn.ko"
WIFI_DRIVER_MODULE_NAME                  := "iwlagn"
WIFI_DRIVER_MODULE_PATH                  ?= auto
endif

WIFI_DRIVER_FW_PATH_STA 	:= "/system/etc/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_P2P 	:= "/system/etc/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP  	:= "/system/etc/firmware/bcm/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_PARAM 	:= "/sys/module/bcmdhd/parameters/firmware_path"

BOARD_MODEM_VENDOR := AMAZON

USE_ATHR_GPS_HARDWARE := false
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
BOARD_USE_SENSOR_FUSION := true
#SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true
# atheros 3k BT
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/fsl/sabresd_7d/bluetooth

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# camera hal v2
IMX_CAMERA_HAL_V2 := false
TARGET_VSYNC_DIRECT_REFRESH := true

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale 
TARGET_BOOTLOADER_CONFIG := imx7d:mx7dsabresdandroid_config imx7d-touch:mx7dsabresdandroid_config imx7d-epdc:mx7dsabresdandroid_config
TARGET_BOARD_DTS_CONFIG := imx7d:imx7d-sdb.dtb imx7d-touch:imx7d-sdb-touch.dtb imx7d-epdc:imx7d-sdb-epdc.dtb

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx7/sepolicy \
       device/fsl/sabresd_7d/sepolicy
BOARD_SEPOLICY_UNION := \
       domain.te \
       system_app.te \
       system_server.te \
       untrusted_app.te \
       sensors.te \
       kernel.te \
       mediaserver.te \
       file_contexts \
       genfs_contexts \
       fs_use \
       rild.te \
       init.te \
       netd.te \
       bootanim.te \
       dnsmasq.te \
       recovery.te \
	   bluetooth.te \
       device.te
