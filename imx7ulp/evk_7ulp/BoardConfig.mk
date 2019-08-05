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

BOARD_WLAN_DEVICE_UNITE      := UNITE
WPA_SUPPLICANT_VERSION       := VER_0_8_X

BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

# In UNITE mode,Use default macro for bcmdhd and use unite macro for qcom
ifeq ($(BOARD_WLAN_DEVICE_UNITE), UNITE)
BOARD_WLAN_DEVICE            := bcmdhd
BOARD_HOSTAPD_PRIVATE_LIB_QCA           := lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_QCA    := lib_driver_cmd_qcwcn
BOARD_HOSTAPD_PRIVATE_LIB_BCM           := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_BCM    := lib_driver_cmd_bcmdhd
endif

# BCM fmac wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko

WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/brcmfmac/parameters/alternative_fw_path"

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

# BCM 1DX BT
BOARD_HAVE_BLUETOOTH_BCM := true

# QCA qcacld wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/qcacld-2.0/wlan.ko

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# Qcom BT
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := true
ifeq ($(QCOM_BT_USE_SIBS), true)
    WCNSS_FILTER_USES_SIBS := true
endif

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

#evk_7ulp evkb use BCM 1DX BCM43430 wifi module, if use evk board which used QCOM qca9377 module, please set androidboot.wifivendor=qca
BOARD_KERNEL_CMDLINE += androidboot.wifivendor=bcm

# u-boot target for imx7ulp_evk
TARGET_BOOTLOADER_CONFIG := imx7ulp:imx7ulp_evk_android_defconfig
# imx7ulp with HDMI display
TARGET_BOARD_DTS_CONFIG := imx7ulp:imx7ulp-evkb.dtb imx7ulp-evk:imx7ulp-evk.dtb
# imx7ulp with MIPI panel display
TARGET_BOARD_DTS_CONFIG += imx7ulp-mipi:imx7ulp-evkb-rm68200-wxga.dtb imx7ulp-evk-mipi:imx7ulp-evk-mipi.dtb
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
