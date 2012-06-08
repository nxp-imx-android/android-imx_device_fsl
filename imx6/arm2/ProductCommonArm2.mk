PRODUCT_COPY_FILES += \
	device/fsl/imx6/arm2/required_hardware.xml:system/etc/permissions/required_hardware.xml \
    	device/fsl/imx6/arm2/vold.fstab:system/etc/vold.fstab \

# GPU files

DEVICE_PACKAGE_OVERLAYS := device/fsl/imx6/arm2/overlay
