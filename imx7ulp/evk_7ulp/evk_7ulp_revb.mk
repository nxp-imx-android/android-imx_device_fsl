# This is a FSL Android Reference Design platform based on i.MX7ULP_REVB board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx7ulp/evk_7ulp

PRODUCT_7ULP_REVB := true

$(call inherit-product, $(TOPDIR)$(IMX_DEVICE_PATH)/evk_7ulp.mk)

# Overrides
PRODUCT_NAME := evk_7ulp_revb
