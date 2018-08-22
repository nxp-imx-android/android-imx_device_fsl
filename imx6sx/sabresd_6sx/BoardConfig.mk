#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx6sx/sabresd_6sx

include $(IMX_DEVICE_PATH)/build_id.mk
include device/fsl/imx6sx/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif
# sabresd_6sx default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6sx/imx6_target_fs.mk

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
PRODUCT_MODEL := SABRESD-MX6SX

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx6
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
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true
BOARD_USE_SENSOR_PEDOMETER := false
BOARD_USE_LEGACY_SENSOR := true

# for recovery service
TARGET_SELECT_KEY := 28

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
# uncomment below lins if use NAND
#TARGET_USERIMAGES_USE_UBIFS = true


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := $(IMX_DEVICE_PATH)/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

KERNEL_NAME := zImage
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale vmalloc=128M cma=448M galcore.contiguousSize=33554432

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif


BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# camera hal v1
IMX_CAMERA_HAL_V1 := true
TARGET_VSYNC_DIRECT_REFRESH := true

BOARD_PREBUILT_DTBOIMAGE := out/target/product/sabresd_6sx/dtbo-imx6sx.img
TARGET_BOOTLOADER_CONFIG := imx6sx:imx6sxsabresdandroid_defconfig
TARGET_BOARD_DTS_CONFIG := imx6sx:imx6sx-sdb.dtb
TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6sx/sepolicy \
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
