#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx7d/sabresd_7d

include $(IMX_DEVICE_PATH)/build_id.mk
include device/fsl/imx7d/BoardConfigCommon.mk
include $(LINUX_FIRMWARE_IMX_PATH)/linux-firmware-imx/firmware/epdc/fsl-epdc.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif
# sabresd_mx7d default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx7d/imx7_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	$(IMX_DEVICE_PATH)/fstab_nand.freescale:root/fstab.freescale
else
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	$(IMX_DEVICE_PATH)/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	$(IMX_DEVICE_PATH)/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS
endif # BUILD_TARGET_FS

# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := SABRESD
PRODUCT_MODEL := SABRESD_MX7D

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx7d
# UNITE is a virtual device.
BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_bcmdhd

WIFI_DRIVER_FW_PATH_PARAM      := "/sys/module/brcmfmac/parameters/alternative_fw_path"

BOARD_VENDOR_KERNEL_MODULES += \
                            $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko \
                            $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko

#for accelerator sensor, need to define sensor type here
BOARD_USE_SENSOR_FUSION := true
#SENSOR_MMA8451 := true
BOARD_USE_SENSOR_PEDOMETER := false
BOARD_USE_LEGACY_SENSOR := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
# atheros 3k BT
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# camera hal v1
IMX_CAMERA_HAL_V1 := true
TARGET_VSYNC_DIRECT_REFRESH := true

KERNEL_NAME := zImage
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale cma=320M
TARGET_BOOTLOADER_CONFIG := imx7d:imx7dsabresdandroid_defconfig imx7d-epdc:imx7dsabresdandroid_defconfig
TARGET_BOARD_DTS_CONFIG := imx7d:imx7d-sdb.dtb imx7d-epdc:imx7d-sdb-epdc.dtb
TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig
BOARD_PREBUILT_DTBOIMAGE := out/target/product/sabresd_7d/dtbo-imx7d.img

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx7d/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-7GB.bpt
ADDITION_BPT_PARTITION = partition-table-14GB:device/fsl/common/partition/device-partitions-14GB.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB.bpt

PRODUCT_COPY_FILES +=	\
       $(IMX_DEVICE_PATH)/ueventd.freescale.rc:root/ueventd.freescale.rc

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       $(IMX_DEVICE_PATH)/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
       $(IMX_DEVICE_PATH)/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

PRODUCT_COPY_FILES += \
       $(IMX_DEVICE_PATH)/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers

#Enable AVB
BOARD_AVB_ENABLE := true
TARGET_USES_MKE2FS := true

PRODUCT_COPY_FILES += \
	device/fsl/common/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf \
	device/fsl/common/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf
