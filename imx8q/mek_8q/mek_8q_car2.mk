# -------@block_infrastructure-------
CONFIG_REPO_PATH := device/nxp
CURRENT_FILE_PATH :=  $(lastword $(MAKEFILE_LIST))
IMX_DEVICE_PATH := $(strip $(patsubst %/, %, $(dir $(CURRENT_FILE_PATH))))

# -------@block_kernel_bootimg-------
# Don't enable vendor boot for Android Auto without M4 EVS for now
TARGET_USE_VENDOR_BOOT ?= false

# -------@block_storage-------
# Android Auto without M4 EVS uses dynamic partition
TARGET_USE_DYNAMIC_PARTITIONS ?= true

# -------@block_infrastructure-------
include $(IMX_DEVICE_PATH)/mek_8q_car.mk

# -------@block_common_config-------
# Overrides
PRODUCT_NAME := mek_8q_car2

# -------@block_miscellaneous-------
PRODUCT_COPY_FILES += \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q_car/xen:xen
