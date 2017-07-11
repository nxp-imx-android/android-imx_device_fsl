#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6ul.mk
include device/fsl/evk_6ul/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include device/fsl-codec/fsl-codec.mk
endif
# evk_mx6ul default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = device/fsl/evk_6ul/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/evk_6ul/fstab_nand.freescale:root/fstab.freescale
else
PRODUCT_PROPERTY_OVERRIDES += \
                        ro.frp.pst=/dev/block/mmcblk1p12
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/evk_6ul/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/evk_6ul/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/evk_6ul/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/evk_6ul/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS
endif # BUILD_TARGET_FS

TARGET_BOOTLOADER_BOARD_NAME := EVK
PRODUCT_MODEL := EVK_MX6UL

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx6

BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB_BCM               := lib_driver_cmd_bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_BCM        := lib_driver_cmd_bcmdhd

WIFI_DRIVER_FW_PATH_STA        := "/system/etc/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_P2P        := "/system/etc/firmware/bcm/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP         := "/system/etc/firmware/bcm/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_PARAM      := "/sys/module/bcmdhd/parameters/firmware_path"

#for accelerator sensor, need to define sensor type here
#BOARD_HAS_SENSOR := true
#SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# camera hal v1
IMX_CAMERA_HAL_V1 := true
TARGET_VSYNC_DIRECT_REFRESH := true

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale 
TARGET_BOOTLOADER_CONFIG := imx6ul:mx6ul_14x14_evk_android_config
TARGET_BOARD_DTS_CONFIG := imx6ul:imx6ul-14x14-evk.dtb

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6/sepolicy \
       device/fsl/evk_6ul/sepolicy

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
       device/fsl/sabresd_6dq/seccomp/mediacodec-seccomp.policy:system/vendor/etc/seccomp_policy/mediacodec.policy \
       device/fsl/sabresd_6dq/seccomp/mediaextractor-seccomp.policy:system/vendor/etc/seccomp_policy/mediaextractor.policy

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers
