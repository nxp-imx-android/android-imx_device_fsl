KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

#Enable this to config 1GB ddr on evk_imx8mm
#LOW_MEMORY := true

#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

#Enable this to disable product partition build.
#IMX_NO_PRODUCT_PARTITION := true

# mipi-panel touch driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/input/touchscreen/synaptics_dsx/synaptics_dsx_i2c.ko
