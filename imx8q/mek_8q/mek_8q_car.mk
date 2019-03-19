# This is a FSL Android Reference Design platform based on i.MX6Q board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx8q/mek_8q

PRODUCT_IMX_CAR := true
# build m4 image from source code
PRODUCT_IMX_CAR_M4_BUILD := true
#with m4 when build uboot
PRODUCT_IMX_CAR_M4 ?= true
#without m4 when build uboot
#PRODUCT_IMX_CAR_M4 ?= false

include $(IMX_DEVICE_PATH)/mek_8q.mk
# Include keystore attestation keys and certificates.
-include $(IMX_SECURITY_PATH)/attestation/imx_attestation.mk

# Overrides
PRODUCT_NAME := mek_8q_car
PRODUCT_PACKAGE_OVERLAYS := $(IMX_DEVICE_PATH)/overlay_car packages/services/Car/car_product/overlay

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.freescale.emmc.xen.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.emmc.xen.rc \
    $(IMX_DEVICE_PATH)/init.freescale.emmc.xen.rc:root/init.recovery.freescale.emmc.xen.rc \
    $(IMX_DEVICE_PATH)/init.freescale.sd.xen.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.freescale.sd.xen.rc \
    $(IMX_DEVICE_PATH)/init.freescale.sd.xen.rc:root/init.recovery.freescale.sd.xen.rc \
    packages/services/Car/car_product/init/init.bootstat.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.bootstat.rc \
    packages/services/Car/car_product/init/init.car.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.car.rc \
    system/core/rootdir/init.zygote_auto.rc:root/init.zygote_auto.rc \
    device/fsl/common/security/rpmb_key_test.bin:rpmb_key_test.bin \
    device/fsl/common/security/testkey_public_rsa4096.bin:testkey_public_rsa4096.bin

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
    gatekeeper.trusty \
    storageproxyd

# Use special ro.zygote to make default init.rc didn't load default zygote rc
PRODUCT_PRODUCT_PROPERTIES += ro.zygote=zygote_auto
ifeq ($(PRODUCT_IMX_CAR_M4),false)
# Simulate the vehical rpmsg register event for non m4 car image
PRODUCT_PROPERTY_OVERRIDES += \
    vendor.vehicle.register=1 \
    vendor.evs.video.ready=1
else
#no bootanimation since it is handled in m4 image
PRODUCT_PROPERTY_OVERRIDES += \
    debug.sf.nobootanimation=1
endif # PRODUCT_IMX_CAR_M4

# Specify rollback index for bootloader and for AVB
ifneq ($(AVB_RBINDEX),)
BOARD_AVB_ROLLBACK_INDEX := $(AVB_RBINDEX)
else
BOARD_AVB_ROLLBACK_INDEX := 0
endif

ifneq ($(BOOTLOADER_RBINDEX),)
export ROLLBACK_INDEX_IN_CONTAINER := $(BOOTLOADER_RBINDEX)
else
export ROLLBACK_INDEX_IN_CONTAINER := 0
endif
