# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx6/imx6.mk)

ifneq ($(wildcard device/fsl/arm2_6sl/fstab_nand.freescale),)
$(shell touch device/fsl/arm2_6sl/fstab_nand.freescale)
endif

ifneq ($(wildcard device/fsl/arm2_6sl/fstab.freescale),)
$(shell touch device/fsl/arm2_6sl/fstab.freescale)
endif

# Overrides
PRODUCT_NAME := arm2_6sl
PRODUCT_DEVICE := arm2_6sl

PRODUCT_COPY_FILES += \
	device/fsl/arm2_6sl/required_hardware.xml:system/etc/permissions/required_hardware.xml \
	device/fsl/arm2_6sl/init.rc:root/init.freescale.rc \
	device/fsl/arm2_6sl/mxckpd.kl:system/usr/keylayout/mxckpd.kl

DEVICE_PACKAGE_OVERLAYS := device/fsl/arm2_6sl/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_AAPT_CONFIG += large hdpi

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml
