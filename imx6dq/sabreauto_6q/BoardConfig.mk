#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx6dq/sabreauto_6q

include $(IMX_DEVICE_PATH)/build_id.mk
include device/fsl/imx6dq/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

TARGET_USES_64_BIT_BINDER := true

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-7GB.bpt
ADDITION_BPT_PARTITION = partition-table-14GB:device/fsl/common/partition/device-partitions-14GB.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB.bpt

# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

PRODUCT_MODEL := SABREAUTO-MX6Q

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

BOARD_WLAN_DEVICE            := bcmdhd
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true
BOARD_USE_SENSOR_PEDOMETER := false
BOARD_USE_LEGACY_SENSOR := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

KERNEL_NAME := zImage
BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 init=/init video=mxcfb0:dev=ldb,fbpix=RGB32,bpp=32 video=mxcfb1:off video=mxcfb2:off video=mxcfb3:off vmalloc=128M androidboot.console=ttymxc3 consoleblank=0 androidboot.hardware=freescale cma=512M galcore.contiguousSize=67108864 loop.max_part=7

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
UBI_ROOT_INI := $(IMX_DEVICE_PATH)/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 8192 -e 1032192 -c 4096 -x none -F
TARGET_UBIRAW_ARGS := -m 8192 -p 1024KiB $(UBI_ROOT_INI)

# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:64m(bootloader),16m(bootimg),16m(recovery),1m(misc),-(root) ubi.mtd=5
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_PREBUILT_DTBOIMAGE := out/target/product/sabreauto_6q/dtbo-imx6q.img
ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
# imx6q with nand flash boot
TARGET_BOARD_DTS_CONFIG := imx6q-nand:imx6q-sabreauto-gpmi-weim.dtb
# imx6dl with nand flash boot
TARGET_BOARD_DTS_CONFIG += imx6dl-nand:imx6dl-sabreauto-gpmi-weim.dtb
# imx6qp with nand flash boot
TARGET_BOARD_DTS_CONFIG += imx6qp-nand:imx6qp-sabreauto-gpmi-weim.dtb

# u-boot target for imx6q_sabreauto with nand flash boot
TARGET_BOOTLOADER_CONFIG := imx6q-nand:mx6qsabreautoandroid_nand_config
# u-boot target for imx6dl_sabreauto with nand flash boot
TARGET_BOOTLOADER_CONFIG += imx6dl-nand:mx6dlsabreautoandroid_nand_config
# u-boot target for imx6qp_sabreauto with nad flash boot
TARGET_BOOTLOADER_CONFIG += imx6qp-nand:mx6qpsabreautoandroid_nand_config
else 
# imx6q with sd card boot
TARGET_BOARD_DTS_CONFIG := imx6q:imx6q-sabreauto.dtb
# imx6dl with sd card boot
TARGET_BOARD_DTS_CONFIG += imx6dl:imx6dl-sabreauto.dtb
# imx6qp with sd card boot
TARGET_BOARD_DTS_CONFIG += imx6qp:imx6qp-sabreauto.dtb

# u-boot target for imx6q_sabreauto with sd card flash boot
TARGET_BOOTLOADER_CONFIG := imx6q:imx6qsabreautoandroid_defconfig
# u-boot target for imx6dl_sabreauto with sd card flash boot
TARGET_BOOTLOADER_CONFIG += imx6dl:imx6dlsabreautoandroid_defconfig
# u-boot target for imx6qp_sabreauto with sd card flash boot
TARGET_BOOTLOADER_CONFIG += imx6qp:imx6qpsabreautoandroid_defconfig

# u-boot target used by uuu for imx6q_sabreauto with sd card flash boot
TARGET_BOOTLOADER_CONFIG += imx6q-sabreauto-uuu:mx6qsabreauto_defconfig
# u-boot target used by uuu for imx6dl_sabreauto with sd card flash boot
TARGET_BOOTLOADER_CONFIG += imx6dl-sabreauto-uuu:mx6dlsabreauto_defconfig
# u-boot target used by uuu for imx6qp_sabreauto with sd card flash boot
TARGET_BOOTLOADER_CONFIG += imx6qp-sabreauto-uuu:mx6qpsabreauto_defconfig
endif

TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6dq/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers

#Enable AVB
BOARD_AVB_ENABLE := true
TARGET_USES_MKE2FS := true
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_USES_FULL_RECOVERY_IMAGE := true
