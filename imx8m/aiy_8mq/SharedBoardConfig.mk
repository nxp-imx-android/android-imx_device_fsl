KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

BOARD_VENDOR_KERNEL_MODULES += \
        $(KERNEL_OUT)/drivers/net/wireless/qcacld-2.0/wlan.ko
