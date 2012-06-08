PRODUCT_COPY_FILES += \
	device/fsl/imx6/sabresd/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/imx6/sabresd/init.rc:root/init.freescale.rc \
	device/fsl/imx6/sabresd/init.usb.rc:root/init.freescale.usb.rc \
    	device/fsl/imx6/sabresd/vold.fstab:system/etc/vold.fstab \
	device/fsl/imx6/sabresd/gpsreset.sh:system/etc/gpsreset.sh \
	device/fsl/imx6/sabresd/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/imx6/sabresd/eGalax_Touch_Screen.idc:system/usr/idc/HannStar_P1003_Touchscreen.idc

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/fsl/imx6/sabresd/overlay
