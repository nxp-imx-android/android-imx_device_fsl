# after selecting the target by "lunch" command, TARGET_PRODUCT will be set
ifeq ($(TARGET_PRODUCT),evk_7ulp_revb)
  PRODUCT_7ULP_REVB := true
endif

KERNEL_NAME := zImage
TARGET_KERNEL_ARCH := arm

ifeq ($(PRODUCT_7ULP_REVB), true)
  # QCA qcacld wifi driver module
  BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/qcacld-2.0/wlan.ko
else
  # NXP 8987 wifi driver module
  BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/mlan.ko \
    $(KERNEL_OUT)/drivers/net/wireless/nxp/mxm_wifiex/wlan_src/moal.ko

endif

