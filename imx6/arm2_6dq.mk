# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)

# Overrides
PRODUCT_NAME := arm2_6dq
PRODUCT_DEVICE := arm2_6dq

include device/fsl/imx6/arm2/ProductCommonArm2.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

PRODUCT_COPY_FILES +=	\
	device/fsl/arm2_6dq/init.rc:root/init.freescale.rc

