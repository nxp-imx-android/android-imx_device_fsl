PRODUCT_COPY_FILES += \
	device/fsl/imx6/evk/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/imx6/evk/vold.fstab:system/etc/vold.fstab

DEVICE_PACKAGE_OVERLAYS := device/fsl/imx6/evk/overlay
