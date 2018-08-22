# This is a FSL Android Reference Design platform based on i.MX8QP ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx8m/evk_8mm

-include device/fsl/common/imx_path/ImxPathConfig.mk
$(call inherit-product, device/fsl/imx8m/ProductConfigCommon.mk)

ifneq ($(wildcard $(IMX_DEVICE_PATH)/fstab.freescale),)
$(shell touch $(IMX_DEVICE_PATH)/fstab.freescale)
endif

# Overrides
PRODUCT_NAME := evk_8mm
PRODUCT_DEVICE := evk_8mm

PRODUCT_FULL_TREBLE_OVERRIDE := true

PRODUCT_COPY_FILES += \
	$(IMX_DEVICE_PATH)/init.rc:root/init.freescale.rc \
	$(IMX_DEVICE_PATH)/init.imx8mm.rc:root/init.freescale.imx8mm.rc \
	$(IMX_DEVICE_PATH)/init.usb.rc:root/init.freescale.usb.rc

PRODUCT_COPY_FILES +=	\
    $(LINUX_FIRMWARE_IMX_PATH)/linux-firmware-imx/firmware/sdma/sdma-imx7d.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/imx/sdma/sdma-imx7d.bin

# Audio
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
	$(IMX_DEVICE_PATH)/audio_effects.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.conf \
	$(IMX_DEVICE_PATH)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
	frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
	frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.freescale.sd.rc:root/init.freescale.sd.rc \
    $(IMX_DEVICE_PATH)/init.freescale.sd.rc:root/init.recovery.freescale.sd.rc \
    $(IMX_DEVICE_PATH)/init.freescale.emmc.rc:root/init.freescale.emmc.rc \
    $(IMX_DEVICE_PATH)/init.freescale.emmc.rc:root/init.recovery.freescale.emmc.rc

DEVICE_PACKAGE_OVERLAYS := $(IMX_DEVICE_PATH)/overlay

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
	frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
	frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
	frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
	$(IMX_DEVICE_PATH)/required_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/required_hardware.xml \

PRODUCT_COPY_FILES += \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/gpu-viv/lib64/egl/egl.cfg:$(TARGET_COPY_OUT_VENDOR)/lib64/egl/egl.cfg \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/gpu-viv/lib/egl/egl.cfg:$(TARGET_COPY_OUT_VENDOR)/lib/egl/egl.cfg

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
    libEGL_VIVANTE \
    libGLESv1_CM_VIVANTE \
    libGLESv2_VIVANTE \
    gralloc_viv.imx8 \
    libGAL \
    libGLSLC \
    libVSC \
    libg2d \
    libgpuhelper \
    gatekeeper.imx8

PRODUCT_PACKAGES += \
    Launcher3

PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service

# Usb HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.1-service.imx

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

# Qcom 1PJ Bluetooth Firmware
 PRODUCT_COPY_FILES += \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca/tfbtnv11.bin:vendor/firmware/nvm_tlv_3.2.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca/tfbtfw11.tlv:vendor/firmware/rampatch_tlv_3.2.tlv \
    vendor/nxp/qca-wifi-bt/qca_proprietary/Android_HAL/wcnss_filter_8mm:vendor/bin/wcnss_filter

# WiFi HAL
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wifilogd \
    wificond


# Qcom WiFi Firmware
PRODUCT_COPY_FILES += \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca9377/bdwlan30.bin:vendor/firmware/bdwlan30.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca9377/otp30.bin:vendor/firmware/otp30.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca9377/qwlan30.bin:vendor/firmware/qwlan30.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/wlan/qca9377/qcom_cfg.ini:vendor/firmware/wlan/qcom_cfg.ini

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# DRM HAL
TARGET_ENABLE_MEDIADRM_64 := true
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

ifneq ($(BUILD_TARGET_FS),ubifs)
PRODUCT_PROPERTY_OVERRIDES += \
    ro.internel.storage_size=/sys/block/mmcblk2/size \
    ro.frp.pst=/dev/block/by-name/presistdata
endif

# ro.product.first_api_level indicates the first api level the device has commercially launched on.
PRODUCT_PROPERTY_OVERRIDES += \
    ro.product.first_api_level=26

PRODUCT_PACKAGES += \
    libg1 \
    libhantro \
    libcodec \
    libhantro_h1 \
    libcodec_enc

# Add oem unlocking option in settings.
PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/presistdata
