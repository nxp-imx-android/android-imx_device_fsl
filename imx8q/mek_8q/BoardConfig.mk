#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx8q/mek_8q

ifeq ($(PRODUCT_IMX_CAR),true)
  AB_OTA_PARTITIONS += bootloader
  BOARD_OTA_BOOTLOADERIMAGE := out/target/product/mek_8q/obj/UBOOT_COLLECTION/bootloader-imx8qm.img
  ifeq ($(OTA_TARGET),8qxp)
    BOARD_OTA_BOOTLOADERIMAGE := out/target/product/mek_8q/obj/UBOOT_COLLECTION/bootloader-imx8qxp.img
  endif
endif

include device/fsl/imx8q/BoardConfigCommon.mk

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale.car
else
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale
endif # PRODUCT_IMX_CAR

# Support gpt
ifeq ($(PRODUCT_IMX_CAR),true)
  ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
    BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab-dual-bootloader_super.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab-dual-bootloader_super.bpt
  else
    ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
      BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab-dual-bootloader-no-product.bpt
      ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab-dual-bootloader-no-product.bpt
    else
      BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab-dual-bootloader.bpt
      ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab-dual-bootloader.bpt
    endif
  endif
else
  ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
    BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab_super.bpt
    ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab_super.bpt
  else
    ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
      BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab-no-product.bpt
      ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab-no-product.bpt
    else
      BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab.bpt
      ADDITION_BPT_PARTITION = partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab.bpt
    endif
  endif
endif


# Vendor Interface Manifest
ifeq ($(PRODUCT_IMX_CAR),true)
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest_car.xml
else
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
endif

# Vendor compatibility matrix
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml

TARGET_BOOTLOADER_BOARD_NAME := MEK

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

BOARD_WLAN_DEVICE            := nxp
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth

# NXP 8997 BLUETOOTH
BOARD_HAVE_BLUETOOTH_NXP := true

# sensor configs
BOARD_USE_SENSOR_FUSION := true
BOARD_USE_SENSOR_PEDOMETER := false
ifeq ($(PRODUCT_IMX_CAR),true)
    BOARD_USE_LEGACY_SENSOR := false
else
    BOARD_USE_LEGACY_SENSOR :=true
endif

# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

BOARD_HAVE_USB_CAMERA := true
BOARD_HAVE_USB_MJPEG_CAMERA := false

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

# NXP default config
BOARD_KERNEL_CMDLINE := init=/init androidboot.hardware=freescale firmware_class.path=/vendor/firmware loop.max_part=7

# framebuffer config
BOARD_KERNEL_CMDLINE += androidboot.fbTileSupport=enable

# memory config
BOARD_KERNEL_CMDLINE += cma=1184M@0x960M-0xe00M transparent_hugepage=never

# display config
BOARD_KERNEL_CMDLINE += androidboot.lcd_density=240 androidboot.primary_display=imx-drm

# wifi config
BOARD_KERNEL_CMDLINE += androidboot.wificountrycode=CN

ifeq ($(PRODUCT_IMX_CAR),true)
# automotive config
BOARD_KERNEL_CMDLINE += galcore.contiguousSize=33554432 video=HDMI-A-2:d
else
BOARD_KERNEL_CMDLINE += androidboot.console=ttyLP0
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_PREBUILT_DTBOIMAGE := out/target/product/mek_8q/dtbo-imx8qm.img
ifeq ($(OTA_TARGET),8qxp)
BOARD_PREBUILT_DTBOIMAGE := out/target/product/mek_8q/dtbo-imx8qxp.img
endif

