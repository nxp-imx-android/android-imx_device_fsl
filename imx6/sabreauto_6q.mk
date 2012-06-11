# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)

# Overrides
PRODUCT_NAME := sabreauto_6q
PRODUCT_DEVICE := sabreauto_6q

PRODUCT_COPY_FILES += \
	device/fsl/sabreauto_6q/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/sabreauto_6q/init.rc:root/init.freescale.rc \
	device/fsl/sabreauto_6q/init.usb.rc:root/init.freescale.usb.rc \
        device/fsl/sabreauto_6q/vold.fstab:system/etc/vold.fstab \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/HannStar_P1003_Touchscreen.idc

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/fsl/sabreauto_6q/overlay

include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
