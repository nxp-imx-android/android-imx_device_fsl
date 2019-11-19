TARGET_BOOTLOADER_POSTFIX := imx
TARGET_DTB_POSTFIX := -dtb

# u-boot target for imx7ulp_evk
TARGET_BOOTLOADER_CONFIG := imx7ulp:imx7ulp_evk_android_defconfig

# u-boot target used by uuu for imx7ulp_evk
TARGET_BOOTLOADER_CONFIG += imx7ulp-evk-uuu:mx7ulp_evk_defconfig

TARGET_KERNEL_DEFCONFIG := imx_v7_android_defconfig

# TARGET_KERNEL_ADDITION_DEFCONF := imx_v7_android_addition_defconfig

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

