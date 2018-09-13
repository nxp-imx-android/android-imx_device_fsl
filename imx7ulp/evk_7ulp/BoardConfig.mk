#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx7ulp/evk_7ulp

include $(IMX_DEVICE_PATH)/build_id.mk
include device/fsl/imx7ulp/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

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

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx7

BOARD_WLAN_DEVICE            := qcwcn
WPA_SUPPLICANT_VERSION       := VER_0_8_X

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/qcacld-2.0/wlan.ko

#for sensors, need to define sensor type here
BOARD_USE_SENSOR_FUSION := true
BOARD_USE_SENSOR_PEDOMETER :=true
BOARD_USE_LEGACY_SENSOR :=false

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

# Qcom 1PJ(QCA9377) BT
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := true
ifeq ($(QCOM_BT_USE_SIBS), true)
    WCNSS_FILTER_USES_SIBS := true
endif

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# camera hal v1
IMX_CAMERA_HAL_V1 := true
TARGET_VSYNC_DIRECT_REFRESH := true

KERNEL_NAME := zImage
BOARD_KERNEL_CMDLINE := init=/init androidboot.console=ttyLP0 consoleblank=0 androidboot.hardware=freescale vmalloc=128M cma=448M
TARGET_BOOTLOADER_CONFIG := imx7ulp:imx7ulp_evk_android_defconfig
TARGET_BOARD_DTS_CONFIG := imx7ulp:imx7ulp-evk.dtb imx7ulp-mipi:imx7ulp-evk-mipi.dtb
TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig
BOARD_PREBUILT_DTBOIMAGE := out/target/product/evk_7ulp/dtbo-imx7ulp.img

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

