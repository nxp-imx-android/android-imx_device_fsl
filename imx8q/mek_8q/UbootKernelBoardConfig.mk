TARGET_BOOTLOADER_POSTFIX := bin
UBOOT_POST_PROCESS := true

ifeq ($(PRODUCT_IMX_CAR),true)
  ifeq ($(PRODUCT_IMX_CAR_M4),true)
    # u-boot target for imx8qm_mek auto android
    TARGET_BOOTLOADER_CONFIG := imx8qm:imx8qm_mek_androidauto_trusty_defconfig
    # imx8qm auto android with secure unlock feature enabled
    TARGET_BOOTLOADER_CONFIG += imx8qm-secure-unlock:imx8qm_mek_androidauto_trusty_secure_unlock_defconfig
    # u-boot target for imx8qxp_mek auto android
    TARGET_BOOTLOADER_CONFIG += imx8qxp:imx8qxp_mek_androidauto_trusty_defconfig
    TARGET_BOOTLOADER_CONFIG += imx8qxp-c0:imx8qxp_mek_androidauto_trusty_defconfig
    # imx8qxp auto android with secure unlock feature enabled
    TARGET_BOOTLOADER_CONFIG += imx8qxp-secure-unlock:imx8qxp_mek_androidauto_trusty_secure_unlock_defconfig
  else
    # u-boot target for imx8qm_mek auto android
    TARGET_BOOTLOADER_CONFIG := imx8qm:imx8qm_mek_androidauto2_trusty_defconfig
    ifneq ($(IMX_NO_PRODUCT_PARTITION),true)
      # u-boot target for imx8qm_mek auto android with multi-display
      TARGET_BOOTLOADER_CONFIG += imx8qm-md:imx8qm_mek_androidauto2_trusty_md_defconfig
    endif
    # u-boot target for imx8qxp_mek auto android
    TARGET_BOOTLOADER_CONFIG += imx8qxp:imx8qxp_mek_androidauto2_trusty_defconfig
    TARGET_BOOTLOADER_CONFIG += imx8qxp-c0:imx8qxp_mek_androidauto2_trusty_defconfig
  endif #PRODUCT_IMX_CAR_M4
else
  # u-boot target for imx8qm_mek standard android
  TARGET_BOOTLOADER_CONFIG := imx8qm:imx8qm_mek_android_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8qm-dual:imx8qm_mek_android_dual_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8qm-hdmi:imx8qm_mek_android_hdmi_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8qm-md:imx8qm_mek_android_hdmi_defconfig
  # u-boot target for imx8qxp_mek standard android
  TARGET_BOOTLOADER_CONFIG += imx8qxp:imx8qxp_mek_android_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8qxp-dual:imx8qxp_mek_android_dual_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8qxp-c0:imx8qxp_mek_android_defconfig
  TARGET_BOOTLOADER_CONFIG += imx8qxp-c0-dual:imx8qxp_mek_android_dual_defconfig
  # u-boot target for imx8dx_mek standard android
  TARGET_BOOTLOADER_CONFIG += imx8dx:imx8dx_mek_android_defconfig
  # u-boot target used by uuu for imx8dx_mek
  TARGET_BOOTLOADER_CONFIG += imx8dx-mek-uuu:imx8dx_mek_android_uuu_defconfig

  ifeq ($(PRODUCT_IMX_TRUSTY),true)
    # u-boot target for imx8qm_mek standard android with trusty support
    TARGET_BOOTLOADER_CONFIG += imx8qm-trusty-dual:imx8qm_mek_android_trusty_dual_defconfig
    TARGET_BOOTLOADER_CONFIG += imx8qm-trusty-secure-unlock-dual:imx8qm_mek_android_trusty_secure_unlock_dual_defconfig
    # u-boot target for imx8qxp_mek standard android with trusty support
    TARGET_BOOTLOADER_CONFIG += imx8qxp-trusty-dual:imx8qxp_mek_android_trusty_dual_defconfig
    TARGET_BOOTLOADER_CONFIG += imx8qxp-trusty-c0-dual:imx8qxp_mek_android_trusty_dual_defconfig
    TARGET_BOOTLOADER_CONFIG += imx8qxp-trusty-secure-unlock-dual:imx8qxp_mek_android_trusty_secure_unlock_dual_defconfig
  endif
endif #PRODUCT_IMX_CAR

# u-boot target used by uuu for imx8qm_mek
TARGET_BOOTLOADER_CONFIG += imx8qm-mek-uuu:imx8qm_mek_android_uuu_defconfig
# u-boot target used by uuu for imx8qxp_mek
TARGET_BOOTLOADER_CONFIG += imx8qxp-mek-uuu:imx8qxp_mek_android_uuu_defconfig
TARGET_BOOTLOADER_CONFIG += imx8qxp-mek-c0-uuu:imx8qxp_mek_android_uuu_defconfig

ifeq ($(PRODUCT_IMX_CAR),true)
  ifeq ($(PRODUCT_IMX_CAR_M4),true)
    TARGET_KERNEL_ADDITION_DEFCONF := automotive_addition_car_defconfig
  else
    TARGET_KERNEL_ADDITION_DEFCONF := automotive_addition_car2_defconfig
  endif # PRODUCT_IMX_CAR_M4
  TARGET_KERNEL_DEFCONFIG := gki_defconfig
  TARGET_KERNEL_GKI_DEFCONF:= imx8q_car_gki.fragment
else
  TARGET_KERNEL_DEFCONFIG := gki_defconfig
  TARGET_KERNEL_GKI_DEFCONF:= imx8q_gki.fragment
endif # PRODUCT_IMX_CAR

# absolute path is used, not the same as relative path used in AOSP make
TARGET_DEVICE_DIR := $(patsubst %/, %, $(dir $(realpath $(lastword $(MAKEFILE_LIST)))))

# define rollback index in container
ifeq ($(PRODUCT_IMX_CAR),true)
  BOOTLOADER_RBINDEX ?= 0
endif

ifeq ($(TARGET_PRODUCT),mek_8q_car)
  export PRODUCT_IMX_DUAL_BOOTLOADER
endif

export IMX8QM_A72_BOOT
export PRODUCT_IMX_CAR
export PRODUCT_IMX_CAR_M4

