# This is a FSL Android Reference Design platform based on i.MX8MM board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx8m/evk_8mm

PRODUCT_8MM_DDR4 := true

$(call inherit-product, $(TOPDIR)$(IMX_DEVICE_PATH)/evk_8mm.mk)

# Overrides
PRODUCT_NAME := evk_8mm_ddr4
