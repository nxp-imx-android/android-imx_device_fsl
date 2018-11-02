# This is a FSL Android Reference Design platform based on i.MX6Q board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx8q/mek_8q

PRODUCT_IMX_CAR := true

include $(IMX_DEVICE_PATH)/mek_8q.mk

# Overrides
PRODUCT_NAME := mek_8q_car
PRODUCT_PACKAGE_OVERLAYS := $(IMX_DEVICE_PATH)/overlay_car packages/services/Car/car_product/overlay

PRODUCT_COPY_FILES += \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qm_m4_1_tcm_auto.bin:m4_image-imx8qm.img \
    $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_tcm_auto.bin:m4_image-imx8qxp.img \
    $(IMX_DEVICE_PATH)/init.freescale.emmc.xen.rc:root/init.freescale.emmc.xen.rc \
    $(IMX_DEVICE_PATH)/init.freescale.emmc.xen.rc:root/init.recovery.freescale.emmc.xen.rc \
    $(IMX_DEVICE_PATH)/init.freescale.sd.xen.rc:root/init.freescale.sd.xen.rc \
    $(IMX_DEVICE_PATH)/init.freescale.sd.xen.rc:root/init.recovery.freescale.sd.xen.rc \
    packages/services/Car/car_product/init/init.bootstat.rc:root/init.bootstat.rc \
    packages/services/Car/car_product/init/init.car.rc:root/init.car.rc \
    device/fsl/common/security/rpmb_key_test.bin:rpmb_key_test.bin

# ONLY devices that meet the CDD's requirements may declare these features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.type.automotive.xml \
    frameworks/native/data/etc/android.software.freeform_window_management.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.freeform_window_management.xml

# Add Google prebuilt services
PRODUCT_PACKAGES += \
    GoogleSearchEmbedded \
    GoogleDemandspace \
    GoogleMaps \
    GooglePlayStore \
    GoogleGmscore_demo \
    GoogleServicesFramework_demo \
    GoogleLoginService_demo \
    GoogleExtServices_demo \
    GoogleExtShared_demo \
    GooglePartnerSetup_demo \
    HeadUnit

# Add Car related HAL
PRODUCT_PACKAGES += \
    libion \
    vehicle.default \
    android.hardware.automotive.vehicle@2.0-service

# Add Trusty OS backed gatekeeper and secure storage proxy
PRODUCT_PACKAGES += \
    keystore.trusty \
    gatekeeper.trusty \
    storageproxyd
