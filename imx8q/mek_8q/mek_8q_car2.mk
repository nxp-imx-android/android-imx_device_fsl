# This is a FSL Android Reference Design platform based on i.MX8QM/8QXP MEK board
# It will inherit from NXP core product which in turn inherit from Google generic

IMX_DEVICE_PATH := device/fsl/imx8q/mek_8q

# the env setting in mek_8q_car to make the build without M4 image
PRODUCT_IMX_CAR_M4 := false

include $(IMX_DEVICE_PATH)/mek_8q_car.mk

# Overrides
PRODUCT_NAME := mek_8q_car2
