#
# Product-specific compile-time definitions.
#

include device/fsl/imx7/soc/imx7d.mk
include device/fsl/sabresd_7d/build_id.mk
include device/fsl/imx7/BoardConfigCommon.mk
include external/linux-firmware-imx/firmware/epdc/fsl-epdc.mk
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

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
    device/fsl/sabresd_7d/manifest.xml:system/vendor/manifest.xml

TARGET_BOOTLOADER_BOARD_NAME := SABRESD
PRODUCT_MODEL := SABRESD_MX7D

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx7
# UNITE is a virtual device.
BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB_BCM               := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_BCM        := lib_driver_cmd_bcmdhd

WIFI_DRIVER_FW_PATH_STA 	:= "/system/etc/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_P2P 	:= "/system/etc/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP  	:= "/system/etc/firmware/bcm/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_PARAM 	:= "/sys/module/bcmdhd/parameters/firmware_path"

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

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# camera hal v1
IMX_CAMERA_HAL_V1 := true
TARGET_VSYNC_DIRECT_REFRESH := true

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale 
TARGET_BOOTLOADER_CONFIG := imx7d:mx7dsabresdandroid_config imx7d-epdc:mx7dsabresdandroid_config
TARGET_BOARD_DTS_CONFIG := imx7d:imx7d-sdb.dtb imx7d-epdc:imx7d-sdb-epdc.dtb

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx7/sepolicy \
       device/fsl/sabresd_7d/sepolicy \
       device/fsl/common/sepolicy

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions.bpt

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       device/fsl/sabresd_6dq/seccomp/mediacodec-seccomp.policy:system/vendor/etc/seccomp_policy/mediacodec.policy \
       device/fsl/sabresd_6dq/seccomp/mediaextractor-seccomp.policy:system/vendor/etc/seccomp_policy/mediaextractor.policy

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
