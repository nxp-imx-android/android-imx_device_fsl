#
# SoC-specific compile-time definitions.
#

BOARD_SOC_TYPE := IMX8MQ
BOARD_TYPE := EVK
BOARD_HAVE_VPU := true
BOARD_VPU_TYPE := hantro
HAVE_FSL_IMX_GPU2D := false
HAVE_FSL_IMX_GPU3D := true
HAVE_FSL_IMX_IPU := false
HAVE_FSL_IMX_PXP := false
BOARD_KERNEL_BASE := 0x40400000
TARGET_GRALLOC_VERSION := v3
TARGET_HIGH_PERFORMANCE := true
TARGET_USES_HWC2 := true
TARGET_HWCOMPOSER_VERSION := v2.0
TARGET_HAVE_VIV_HWCOMPOSER = false
USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true
TARGET_HAVE_VULKAN := true
ENABLE_CFI=false

# enable opencl 2d.
TARGET_OPENCL_2D := true

SOONG_CONFIG_IMXPLUGIN += TARGET_OPENCL_2D CFG_SECURE_DATA_PATH \
BOARD_HAVE_VPU \
BOARD_VPU_TYPE

SOONG_CONFIG_IMXPLUGIN_TARGET_OPENCL_2D = true
SOONG_CONFIG_IMXPLUGIN_BOARD_SOC_TYPE = IMX8MQ
SOONG_CONFIG_IMXPLUGIN_CFG_SECURE_DATA_PATH = y
SOONG_CONFIG_IMXPLUGIN_BOARD_HAVE_VPU = true
SOONG_CONFIG_IMXPLUGIN_BOARD_VPU_TYPE = hantro

#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx8m/evk_8mq

include device/fsl/imx8m/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab.bpt
ADDITION_BPT_PARTITION = partition-table-7GB:device/fsl/common/partition/device-partitions-7GB-ab.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab.bpt \
                         partition-table-dual:device/fsl/common/partition/device-partitions-13GB-ab-dual-bootloader.bpt \
                         partition-table-7GB-dual:device/fsl/common/partition/device-partitions-7GB-ab-dual-bootloader.bpt \
                         partition-table-28GB-dual:device/fsl/common/partition/device-partitions-28GB-ab-dual-bootloader.bpt


# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := EVK

TARGET_BOOTLOADER_POSTFIX := bin

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211
BOARD_HOSTAPD_PRIVATE_LIB           := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB    := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/brcmfmac/parameters/alternative_fw_path"

#WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# BCM fmac wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

# BCM 1CX BT
BOARD_HAVE_BLUETOOTH_BCM := true

BOARD_USE_SENSOR_FUSION := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

UBOOT_POST_PROCESS := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

# whether to accelerate camera service with openCL
# it will make camera service load the opencl lib in vendor
# and break the full treble rule
#OPENCL_2D_IN_CAMERA := true

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

BOARD_AVB_ENABLE := true
TARGET_USES_MKE2FS := true
BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := device/fsl/common/security/testkey_rsa4096.pem

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

ifeq ($(PRODUCT_IMX_DRM),true)
CMASIZE=736M
else
CMASIZE=1280M
endif

KERNEL_NAME := Image
BOARD_KERNEL_CMDLINE := init=/init androidboot.gui_resolution=1080p androidboot.console=ttymxc0 androidboot.hardware=freescale androidboot.fbTileSupport=enable cma=$(CMASIZE) androidboot.primary_display=imx-drm firmware_class.path=/vendor/firmware transparent_hugepage=never loop.max_part=7

# Set the density to 213 tvdpi to match CDD.
BOARD_KERNEL_CMDLINE += androidboot.lcd_density=213

# Default wificountrycode
BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=CN

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_PREBUILT_DTBOIMAGE := out/target/product/evk_8mq/dtbo-imx8mq.img
# imx8mq with HDMI display
TARGET_BOARD_DTS_CONFIG ?= imx8mq:fsl-imx8mq-trusty-evk.dtb
# imx8mq with MIPI-HDMI display
TARGET_BOARD_DTS_CONFIG += imx8mq-mipi:fsl-imx8mq-evk-lcdif-adv7535.dtb
# imx8mq with HDMI and MIPI-HDMI display
TARGET_BOARD_DTS_CONFIG += imx8mq-dual:fsl-imx8mq-evk-dual-display.dtb
# imx8mq with MIPI panel display
TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-panel:fsl-imx8mq-evk-dcss-rm67191.dtb
# imx8mq rev. B3 board with HDMI display
TARGET_BOARD_DTS_CONFIG += imx8mq-b3:fsl-imx8mq-evk-b3.dtb
# imx8mq rev. B3 board with mipi-hdmi display
TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-b3:fsl-imx8mq-evk-lcdif-adv7535-b3.dtb
# imx8mq rev. B3 board with MIPI panel display
TARGET_BOARD_DTS_CONFIG += imx8mq-mipi-panel-b3:fsl-imx8mq-evk-dcss-rm67191-b3.dtb
# u-boot target for imx8mq_evk
TARGET_BOOTLOADER_CONFIG := imx8mq:imx8mq_evk_android_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mq-dual:imx8mq_evk_android_dual_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mq-trusty:imx8mq_evk_android_trusty_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mq-trusty-secure-unlock:imx8mq_evk_android_trusty_secure_unlock_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mq-trusty-dual:imx8mq_evk_android_trusty_dual_defconfig

TARGET_KERNEL_DEFCONFIG := android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF ?= android_addition_defconfig

# u-boot target used by uuu for imx8mq_evk
TARGET_BOOTLOADER_CONFIG += imx8mq-evk-uuu:imx8mq_evk_android_uuu_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8m/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_DRM),true)
BOARD_SEPOLICY_DIRS += \
       $(IMX_DEVICE_PATH)/sepolicy_drm
endif

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
