#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx7d/sabresd_7d

include device/fsl/imx7d/BoardConfigCommon.mk
include $(LINUX_FIRMWARE_IMX_PATH)/linux-firmware-imx/firmware/epdc/fsl-epdc.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

TARGET_USES_64_BIT_BINDER := true

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale

# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := SABRESD

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

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
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale cma=320M loop.max_part=7
# u-boot target for imx7d_sabresd with HDMI or LCD display
TARGET_BOOTLOADER_CONFIG := imx7d:imx7dsabresdandroid_defconfig
# u-boot target for imx7d_sabresd with epdc display
TARGET_BOOTLOADER_CONFIG += imx7d-epdc:imx7dsabresdandroid_defconfig
# imx7d with HDMI or LCD display
TARGET_BOARD_DTS_CONFIG := imx7d:imx7d-sdb.dtb
# imx7d with epdc display
TARGET_BOARD_DTS_CONFIG += imx7d-epdc:imx7d-sdb-epdc.dtb
TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig
BOARD_PREBUILT_DTBOIMAGE := out/target/product/sabresd_7d/dtbo-imx7d.img

# u-boot target used by uuu for imx7d_sabresd with HDMI or LCD display
TARGET_BOOTLOADER_CONFIG += imx7d-sabresd-uuu:mx7dsabresd_defconfig
# u-boot target used by uuu for imx7d_sabresd with epdc display
TARGET_BOOTLOADER_CONFIG += imx7d-epdc-sabresd-uuu:mx7dsabresd_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx7d/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-7GB.bpt
ADDITION_BPT_PARTITION = partition-table-14GB:device/fsl/common/partition/device-partitions-14GB.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB.bpt

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers

#Enable AVB
BOARD_AVB_ENABLE := true
TARGET_USES_MKE2FS := true
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_USES_FULL_RECOVERY_IMAGE := true

# define board type
BOARD_TYPE := SABRESD
