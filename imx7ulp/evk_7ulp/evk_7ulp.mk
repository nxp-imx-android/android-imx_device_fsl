# This is a FSL Android Reference Design platform based on i.MX6Q ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx7ulp/evk_7ulp

# configs shared between uboot, kernel and Android rootfs
include $(IMX_DEVICE_PATH)/SharedBoardConfig.mk

-include device/fsl/common/imx_path/ImxPathConfig.mk
$(call inherit-product, device/fsl/imx7ulp/ProductConfigCommon.mk)
$(call inherit-product-if-exists,vendor/google/products/gms.mk)
$(call inherit-product, build/target/product/go_defaults.mk)

ifneq ($(wildcard $(IMX_DEVICE_PATH)/fstab_nand.freescale),)
$(shell touch $(IMX_DEVICE_PATH)/fstab_nand.freescale)
endif

ifneq ($(wildcard $(IMX_DEVICE_PATH)/fstab.freescale),)
$(shell touch $(IMX_DEVICE_PATH)/fstab.freescale)
endif

# Overrides
PRODUCT_NAME := evk_7ulp
PRODUCT_DEVICE := evk_7ulp
PRODUCT_MODEL := EVK_MX7ULP

PRODUCT_FULL_TREBLE_OVERRIDE := true

# Copy device related config and binary to board
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml \
    $(IMX_DEVICE_PATH)/fstab.freescale:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.freescale \
    $(IMX_DEVICE_PATH)/early.init.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/early.init.cfg \
    $(IMX_DEVICE_PATH)/init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.rc \
    $(IMX_DEVICE_PATH)/required_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/required_hardware.xml \
    $(IMX_DEVICE_PATH)/ueventd.freescale.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    $(IMX_DEVICE_PATH)/privapp-permissions-imx.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-imx.xml \
    device/fsl/common/init/init.insmod.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.insmod.sh \
    device/fsl/common/input/imx-keypad.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/imx-keypad.idc \
    device/fsl/common/input/imx-keypad.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/imx-keypad.kl \
    device/fsl/common/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    device/fsl/common/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

ifeq ($(PRODUCT_7ULP_REVB), true)
#evk board, NXP 8987 wifi supplicant overlay
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.imx7ulp.revb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.additional.rc
else
#evkb board, bcm wifi supplicant overlay
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.imx7ulp.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.additional.rc
endif

# ONLY devices that meet the CDD's requirements may declare these features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.screen.portrait.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.portrait.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    vendor/nxp/fsl-proprietary/mcu-sdk/7ulp/imx7ulp_m4_demo.img:imx7ulp_m4_demo.img

# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
    $(IMX_DEVICE_PATH)/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy


# Audio
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(IMX_DEVICE_PATH)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

# Audio card json
PRODUCT_COPY_FILES += \
    device/fsl/common/audio-json/wm8960_rpmsg_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/wm8960_rpmsg_config.json \
    device/fsl/common/audio-json/readme.txt:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/readme.txt

# fastboot_imx_flashall scripts, fsl-sdcard-partition script and uuu_imx_android_flash scripts
PRODUCT_COPY_FILES += \
    device/fsl/common/tools/fastboot_imx_flashall.bat:fastboot_imx_flashall.bat \
    device/fsl/common/tools/fastboot_imx_flashall.sh:fastboot_imx_flashall.sh \
    device/fsl/common/tools/fsl-sdcard-partition.sh:fsl-sdcard-partition.sh \
    device/fsl/common/tools/uuu_imx_android_flash.bat:uuu_imx_android_flash.bat \
    device/fsl/common/tools/uuu_imx_android_flash.sh:uuu_imx_android_flash.sh

DEVICE_PACKAGE_OVERLAYS := $(IMX_DEVICE_PATH)/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi xxhdpi
PRODUCT_CUSTOM_RECOVERY_DENSITY := mdpi

PRODUCT_PACKAGES += \
    libEGL_VIVANTE \
    libGLESv1_CM_VIVANTE \
    libGLESv2_VIVANTE \
    gralloc_viv.imx \
    libGAL \
    libGLSLC \
    libVSC \
    libg2d-viv \
    libgpuhelper \
    gatekeeper.imx

# imx7 Hardware HAL libs.
PRODUCT_PACKAGES += \
        gralloc.imx      \

# HWC2 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.3-service

# Gralloc HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

PRODUCT_PACKAGES += \
    android.hardware.audio@5.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@5.0-impl \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.configstore@1.1-service \
    configstore@1.1.policy

# imx7 sensor HAL libs.
PRODUCT_PACKAGES += \
        sensors.imx

# Usb HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.1-service.imx

# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

ifeq ($(PRODUCT_7ULP_REVB), true)
# Qcom WiFi Firmware
PRODUCT_COPY_FILES += \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca9377/bdwlan30.bin:vendor/firmware/bdwlan30.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca9377/otp30.bin:vendor/firmware/otp30.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca9377/qwlan30.bin:vendor/firmware/qwlan30.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/wlan/qca9377/qcom_cfg.ini:vendor/firmware/wlan/qcom_cfg.ini

# Qcom 1PJ Bluetooth Firmware
PRODUCT_COPY_FILES += \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca/tfbtnv11.bin:vendor/firmware/nvm_tlv_3.2.bin \
    vendor/nxp/qca-wifi-bt/1PJ_QCA9377-3_LEA_2.0/lib/firmware/qca/tfbtfw11.tlv:vendor/firmware/rampatch_tlv_3.2.tlv \
    vendor/nxp/qca-wifi-bt/qca_proprietary/Android_HAL/wcnss_filter_7ulp:vendor/bin/wcnss_filter
else
# BCM Bluetooth vendor config
PRODUCT_PACKAGES += \
    bt_vendor.conf

# BCM 1CX Bluetooth Firmware
PRODUCT_COPY_FILES += \
    vendor/nxp/imx-firmware/cyw-wifi-bt/1DX_CYW43430/BCM43430A1.1DX.hcd:$(TARGET_COPY_OUT_VENDOR)/firmware/brcm/CYW43430A1.1DX.hcd

# NXP 8987 WiFi Firmware
PRODUCT_COPY_FILES += \
    vendor/nxp/imx-firmware/nxp/FwImage_8987/sdiouart8987_combo_v0.bin:vendor/firmware/sdiouart8987_combo_v0.bin
endif

# Wifi regulatory
PRODUCT_COPY_FILES += \
    external/wireless-regdb/regulatory.db:vendor/firmware/regulatory.db \
    external/wireless-regdb/regulatory.db.p7s:vendor/firmware/regulatory.db.p7s

# WiFi HAL
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wifilogd \
    wificond

# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service

# DRM HAL
PRODUCT_PACKAGES += \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

PRODUCT_PROPERTY_OVERRIDES += \
    ro.frp.pst=/dev/block/by-name/presistdata

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-impl \
    android.hardware.gatekeeper@1.0-service

#Dumpstate HAL 1.0 support
PRODUCT_PACKAGES += \
    android.hardware.dumpstate@1.0-service.imx

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

PRODUCT_PROPERTY_OVERRIDES += \
    ro.crypto.fde_algorithm=adiantum \
    ro.crypto.fde_sector_size=4096 \
    ro.crypto.volume.contents_mode=adiantum \
    ro.crypto.volume.filenames_mode=adiantum

IMX-DEFAULT-G2D-LIB := libg2d-viv