ifeq ($(PRODUCT_IMX_CAR),true)
  ifeq ($(PRODUCT_IMX_CAR_M4),true)
    ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
      TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-car-no-product.dtb
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-car-no-product.dtb
    else
      ifeq ($(IMX8QM_A72_BOOT),true)
        # imx8qm auto android, A72 boot
        TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-car-a72.dtb
        # imx8qm auto android with multi-display, A72 boot
        TARGET_BOARD_DTS_CONFIG += imx8qm-md:imx8qm-mek-car-md-a72.dtb
      else
        # imx8qm auto android
        TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-car.dtb
        # imx8qm auto android with multi-display
        TARGET_BOARD_DTS_CONFIG += imx8qm-md:imx8qm-mek-car-md.dtb
      endif
      # imx8qm auto android virtualization
      TARGET_BOARD_DTS_CONFIG += imx8qm-xen:imx8qm-mek-domu-car.dtb
      # imx8qxp auto android
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-car.dtb
    endif # IMX_NO_PRODUCT_PARTITION
  else #PRODUCT_IMX_CAR_M4
    ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
      TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-car2-no-product.dtb
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-car2-no-product.dtb
    else
      ifeq ($(IMX8QM_A72_BOOT),true)
        # imx8qm auto android without m4 image, A72 boot
        TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-car2-a72.dtb
        # imx8qm auto android without m4 image for multi-display, A72 boot
        TARGET_BOARD_DTS_CONFIG += imx8qm-md:imx8qm-mek-car2-md-a72.dtb
      else
        # imx8qm auto android without m4 image
        TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-car2.dtb
        # imx8qm auto android without m4 image for multi-display
        TARGET_BOARD_DTS_CONFIG += imx8qm-md:imx8qm-mek-car2-md.dtb
      endif
      # imx8qxp auto android without m4 image
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-car2.dtb
    endif #IMX_NO_PRODUCT_PARTITION
  endif #PRODUCT_IMX_CAR_M4
else
  ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
    ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
      TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-ov5640-no-product.dtb
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-ov5640-rpmsg-no-product.dtb
    else
      # imx8qm standard android; MIPI-HDMI display
      TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-ov5640.dtb
      # imx8qm standard android; MIPI panel display
      TARGET_BOARD_DTS_CONFIG += imx8qm-mipi-panel:imx8qm-mek-dsi-rm67191.dtb
      # imx8qm standard android; HDMI display
      TARGET_BOARD_DTS_CONFIG += imx8qm-hdmi:imx8qm-mek-hdmi.dtb
      # imx8qm standard android; Multiple display
      TARGET_BOARD_DTS_CONFIG += imx8qm-md:imx8qm-mek-md.dtb
      # imx8qxp standard android; MIPI-HDMI display
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-ov5640-rpmsg.dtb
      TARGET_BOARD_DTS_CONFIG += imx8dx:imx8dx-mek-ov5640.dtb
    endif #IMX_NO_PRODUCT_PARTITION
  else
    ifeq ($(IMX_NO_PRODUCT_PARTITION),true)
      TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-ov5640-no-product-no-dynamic_partition.dtb
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-ov5640-rpmsg-no-product-no-dynamic_partition.dtb
    else
      TARGET_BOARD_DTS_CONFIG := imx8qm:imx8qm-mek-ov5640-no-dynamic_partition.dtb
      TARGET_BOARD_DTS_CONFIG += imx8qxp:imx8qxp-mek-ov5640-rpmsg-no-dynamic_partition.dtb
    endif
  endif
endif #PRODUCT_IMX_CAR


BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8q/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_SEPOLICY_DIRS += \
     packages/services/Car/car_product/sepolicy \
     packages/services/Car/evs/sepolicy \
     device/fsl/imx8q/sepolicy_car \
     $(IMX_DEVICE_PATH)/sepolicy_car \
     device/generic/car/common/sepolicy
endif

ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_BOARD_RECOVERY_FORMAT_SKIP := true
TARGET_BOARD_RECOVERY_SBIN_SKIP := true
endif

BOARD_AVB_ENABLE := true

BOARD_AVB_ALGORITHM := SHA256_RSA4096
# The testkey_rsa4096.pem is copied from external/avb/test/data/testkey_rsa4096.pem
BOARD_AVB_KEY_PATH := device/fsl/common/security/testkey_rsa4096.pem

TARGET_USES_MKE2FS := true

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_HAVE_IMX_EVS := true
endif

# define board type
BOARD_TYPE := MEK

ALL_DEFAULT_INSTALLED_MODULES += $(BOARD_VENDOR_KERNEL_MODULES)

