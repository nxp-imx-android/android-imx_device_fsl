#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX6SL
BOARD_TYPE := EVK
BOARD_HAVE_VPU := false
HAVE_FSL_IMX_GPU2D := true
HAVE_FSL_IMX_GPU3D := false
HAVE_FSL_IMX_IPU := false
HAVE_FSL_IMX_PXP := true
BOARD_KERNEL_BASE := 0x82800000
LOAD_KERNEL_ENTRY := 0x80008000
TARGET_GRALLOC_VERSION := v3
TARGET_HIGH_PERFORMANCE := false
# HWComposer version depends on this.
TARGET_USES_HWC2 := true
TARGET_HWCOMPOSER_VERSION := v2.0
TARGET_HAVE_VIV_HWCOMPOSER = true
USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := false

#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx6sl/evk_6sl

include device/fsl/imx6sl/BoardConfigCommon.mk
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

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

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
#BOARD_HAS_SENSOR := true
#SENSOR_MMA8451 := true

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
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale loop.max_part=7
TARGET_BOOTLOADER_CONFIG := imx6sl:imx6slevkandroid_defconfig
# imx6sl default dts
TARGET_BOARD_DTS_CONFIG := imx6sl:imx6sl-evk-csi.dtb
TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig
BOARD_PREBUILT_DTBOIMAGE := out/target/product/evk_6sl/dtbo-imx6sl.img

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6sl/sepolicy \
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
