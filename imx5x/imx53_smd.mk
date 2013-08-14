# This is a FSL Android Reference Design platform based on i.MX51 BBG board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx5x/imx5x.mk)

# Overrides
PRODUCT_NAME := imx53_smd
PRODUCT_DEVICE := imx53_smd

PRODUCT_COPY_FILES += \
	device/common/gps/gps.conf_US:system/etc/gps.conf \
	device/fsl/imx53_smd/fstab.freescale:root/fstab.freescale \
	device/fsl/imx53_smd/init.freescale.rc:root/init.freescale.rc \
	device/fsl/imx53_smd/gpsreset.sh:system/bin/gpsreset.sh \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/eGalax_Touch_Screen.idc \
	device/fsl/common/input/eGalax_Touch_Screen.idc:system/usr/idc/HannStar_P1003_Touchscreen.idc 

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.faketouch.xml:system/etc/permissions/android.hardware.faketouch.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

# audio related files
PRODUCT_COPY_FILES += \
	device/fsl/imx53_smd/audio_policy.conf:system/etc/audio_policy.conf \
	device/fsl/imx53_smd/mixer_paths.xml:system/etc/mixer_paths.xml

# Bluetooth config file
PRODUCT_COPY_FILES += \
	system/bluetooth/data/main.nonsmartphone.conf:system/etc/bluetooth/main.conf

DEVICE_PACKAGE_OVERLAYS := device/fsl/imx53_smd/overlay

PRODUCT_CHARACTERISTICS := tablet

