KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

#Enable this to disable product partition build.
#IMX_NO_PRODUCT_PARTITION := true

BOARD_VENDOR_KERNEL_MODULES += \
        $(KERNEL_OUT)/drivers/net/wireless/qcacld-2.0/wlan.ko
