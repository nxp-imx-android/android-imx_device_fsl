#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx6dq/sabresd_6dq

ifeq ($(PRODUCT_IMX_CAR),true)
include $(IMX_DEVICE_PATH)/build_id_car.mk
else
include $(IMX_DEVICE_PATH)/build_id.mk
endif # PRODUCT_IMX_CAR
include device/fsl/imx6dq/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
endif

TARGET_USES_64_BIT_BINDER := true

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale.car
else
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale
endif # PRODUCT_IMX_CAR

# Vendor Interface Manifest
ifeq ($(PRODUCT_IMX_CAR),true)
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest_car.xml
else
# Vendor Interface manifest and compatibility
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml
endif

TARGET_BOOTLOADER_BOARD_NAME := SABRESD
PRODUCT_MODEL := SABRESD-MX6DQ

TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

# UNITE is a virtual device.
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
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true
BOARD_USE_SENSOR_PEDOMETER := false
BOARD_USE_LEGACY_SENSOR := true

# for recovery service
TARGET_SELECT_KEY := 28

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
# uncomment below lins if use NAND
#TARGET_USERIMAGES_USE_UBIFS = true


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
UBI_ROOT_INI := $(IMX_DEVICE_PATH)/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

KERNEL_NAME := zImage
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init video=mxcfb0:dev=ldb,fbpix=RGB32,bpp=32 video=mxcfb1:off video=mxcfb2:off video=mxcfb3:off vmalloc=128M androidboot.console=ttymxc0 consoleblank=0 androidboot.hardware=freescale cma=320M galcore.contiguousSize=33554432 loop.max_part=7

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif


# Broadcom BCM4339 BT
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# camera hal v3
IMX_CAMERA_HAL_V3 := true


#define consumer IR HAL support
IMX6_CONSUMER_IR_HAL := false

BOARD_PREBUILT_DTBOIMAGE := out/target/product/sabresd_6dq/dtbo-imx6q.img

# u-boot target for imx6q_sabresd 800MHz/10000MHz board
TARGET_BOOTLOADER_CONFIG := imx6q:imx6qsabresdandroid_defconfig
# u-boot target for imx6dl_sabresd board
TARGET_BOOTLOADER_CONFIG += imx6dl:imx6dlsabresdandroid_defconfig
# u-boot target for imx6q_sabresd 1.2GHz board
TARGET_BOOTLOADER_CONFIG += imx6q-ldo:imx6qsabresdandroid_defconfig
# u-boot target for imx6qp_sabresd 800MHz/10000MHz board
TARGET_BOOTLOADER_CONFIG += imx6qp:imx6qpsabresdandroid_defconfig
# u-boot target for imx6qp_sabresd 1.2GHz board
TARGET_BOOTLOADER_CONFIG += imx6qp-ldo:imx6qpsabresdandroid_defconfig

# imx6q default dts
TARGET_BOARD_DTS_CONFIG := imx6q:imx6q-sabresd.dtb
# imx6dl default dts
TARGET_BOARD_DTS_CONFIG += imx6dl:imx6dl-sabresd.dtb
# imx6q 1.2GHz board
TARGET_BOARD_DTS_CONFIG += imx6q-ldo:imx6q-sabresd-ldo.dtb
# imx6qp default dts
TARGET_BOARD_DTS_CONFIG += imx6qp:imx6qp-sabresd.dtb
# imx6qp 1.2GHz board
TARGET_BOARD_DTS_CONFIG += imx6qp-ldo:imx6qp-sabresd-ldo.dtb
TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig

# u-boot target used by uuu for imx6q_sabresd 800MHz/10000MHz board
TARGET_BOOTLOADER_CONFIG += imx6q-sabresd-uuu:mx6qsabresd_defconfig
# u-boot target used by uuu for imx6dl_sabresd board
TARGET_BOOTLOADER_CONFIG += imx6dl-sabresd-uuu:mx6dlsabresd_defconfig
# u-boot target used by uuu for imx6q_sabresd 1.2GHz board
TARGET_BOOTLOADER_CONFIG += imx6q-ldo-sabresd-uuu:mx6qsabresd_defconfig
# u-boot target used by uuu for imx6qp_sabresd 800MHz/10000MHz board
TARGET_BOOTLOADER_CONFIG += imx6qp-sabresd-uuu:mx6qpsabresd_defconfig
# u-boot target used by uuu for imx6qp_sabresd 1.2GHz board
TARGET_BOOTLOADER_CONFIG += imx6qp-ldo-sabresd-uuu:mx6qpsabresd_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx6dq/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_SEPOLICY_DIRS += \
     packages/services/Car/car_product/sepolicy \
     device/generic/car/common/sepolicy
endif

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
