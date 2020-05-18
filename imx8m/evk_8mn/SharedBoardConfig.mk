KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

#Enable this to config 1GB ddr on evk_imx8mn
#LOW_MEMORY := true

#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

#Enable this to disable product partition build.
#IMX_NO_PRODUCT_PARTITION := true

# NXP 8987 wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/mlan.ko \
    $(KERNEL_OUT)/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/moal.ko \

# mipi-panel touch driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/input/touchscreen/synaptics_dsx/synaptics_dsx_i2c.ko
