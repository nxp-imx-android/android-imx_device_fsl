#
# Product-specific compile-time definitions.
#

include device/fsl/imx8/soc/imx8dq.mk
include device/fsl/sabreauto_8dq/build_id.mk
include device/fsl/imx8/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx8/imx8_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_8dq/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_8dq/fstab_nand.freescale:root/fstab.freescale
else
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_8dq/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_8dq/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_8dq/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_8dq/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions.bpt

endif # BUILD_TARGET_FS

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
    device/fsl/sabreauto_8dq/manifest.xml:vendor/manifest.xml

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

PRODUCT_MODEL := SABREAUTO-MX8DQ

TARGET_BOOTLOADER_POSTFIX := bin
TARGET_DTB_POSTFIX := -dtb

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx8

BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

PHONE_MODULE_INCLUDE := flase
BOARD_USE_SENSOR_FUSION := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true

UBOOT_POST_PROCESS := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

BOARD_KERNEL_CMDLINE := console=ttymxc2,115200 init=/init video=imxdpufb1:off video=imxdpufb2:off video=imxdpufb3:off video=imxdpufb4:off androidboot.console=ttymxc2 consoleblank=0 androidboot.hardware=freescale cma=800M androidboot.watchdogd=disabled androidboot.serialno=150831d4e1fdfca7

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
UBI_ROOT_INI := device/fsl/sabreauto_6q/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 8192 -e 1032192 -c 4096 -x none -F
TARGET_UBIRAW_ARGS := -m 8192 -p 1024KiB $(UBI_ROOT_INI)

# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:64m(bootloader),16m(bootimg),16m(recovery),-(root) ubi.mtd=4
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

TARGET_BOARD_DTS_CONFIG := imx8dv:fsl-imx8dv-sabreauto.dtb
TARGET_BOOTLOADER_CONFIG := imx8dv:imx8dv_sabreauto_android_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8/sepolicy \
       device/fsl/sabreauto_8dq/sepolicy \
       device/fsl/common/sepolicy

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       device/fsl/sabresd_6dq/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
       device/fsl/sabresd_6dq/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
