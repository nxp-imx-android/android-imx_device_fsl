# This is a FSL Android Reference Design platform based on i.MX51 BBG board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx5x/imx5x.mk)

# Overrides
PRODUCT_NAME := imx50_rdp
PRODUCT_DEVICE := imx50_rdp

PRODUCT_PACKAGES += \
	HandWriting \
	HandWriting2 \
	FastPageTurn \
	Highlight

PRODUCT_COPY_FILES += \
        device/fsl/imx50_rdp/mxc_power_key.kl:system/usr/keylayout/mxc_power_key.kl \
	device/fsl/imx50_rdp/mxckpd.kl:system/usr/keylayout/mxckpd.kl \
	device/fsl/imx50_rdp/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/imx50_rdp/init.rc:root/init.freescale.rc \
        device/fsl/imx50_rdp/vold.fstab:system/etc/vold.fstab
