# This is a FSL Android Reference Design platform based on i.MX51 BBG board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx5x/imx5x.mk)

# Overrides
PRODUCT_NAME := imx51_3stack
PRODUCT_DEVICE := imx51_3stack

PRODUCT_COPY_FILES += \
	device/fsl/imx51_3stack/init.rc:root/init.freescale.rc
