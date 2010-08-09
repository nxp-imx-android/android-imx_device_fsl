$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)

# overrides
PRODUCT_BRAND := freescale
PRODUCT_MANUFACTUER := freescale

PRODUCT_PACKAGES += \
	SdkSetup \
	LiveWallpapers \
	LiveWallpapersPicker \
	MagicSmokeWallpapers \
	VisualizationWallpapers \
	libRS \
	librs_jni

PRODUCT_LOCALES += hdpi mdpi

PRODUCT_COPY_FILES +=	\
	device/fsl/imx5x/vold.fstab:system/etc/vold.fstab \
	device/fsl/imx5x/mxckpd.kl:system/usr/keylayout/mxckpd.kl \
	device/fsl/imx5x/Dell_Dell_USB_Keyboard.kl:system/usr/keylayout/Dell_Dell_USB_Keyboard.kl

PRODUCT_COPY_FILES +=	\
	device/fsl/imx5x/init.rc:root/init.rc
