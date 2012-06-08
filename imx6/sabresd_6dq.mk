# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)

# Overrides
PRODUCT_NAME := sabresd_6dq
PRODUCT_DEVICE := sabresd_6dq

include device/fsl/imx6/sabresd/SabreSDProductCommon.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
