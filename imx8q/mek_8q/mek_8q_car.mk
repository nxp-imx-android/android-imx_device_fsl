# This is a FSL Android Reference Design platform based on i.MX6Q board
# It will inherit from FSL core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx8q/mek_8q

# Android Auto will not use dynamic partition
TARGET_USE_DYNAMIC_PARTITIONS := false

include $(IMX_DEVICE_PATH)/mek_8q.mk

# Overrides
PRODUCT_NAME := mek_8q_car
PRODUCT_PACKAGE_OVERLAYS := $(IMX_DEVICE_PATH)/overlay_car packages/services/Car/car_product/overlay

PRODUCT_COPY_FILES += \
    packages/services/Car/car_product/init/init.bootstat.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.bootstat.rc \
    packages/services/Car/car_product/init/init.car.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.car.rc \

# ONLY devices that meet the CDD's requirements may declare these features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.type.automotive.xml

# Add Google prebuilt services
PRODUCT_PACKAGES += \
    HeadUnit \
    privapp_permissions_google_auto

# Add Car related HAL
PRODUCT_PACKAGES += \
    libion \
    vehicle.default \
    android.hardware.automotive.vehicle@2.0-service

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

