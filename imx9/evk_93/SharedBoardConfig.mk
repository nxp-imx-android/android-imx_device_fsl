# -------@block_kernel_bootimg-------

KERNEL_NAME := Image.lz4
TARGET_KERNEL_ARCH := arm64

LOADABLE_KERNEL_MODULE ?= false

# -------@block_memory-------
#Enable this to config low memory
LOW_MEMORY := false

# -------@block_security-------
#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

# -------@block_storage-------
# the bootloader image used in dual-bootloader OTA
# TODO use the correct name for OTA
BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx93-dual.img
