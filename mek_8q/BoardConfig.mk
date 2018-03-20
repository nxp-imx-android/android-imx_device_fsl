#
# Product-specific compile-time definitions.
#

include device/fsl/imx8/soc/imx8q.mk
ifeq ($(PRODUCT_IMX_CAR),true)
include device/fsl/mek_8q/build_id_car.mk
else
include device/fsl/mek_8q/build_id.mk
endif # PRODUCT_IMX_CAR
include device/fsl/imx8/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_hifi4_aacp_dec/imx_hifi4_aacp_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_hifi4_codec/imx_hifi4_codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_hifi4/imx_hifi4.mk
endif
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx8/imx8_target_fs.mk

ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/mek_8q/fstab.freescale
# build for ext4
ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_RECOVERY_FSTAB = device/fsl/mek_8q/fstab.freescale.car
PRODUCT_COPY_FILES +=	\
	device/fsl/mek_8q/fstab.freescale.car:root/fstab.freescale
else
PRODUCT_COPY_FILES +=	\
	device/fsl/mek_8q/fstab.freescale:root/fstab.freescale
endif # PRODUCT_IMX_CAR
else
TARGET_RECOVERY_FSTAB = device/fsl/mek_8q/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/mek_8q/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab.bpt
ADDITION_BPT_PARTITION = partition-table-7GB:device/fsl/common/partition/device-partitions-7GB-ab.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab.bpt


# Vendor Interface Manifest
ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    device/fsl/mek_8q/manifest_car.xml:vendor/manifest.xml
else
DEVICE_MANIFEST_FILE := device/fsl/mek_8q/manifest.xml
DEVICE_MATRIX_FILE := device/fsl/mek_8q/compatibility_matrix.xml
endif

TARGET_BOOTLOADER_BOARD_NAME := MEK

PRODUCT_MODEL := MEK-MX8Q

TARGET_BOOTLOADER_POSTFIX := bin

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx8

BOARD_WLAN_DEVICE            := qcwcn
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)


BOARD_VENDOR_KERNEL_MODULES += \
                            $(KERNEL_OUT)/drivers/net/wireless/ath/ath.ko \
                            $(KERNEL_OUT)/drivers/net/wireless/ath/ath10k/ath10k_core.ko \
                            $(KERNEL_OUT)/drivers/net/wireless/ath/ath10k/ath10k_pci.ko

# Qcom 1CQ(QCA6174) BT
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/fsl/mek_8q/bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := true
ifeq ($(QCOM_BT_USE_SIBS), true)
    WCNSS_FILTER_USES_SIBS := true
endif

BOARD_USE_SENSOR_FUSION := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

UBOOT_POST_PROCESS := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

BOARD_KERNEL_CMDLINE := console=ttyLP0,115200 earlycon=lpuart32,0x5a060000,115200,115200 init=/init androidboot.console=ttyLP0 consoleblank=0 androidboot.hardware=freescale cma=800M firmware_class.path=/vendor/firmware


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

TARGET_BOARD_DTS_CONFIG := imx8qm:fsl-imx8qm-mek.dtb imx8qm-hdmi:fsl-imx8qm-mek-hdmi.dtb imx8qxp:fsl-imx8qxp-mek.dtb
TARGET_BOOTLOADER_CONFIG := imx8qm:mx8qm_mek_android_defconfig imx8qxp:mx8qxp_mek_android_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8/sepolicy \
       device/fsl/mek_8q/sepolicy

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_SEPOLICY_DIRS += \
     packages/services/Car/car_product/sepolicy \
     device/generic/car/common/sepolicy
endif

PRODUCT_COPY_FILES +=	\
       device/fsl/mek_8q/ueventd.freescale.rc:root/ueventd.freescale.rc

BOARD_AVB_ENABLE := true

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       device/fsl/mek_8q/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy \
       device/fsl/mek_8q/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy

PRODUCT_COPY_FILES += \
       device/fsl/mek_8q/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
