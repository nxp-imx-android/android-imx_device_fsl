# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

-include device/fsl/common/imx_path/ImxPathConfig.mk
$(call inherit-product, device/fsl/imx7/imx7.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)

ifneq ($(wildcard device/fsl/sabresd_7d/fstab_nand.freescale),)
$(shell touch device/fsl/sabresd_7d/fstab_nand.freescale)
endif

ifneq ($(wildcard device/fsl/sabresd_7d/fstab.freescale),)
$(shell touch device/fsl/sabresd_7d/fstab.freescale)
endif

# Overrides
PRODUCT_NAME := sabresd_7d
PRODUCT_DEVICE := sabresd_7d

PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_COPY_FILES += \
	device/fsl/sabresd_7d/init.rc:root/init.freescale.rc \
	device/fsl/common/input/imx-keypad.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/imx-keypad.idc \
	device/fsl/common/input/imx-keypad.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/imx-keypad.kl \

PRODUCT_COPY_FILES += device/fsl/sabresd_7d/init.freescale.sd.rc:root/init.freescale.sd.rc

# Audio
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
	device/fsl/sabresd_7d/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
	device/fsl/sabresd_7d/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \

DEVICE_PACKAGE_OVERLAYS := device/fsl/sabresd_7d/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
	frameworks/native/data/etc/android.hardware.screen.portrait.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.portrait.xml \
	frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
	frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
	frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
	frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
	frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
	frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
	frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
	frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
	frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
	frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
	device/fsl/sabresd_7d/required_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/required_hardware.xml

# HWC2 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.composer@2.1-service

# Gralloc HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

PRODUCT_PACKAGES += \
    libg2d \
    gatekeeper.imx7

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service

# imx7 sensor HAL libs.
PRODUCT_PACKAGES += \
        sensors.imx7

# Usb HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.0-service

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

# WiFi HAL
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wifilogd \
    wificond

# Bluetooth firmware files.
PRODUCT_PACKAGES += \
	ar3kbdaddr_ar3001			\
	PS_ASIC_ar3001				\
	RamPatch_ar3001				\
	ar3kbdaddr_ar3002			\
	PS_ASIC_ar3002				\
	RamPatch_ar3002				\
	Type_ZP.hcd					\
	bcmdhd.cal					\
	bt_vendor.conf				\
	fw_bcmdhd.bin				\
	fw_bcmdhd_apsta.bin

# Broadcom BCM4339 extended binary
PRODUCT_PACKAGES += \
    bcmdhd.SN8000.OOB.cal     \
    bcmdhd.SN8000.SDIO.cal    \
    sn_fw_bcmdhd_apsta.bin    \
    sn_fw_bcmdhd.bin          \
    sn_fw_bcmdhd_mfgtest.bin  \
    1bw_fw_bcmdhd.bin         \
    1bw_fw_bcmdhd_mfgtest.bin \
    BCM43341B0.1BW.hcd        \
    bcmdhd.1BW.OOB.cal        \
    bcmdhd.1BW.SDIO.cal       \
    1dx_fw_bcmdhd.bin         \
    1dx_fw_bcmdhd_mfgtest.bin \
    BCM43430A1.1DX.hcd        \
    bcmdhd.1DX.OOB.cal        \
    bcmdhd.1DX.SDIO.cal       \
    wl

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# DRM HAL
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    ro.internel.storage_size=/sys/block/mmcblk0/size

PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/presistdata
