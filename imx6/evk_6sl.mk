# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)

# Overrides
PRODUCT_NAME := evk_6sl
PRODUCT_DEVICE := evk_6sl

PRODUCT_COPY_FILES += \
	device/fsl/evk_6sl/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/evk_6sl/vold.fstab:system/etc/vold.fstab \
	device/fsl/evk_6sl/init.rc:root/init.freescale.rc \
	device/fsl/evk_6sl/mxckpd.kl:system/usr/keylayout/mxckpd.kl \
	device/fsl/evk_6sl/audio_policy.conf:system/etc/audio_policy.conf

DEVICE_PACKAGE_OVERLAYS := device/fsl/evk_6sl/overlay
