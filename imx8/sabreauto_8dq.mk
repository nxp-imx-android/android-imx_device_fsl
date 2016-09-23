# This is a FSL Android Reference Design platform based on i.MX8QP ARD board
# It will inherit from FSL core product which in turn inherit from Google generic

$(call inherit-product, device/fsl/imx8/imx8.mk)

ifneq ($(wildcard device/fsl/sabreauto_8dq/fstab_nand.freescale),)
$(shell touch device/fsl/sabreauto_8dq/fstab_nand.freescale)
endif

ifneq ($(wildcard device/fsl/sabreauto_8dq/fstab.freescale),)
$(shell touch device/fsl/sabreauto_8dq/fstab.freescale)
endif

# Overrides
PRODUCT_NAME := sabreauto_8dq
PRODUCT_DEVICE := sabreauto_8dq


PRODUCT_COPY_FILES += \
	device/fsl/sabreauto_8dq/init.rc:root/init.freescale.rc \
	device/fsl/sabreauto_8dq/init.i.MX8DV.rc:root/init.freescale.i.MX8DV.rc \
	device/fsl/sabreauto_8dq/init.i.MX8QM.rc:root/init.freescale.i.MX8QM.rc \
	device/fsl/sabreauto_8dq/audio_policy.conf:system/etc/audio_policy.conf \
	device/fsl/sabreauto_8dq/audio_policy_cts.conf:system/etc/audio_policy_cts.conf \
	device/fsl/sabreauto_8dq/audio_effects.conf:system/vendor/etc/audio_effects.conf

PRODUCT_COPY_FILES +=	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6d.bin:system/lib/firmware/vpu/vpu_fw_imx8dv.bin 	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx6q.bin:system/lib/firmware/vpu/vpu_fw_imx8qm.bin
# setup dm-verity configs.
ifneq ($(BUILD_TARGET_FS),ubifs)
PRODUCT_SYSTEM_VERITY_PARTITION := /dev/block/mmcblk1p5
$(call inherit-product, build/target/product/verity.mk)
endif
# GPU files

DEVICE_PACKAGE_OVERLAYS := device/fsl/sabreauto_6q/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi

PRODUCT_COPY_FILES += \
	frameworks/native/data/etc/android.hardware.audio.output.xml:system/etc/permissions/android.hardware.audio.output.xml \
	frameworks/native/data/etc/android.hardware.sensor.compass.xml:system/etc/permissions/android.hardware.sensor.compass.xml \
	frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.xml:system/etc/permissions/android.hardware.touchscreen.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
	frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
	frameworks/native/data/etc/android.hardware.screen.portrait.xml:system/etc/permissions/android.hardware.screen.portrait.xml \
	frameworks/native/data/etc/android.hardware.screen.landscape.xml:system/etc/permissions/android.hardware.screen.landscape.xml \
	frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
	frameworks/native/data/etc/android.software.voice_recognizers.xml:system/etc/permissions/android.software.voice_recognizers.xml \
	frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
	frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
	frameworks/native/data/etc/android.software.device_admin.xml:system/etc/permissions/android.software.device_admin.xml \
	frameworks/native/data/etc/android.software.managed_users.xml:system/etc/permissions/android.software.managed_users.xml \
	frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
	frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
	frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
	frameworks/native/data/etc/android.hardware.camera.xml:system/etc/permissions/android.hardware.camera.xml \
	frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
	frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
	frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
	frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:system/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
	frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
	frameworks/native/data/etc/android.hardware.opengles.aep.xml:system/etc/permissions/android.hardware.opengles.aep.xml \
	device/fsl/sabreauto_8dq/required_hardware.xml:system/etc/permissions/required_hardware.xml \

PRODUCT_COPY_FILES += \
    device/fsl-proprietary/gpu-viv/lib64/egl/egl.cfg:system/lib64/egl/egl.cfg \
    device/fsl-proprietary/gpu-viv/lib/egl/egl.cfg:system/lib/egl/egl.cfg

PRODUCT_PACKAGES += AudioRoute  \
                    libEGL_VIVANTE \
                    libGLESv1_CM_VIVANTE \
                    libGLESv2_VIVANTE \
                    gralloc_viv.imx8 \
                    hwcomposer_fsl.imx8 \
                    libGAL \
                    libGLSLC \
                    libVSC \
                    libg2d \
                    libgpuhelper \
                    libSPIRV \
                    libvulkan_VIVANTE \
                    vulkan.imx8
