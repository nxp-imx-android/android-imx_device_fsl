#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx7ulp/evk_7ulp

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

# evk board use qcom wifi
ifeq ($(PRODUCT_7ULP_REVB), true)
BOARD_WLAN_DEVICE := qcwcn
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
# Qcom BT
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := true
ifeq ($(QCOM_BT_USE_SIBS), true)
    WCNSS_FILTER_USES_SIBS := true
endif
SOONG_CONFIG_IMXPLUGIN += BOARD_HAVE_BLUETOOTH_QCOM
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_BLUETOOTH_QCOM = true
else
# 7ulp evkb board use NXP 8987 wifi
BOARD_WLAN_DEVICE := nxp
# BCM 1DX BT
BOARD_HAVE_BLUETOOTH_BCM := true
endif

#common wifi configs
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211
BOARD_HOSTAPD_PRIVATE_LIB_QCA           := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_QCA    := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

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

BOARD_KERNEL_CMDLINE := init=/init androidboot.console=ttyLP0 consoleblank=0 androidboot.hardware=freescale vmalloc=128M cma=320M loop.max_part=7

# Set the density to 120dpi for 640x480 lcd panel
BOARD_KERNEL_CMDLINE += androidboot.lcd_density=120

# Force use gpt as 7ulp have no backup GPT only
BOARD_KERNEL_CMDLINE += gpt

ifneq ($(PRODUCT_7ULP_REVB), true)
# imx7ulp_evk with HDMI display
TARGET_BOARD_DTS_CONFIG := imx7ulp:imx7ulp-evk.dtb
# imx7ulp_evk with MIPI panel display
TARGET_BOARD_DTS_CONFIG += imx7ulp-mipi:imx7ulp-evk-mipi.dtb
else
# imx7ulp_evkb with HDMI display
TARGET_BOARD_DTS_CONFIG := imx7ulp:imx7ulp-evkb.dtb
# imx7ulp_evkb with MIPI panel display
TARGET_BOARD_DTS_CONFIG += imx7ulp-mipi:imx7ulp-evkb-rm68200-wxga.dtb
endif

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
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_USES_FULL_RECOVERY_IMAGE := true

# define board type
BOARD_TYPE := EVK

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)

