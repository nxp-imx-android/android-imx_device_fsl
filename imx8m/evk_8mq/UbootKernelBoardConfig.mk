TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

# u-boot target for imx8mq_evk
TARGET_BOOTLOADER_CONFIG := imx8mq:imx8mq_evk_android_defconfig
TARGET_BOOTLOADER_CONFIG += imx8mq-dual:imx8mq_evk_android_dual_defconfig
ifeq ($(PRODUCT_IMX_TRUSTY),true)
  TARGET_BOOTLOADER_CONFIG += imx8mq-trusty:imx8mq_evk_android_trusty_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8mq-trusty-secure-unlock:imx8mq_evk_android_trusty_secure_unlock_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8mq-trusty-dual:imx8mq_evk_android_trusty_dual_defconfig
endif

# u-boot target used by uuu for imx8mq_evk
TARGET_BOOTLOADER_CONFIG += imx8mq-evk-uuu:imx8mq_evk_android_uuu_defconfig

TARGET_KERNEL_DEFCONFIG := imx_v8_android_defconfig
# TARGET_KERNEL_ADDITION_DEFCONF ?= android_addition_defconfig


# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define bootloader rollback index
BOOTLOADER_RBINDEX ?= 0

