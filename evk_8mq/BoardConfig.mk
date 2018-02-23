#
# Product-specific compile-time definitions.
#

include device/fsl/imx8/soc/imx8mq.mk
include device/fsl/evk_8mq/build_id.mk
include device/fsl/imx8/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx8/imx8_target_fs.mk

ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/evk_8mq/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/evk_8mq/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/evk_8mq/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/evk_8mq/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab.bpt
ADDITION_BPT_PARTITION = partition-table-7GB:device/fsl/common/partition/device-partitions-7GB-ab.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab.bpt


# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
	device/fsl/evk_8mq/manifest.xml:vendor/manifest.xml

TARGET_BOOTLOADER_BOARD_NAME := EVK

PRODUCT_MODEL := EVK_8MQ

TARGET_BOOTLOADER_POSTFIX := bin

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

SKIP_BOOTCTRL_COPY := true

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

PRODUCT_COPY_FILES +=	\
       device/fsl/evk_8mq/ueventd.freescale.rc:root/ueventd.freescale.rc

BOARD_AVB_ENABLE := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

BOARD_KERNEL_CMDLINE += console=ttymxc0,115200 earlycon=imxuart,0x30860000,115200 init=/init video=HDMI-A-1:1920x1080-32@60 androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale cma=800M firmware_class.path=/vendor/firmware

# Qcom 1CQ(QCA6174) BT
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/fsl/evk_8mq/bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := true
ifeq ($(QCOM_BT_USE_SIBS), true)
    WCNSS_FILTER_USES_SIBS := true
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

TARGET_BOARD_DTS_CONFIG ?= imx8mq:fsl-imx8mq-evk.dtb imx8mq-mipi:fsl-imx8mq-evk-lcdif-adv7535.dtb imx8mq-dual:fsl-imx8mq-evk-dual-display.dtb imx8mq-mipi-panel:fsl-imx8mq-evk-dcss-rm67191.dtb
TARGET_BOOTLOADER_CONFIG := imx8mq:mx8mq_evk_android_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8/sepolicy \
       device/fsl/evk_8mq/sepolicy

ifeq ($(PRODUCT_IMX_DRM),true)
BOARD_SEPOLICY_DIRS += \
       device/fsl/imx8/sepolicy_drm \
       device/fsl/evk_8mq/sepolicy_drm
endif

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       device/fsl/evk_8mq/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
       device/fsl/evk_8mq/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

PRODUCT_COPY_FILES += \
       device/fsl/evk_8mq/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
