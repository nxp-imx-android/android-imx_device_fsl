#
# Product-specific compile-time definitions.
#

IMX_DEVICE_PATH := device/fsl/imx8q/mek_8q

include device/fsl/imx8q/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_aacp_dec/imx_dsp_aacp_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_codec/imx_dsp_codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp/imx_dsp.mk
endif

BUILD_TARGET_FS ?= ext4
TARGET_USERIMAGES_USE_EXT4 := true

ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale.car
else
TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.freescale
endif # PRODUCT_IMX_CAR

# Support gpt
BOARD_BPT_INPUT_FILES += device/fsl/common/partition/device-partitions-13GB-ab.bpt
ADDITION_BPT_PARTITION = partition-table-7GB:device/fsl/common/partition/device-partitions-7GB-ab.bpt \
                         partition-table-28GB:device/fsl/common/partition/device-partitions-28GB-ab.bpt


# Vendor Interface Manifest
ifeq ($(PRODUCT_IMX_CAR),true)
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest_car.xml
else
DEVICE_MANIFEST_FILE := $(IMX_DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(IMX_DEVICE_PATH)/compatibility_matrix.xml
endif

TARGET_BOOTLOADER_BOARD_NAME := MEK

PRODUCT_MODEL := MEK-MX8Q

TARGET_BOOTLOADER_POSTFIX := bin

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

BOARD_WLAN_DEVICE            := qcwcn
WPA_SUPPLICANT_VERSION       := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB               := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_PRIVATE_LIB        := lib_driver_cmd_$(BOARD_WLAN_DEVICE)

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

BOARD_VENDOR_KERNEL_MODULES += \
                            $(KERNEL_OUT)/drivers/net/wireless/qcacld-2.0/wlan.ko

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_VENDOR_KERNEL_MODULES += \
                            $(KERNEL_OUT)/drivers/extcon/extcon-ptn5150.ko \
                            $(KERNEL_OUT)/drivers/hid/usbhid/usbhid.ko \
                            $(KERNEL_OUT)/drivers/staging/typec/tcpci.ko \
                            $(KERNEL_OUT)/drivers/staging/typec/tcpm.ko \
                            $(KERNEL_OUT)/drivers/usb/cdns3/cdns3.ko \
                            $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc.ko \
                            $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc_imx.ko \
                            $(KERNEL_OUT)/drivers/usb/chipidea/usbmisc_imx.ko \
                            $(KERNEL_OUT)/drivers/usb/core/usbcore.ko \
                            $(KERNEL_OUT)/drivers/usb/host/xhci-hcd.ko \
                            $(KERNEL_OUT)/drivers/usb/host/ehci-hcd.ko \
                            $(KERNEL_OUT)/drivers/usb/storage/usb-storage.ko \
                            $(KERNEL_OUT)/drivers/usb/typec/typec.ko \
                            $(KERNEL_OUT)/drivers/scsi/sd_mod.ko \
                            $(KERNEL_OUT)/drivers/bluetooth/mx8_bt_rfkill.ko \
                            $(KERNEL_OUT)/drivers/hid/hid-multitouch.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/imx8_prg.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/imx8_dprc.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/imx8_pc.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/dpu-blit/imx-dpu-blit.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/imx/dpu/imx-dpu-render.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/dpu/imx-dpu-core.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/imx/dpu/imx-dpu-crtc.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/bridge/nwl-dsi.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/imx/nwl_dsi-imx.ko \
                            $(KERNEL_OUT)/drivers/media/platform/imx8/max9286_gmsl.ko \
                            $(KERNEL_OUT)/drivers/media/platform/imx8/mxc-mipi-csi2.ko \
                            $(KERNEL_OUT)/drivers/media/platform/imx8/mxc-media-dev.ko \
                            $(KERNEL_OUT)/drivers/media/platform/imx8/mxc-capture.ko \

BOARD_RECOVERY_KERNEL_MODULES += \
                            $(KERNEL_OUT)/drivers/gpu/imx/imx8_prg.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/imx8_dprc.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/imx8_pc.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/dpu-blit/imx-dpu-blit.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/imx/dpu/imx-dpu-render.ko \
                            $(KERNEL_OUT)/drivers/gpu/imx/dpu/imx-dpu-core.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/imx/dpu/imx-dpu-crtc.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/bridge/nwl-dsi.ko \
                            $(KERNEL_OUT)/drivers/gpu/drm/imx/nwl_dsi-imx.ko
endif

# Qcom 1CQ(QCA6174) BT
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(IMX_DEVICE_PATH)/bluetooth
BOARD_HAVE_BLUETOOTH_QCOM := true
BOARD_HAS_QCA_BT_ROME := true
BOARD_HAVE_BLUETOOTH_BLUEZ := false
QCOM_BT_USE_SIBS := true
ifeq ($(QCOM_BT_USE_SIBS), true)
    WCNSS_FILTER_USES_SIBS := true
endif

# sensor configs
BOARD_USE_SENSOR_FUSION := true
BOARD_USE_SENSOR_PEDOMETER := false
ifeq ($(PRODUCT_IMX_CAR),true)
    BOARD_USE_LEGACY_SENSOR := false
else
    BOARD_USE_LEGACY_SENSOR :=true
endif

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false

UBOOT_POST_PROCESS := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

# whether to accelerate camera service with openCL
# it will make camera service load the opencl lib in vendor
# and break the full treble rule
# OPENCL_2D_IN_CAMERA := true

USE_ION_ALLOCATOR := true
USE_GPU_ALLOCATOR := false

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 5

ifeq ($(PRODUCT_IMX_CAR),true)
KERNEL_NAME := Image.lz4
else
KERNEL_NAME := Image
endif

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_KERNEL_CMDLINE := init=/init consoleblank=0 androidboot.hardware=freescale androidboot.fbTileSupport=enable cma=800M@0x960M-0xe00M androidboot.primary_display=imx-drm firmware_class.path=/vendor/firmware
else
BOARD_KERNEL_CMDLINE := init=/init androidboot.console=ttyLP0 consoleblank=0 androidboot.hardware=freescale androidboot.fbTileSupport=enable cma=800M@0x960M-0xe00M androidboot.primary_display=imx-drm firmware_class.path=/vendor/firmware
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

BOARD_PREBUILT_DTBOIMAGE := out/target/product/mek_8q/dtbo-imx8qm.img
ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_BOARD_DTS_CONFIG := imx8qm:fsl-imx8qm-mek-car.dtb imx8qm-xen:fsl-imx8qm-mek-domu.dtb imx8qxp:fsl-imx8qxp-mek-car.dtb
TARGET_BOOTLOADER_CONFIG := imx8qm:imx8qm_mek_androidauto_trusty_defconfig imx8qm-xen:imx8qm_mek_androidauto_xen_defconfig imx8qxp:imx8qxp_mek_androidauto_trusty_defconfig
else
TARGET_BOARD_DTS_CONFIG := imx8qm:fsl-imx8qm-mek-mipi-two-ov5640.dtb imx8qm-hdmi:fsl-imx8qm-mek-hdmi.dtb imx8qxp:fsl-imx8qxp-mek-ov5640.dtb imx8qxp-ov5640mipi:fsl-imx8qxp-mek-mipi-ov5640.dtb
TARGET_BOOTLOADER_CONFIG := imx8qm:imx8qm_mek_android_defconfig imx8qxp:imx8qxp_mek_android_defconfig
endif #PRODUCT_IMX_CAR

ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_KERNEL_DEFCONFIG := android_car_defconfig
include $(IMX_DEVICE_PATH)/build_id_car.mk
else
TARGET_KERNEL_DEFCONFIG := android_defconfig
include $(IMX_DEVICE_PATH)/build_id.mk
endif # PRODUCT_IMX_CAR
# TARGET_KERNEL_ADDITION_DEFCONF := android_addition_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8q/sepolicy \
       $(IMX_DEVICE_PATH)/sepolicy

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_SEPOLICY_DIRS += \
     packages/services/Car/car_product/sepolicy \
     packages/services/Car/evs/sepolicy \
     device/fsl/imx8q/sepolicy_car \
     device/generic/car/common/sepolicy
endif

ifeq ($(PRODUCT_IMX_CAR),true)
TARGET_BOARD_RECOVERY_FORMAT_SKIP := true
TARGET_BOARD_RECOVERY_SBIN_SKIP := true
endif

BOARD_AVB_ENABLE := true
TARGET_USES_MKE2FS := true

TARGET_BOARD_KERNEL_HEADERS := device/fsl/common/kernel-headers

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_HAVE_IMX_EVS := true
endif
