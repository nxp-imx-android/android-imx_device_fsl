# This is a FSL Android Reference Design platform based on i.MX51 BBG board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx5x/imx5x.mk)

# Overrides
PRODUCT_NAME := imx50_evk
PRODUCT_DEVICE := imx50_evk

PRODUCT_PACKAGES += \
	HandWriting \
	FastPageTurn \
	Highlight

PRODUCT_COPY_FILES += \
	device/fsl/imx50_bbg/init.rc:root/init.freescale.rc
