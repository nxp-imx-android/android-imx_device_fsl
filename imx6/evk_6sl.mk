# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)

# Overrides
PRODUCT_NAME := evk_6sl
PRODUCT_DEVICE := evk_6sl

include device/fsl/imx6/evk/ProductCommonEvk.mk

PRODUCT_COPY_FILES +=	\
	device/fsl/evk_6sl/init.rc:root/init.freescale.rc \
	device/fsl/evk_6sl/mxckpd.kl:system/usr/keylayout/mxckpd.kl
