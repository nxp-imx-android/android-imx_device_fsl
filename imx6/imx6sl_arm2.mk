# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)

# Overrides
PRODUCT_NAME := imx6sl_arm2
PRODUCT_DEVICE := imx6sl_arm2

PRODUCT_COPY_FILES += \
	device/fsl/imx6sl_arm2/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/imx6sl_arm2/init.rc:root/init.freescale.rc \
	device/fsl/imx6sl_arm2/init.usb.rc:root/init.freescale.usb.rc \
        device/fsl/imx6sl_arm2/vold.fstab:system/etc/vold.fstab \
	device/fsl/imx6sl_arm2/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/imx6sl_arm2/eGalax_Touch_Screen.idc:system/usr/idc/HannStar_P1003_Touchscreen.idc
