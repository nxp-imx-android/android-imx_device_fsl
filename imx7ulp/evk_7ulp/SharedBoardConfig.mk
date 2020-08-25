# after selecting the target by "lunch" command, TARGET_PRODUCT will be set

KERNEL_NAME := zImage
TARGET_KERNEL_ARCH := arm

# NXP 8987 wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/mlan.ko \
    $(KERNEL_OUT)/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/moal.ko
