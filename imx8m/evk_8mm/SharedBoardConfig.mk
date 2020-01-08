KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64
# after selecting the target by "lunch" command, TARGET_PRODUCT will be set
ifeq ($(TARGET_PRODUCT),evk_8mm_ddr4)
  PRODUCT_8MM_DDR4 := true
endif

#Enable this to config 1GB ddr on evk_imx8mm
#LOW_MEMORY := true

#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

#Enable this to disable product partition build.
#IMX_NO_PRODUCT_PARTITION := true

# LPDDR4 board use qcom wifi and for DDR4 board use cypress wifi
ifeq ($(PRODUCT_8MM_DDR4), true)
  # BCM fmac wifi driver module
  BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko \
    $(KERNEL_OUT)/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko
else
  # QCA qcacld wifi driver module
  BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/qcacld-2.0/wlan.ko
endif

# mipi-panel touch driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/input/touchscreen/synaptics_dsx/synaptics_dsx_i2c.ko
