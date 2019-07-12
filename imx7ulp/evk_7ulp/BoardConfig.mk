#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx7ulp/evk_7ulp

include $(IMX_DEVICE_PATH)/build_id.mk
include device/fsl/imx7ulp/BoardConfigCommon.mk
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

TARGET_BOOTLOADER_BOARD_NAME := EVK
PRODUCT_MODEL := EVK_MX7ULP

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

# BCM fmac wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko

WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/brcmfmac/parameters/alternative_fw_path"

# BCM 1DX BT
BOARD_HAVE_BLUETOOTH_BCM := true

#for sensors, need to define sensor type here
BOARD_USE_SENSOR_FUSION := true
BOARD_USE_SENSOR_PEDOMETER :=true
BOARD_USE_LEGACY_SENSOR :=false

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# camera hal v1
IMX_CAMERA_HAL_V1 := true
TARGET_VSYNC_DIRECT_REFRESH := true

KERNEL_NAME := zImage
BOARD_KERNEL_CMDLINE := init=/init androidboot.console=ttyLP0 consoleblank=0 androidboot.hardware=freescale vmalloc=128M cma=320M loop.max_part=7
# u-boot target for imx7ulp_evk
TARGET_BOOTLOADER_CONFIG := imx7ulp:imx7ulp_evk_android_defconfig
# imx7ulp with HDMI display
TARGET_BOARD_DTS_CONFIG := imx7ulp:imx7ulp-evkb.dtb
# imx7ulp with MIPI panel display
TARGET_BOARD_DTS_CONFIG += imx7ulp-mipi:imx7ulp-evkb-rm68200-wxga.dtb
TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig
BOARD_PREBUILT_DTBOIMAGE := out/target/product/evk_7ulp/dtbo-imx7ulp.img

# u-boot target used by uuu for imx7ulp_evk
TARGET_BOOTLOADER_CONFIG += imx7ulp-evk-uuu:mx7ulp_evk_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx7ulp/sepolicy \
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
BOARD_TYPE := EVK
