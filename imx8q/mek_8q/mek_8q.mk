# -------@block_infrastructure-------
CONFIG_REPO_PATH := device/nxp
CURRENT_FILE_PATH :=  $(lastword $(MAKEFILE_LIST))
IMX_DEVICE_PATH := $(strip $(patsubst %/, %, $(dir $(CURRENT_FILE_PATH))))

# configs shared between uboot, kernel and Android rootfs
include $(IMX_DEVICE_PATH)/SharedBoardConfig.mk

-include $(CONFIG_REPO_PATH)/common/imx_path/ImxPathConfig.mk

include $(CONFIG_REPO_PATH)/imx8q/ProductConfigCommon.mk

# -------@block_common_config-------
# Overrides
PRODUCT_NAME := mek_8q
PRODUCT_DEVICE := mek_8q
PRODUCT_MODEL := MEK-MX8Q

TARGET_BOOTLOADER_BOARD_NAME := MEK

DEVICE_PACKAGE_OVERLAYS := $(IMX_DEVICE_PATH)/overlay

PRODUCT_CHARACTERISTICS := tablet

PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE := true

ifeq ($(PRODUCT_IMX_CAR),true)
  SOONG_CONFIG_IMXPLUGIN_IMX_CAR = true
else
  SOONG_CONFIG_IMXPLUGIN_IMX_CAR = false
endif

# -------@block_treble-------
PRODUCT_FULL_TREBLE_OVERRIDE := true

# -------@block_power-------
PRODUCT_SOONG_NAMESPACES += vendor/nxp-opensource/imx/power
PRODUCT_SOONG_NAMESPACES += hardware/google/pixel

PRODUCT_COPY_FILES += \
     $(IMX_DEVICE_PATH)/powerhint_imx8qxp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/powerhint_imx8qxp.json \
     $(IMX_DEVICE_PATH)/powerhint_imx8qm.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/powerhint_imx8qm.json

# Charger Mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.charger.no_ui=false

# Do not skip charger_not_need trigger by default
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    vendor.skip.charger_not_need=0

PRODUCT_PACKAGES += \
    android.hardware.power-service.imx

# Thermal HAL
PRODUCT_PACKAGES += \
    android.hardware.thermal@2.0-service.imx

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8qxp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8qxp.json \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8qm.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8qm.json
else
ifneq ($(PRODUCT_IMX_CAR_M4),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8qxp_car2.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8qxp.json \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8qm_car2.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8qm.json
else
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8qxp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8qxp.json \
    $(IMX_DEVICE_PATH)/thermal_info_config_imx8qm.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/thermal_info_config_imx8qm.json
endif
endif

# -------@block_app-------
#Enable this to choose 32 bit user space build
IMX8_BUILD_32BIT_ROOTFS := false

ifneq ($(PRODUCT_IMX_CAR),true)
# Set permission for GMS packages
PRODUCT_COPY_FILES += \
	  $(CONFIG_REPO_PATH)/imx8q/permissions/privapp-permissions-imx.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp.permissions-imx.xml
endif

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/app_whitelist.xml:system/etc/sysconfig/app_whitelist.xml

# -------@block_kernel_bootimg-------
# Enable this to support vendor boot and boot header v3, this would be a MUST for GKI
TARGET_USE_VENDOR_BOOT ?= true

ifneq ($(PRODUCT_IMX_CAR),true)
# We load the fstab from device tree so this is not needed, but since no kernel modules are installed to vendor
# boot ramdisk so far, we need this step to generate the vendor-ramdisk folder or build process would fail. This
# can be deleted once we figure out what kernel modules should be put into the vendor boot ramdisk.
ifeq ($(TARGET_USE_VENDOR_BOOT),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/fstab.nxp:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.nxp
endif
endif

ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/early.init_car.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/early.init.cfg
ifeq ($(PRODUCT_IMX_CAR_M4),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/setup.main.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/setup.main.cfg \
    $(IMX_DEVICE_PATH)/setup.core.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/setup.core.cfg
else
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/setup.main.car2.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/setup.main.cfg \
    $(IMX_DEVICE_PATH)/setup.core.car2.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/setup.core.cfg
endif #PRODUCT_IMX_CAR_M4
else
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/early.init.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/early.init.cfg
endif

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/ueventd.nxp.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    $(CONFIG_REPO_PATH)/common/init/init.insmod.sh:$(TARGET_COPY_OUT_VENDOR)/bin/init.insmod.sh

# -------@block_storage-------
#Enable this to use dynamic partitions for the readonly partitions not touched by bootloader
TARGET_USE_DYNAMIC_PARTITIONS ?= true

ifeq ($(TARGET_USE_DYNAMIC_PARTITIONS),true)
  $(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
  PRODUCT_USE_DYNAMIC_PARTITIONS := true
  BOARD_BUILD_SUPER_IMAGE_BY_DEFAULT := true
  BOARD_SUPER_IMAGE_IN_UPDATE_PACKAGE := true
endif

#Enable this to disable product partition build.
IMX_NO_PRODUCT_PARTITION := false

$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

ifeq ($(PRODUCT_IMX_CAR),true)
  PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/fstab.nxp.car:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.nxp

  TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.nxp.car
else
  PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/fstab.nxp:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.nxp

  TARGET_RECOVERY_FSTAB = $(IMX_DEVICE_PATH)/fstab.nxp
endif

ifneq ($(filter TRUE true 1,$(IMX_OTA_POSTINSTALL)),)
  PRODUCT_PACKAGES += imx_ota_postinstall

  AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/imx_ota_postinstall \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=false

  ifeq ($(OTA_TARGET),8qxp)
    ifneq ($(TARGET_PRODUCT),mek_8q_car)
      PRODUCT_COPY_FILES += \
        $(OUT_DIR)/target/product/$(firstword $(PRODUCT_DEVICE))/obj/UBOOT_COLLECTION/u-boot-imx8qxp.imx:$(TARGET_COPY_OUT_VENDOR)/etc/bootloader0.img
    else
      PRODUCT_COPY_FILES += \
        $(OUT_DIR)/target/product/$(firstword $(PRODUCT_DEVICE))/obj/UBOOT_COLLECTION/spl-imx8qxp.bin:$(TARGET_COPY_OUT_VENDOR)/etc/bootloader0.img
    endif
  else ifeq ($(OTA_TARGET),8qxp-c0)
    ifneq ($(TARGET_PRODUCT),mek_8q_car)
      PRODUCT_COPY_FILES += \
        $(OUT_DIR)/target/product/$(firstword $(PRODUCT_DEVICE))/obj/UBOOT_COLLECTION/u-boot-imx8qxp-c0.imx:$(TARGET_COPY_OUT_VENDOR)/etc/bootloader0.img
    else
      PRODUCT_COPY_FILES += \
        $(OUT_DIR)/target/product/$(firstword $(PRODUCT_DEVICE))/obj/UBOOT_COLLECTION/spl-imx8qxp-c0.bin:$(TARGET_COPY_OUT_VENDOR)/etc/bootloader0.img
    endif
  else
    ifneq ($(TARGET_PRODUCT),mek_8q_car)
      PRODUCT_COPY_FILES += \
        $(OUT_DIR)/target/product/$(firstword $(PRODUCT_DEVICE))/obj/UBOOT_COLLECTION/u-boot-imx8qm.imx:$(TARGET_COPY_OUT_VENDOR)/etc/bootloader0.img
    else
      PRODUCT_COPY_FILES += \
        $(OUT_DIR)/target/product/$(firstword $(PRODUCT_DEVICE))/obj/UBOOT_COLLECTION/spl-imx8qm.bin:$(TARGET_COPY_OUT_VENDOR)/etc/bootloader0.img
    endif
  endif
endif

# fastboot_imx_flashall scripts, imx-sdcard-partition and uuu_imx_android_flash scripts
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/tools/fastboot_imx_flashall.bat:fastboot_imx_flashall.bat \
    $(CONFIG_REPO_PATH)/common/tools/fastboot_imx_flashall.sh:fastboot_imx_flashall.sh \
    $(CONFIG_REPO_PATH)/common/tools/uuu_imx_android_flash.bat:uuu_imx_android_flash.bat \
    $(CONFIG_REPO_PATH)/common/tools/uuu_imx_android_flash.sh:uuu_imx_android_flash.sh

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/tools/imx-sdcard-partition.sh:imx-sdcard-partition.sh
endif

# -------@block_security-------
# Include keystore attestation keys and certificates.
ifeq ($(PRODUCT_IMX_TRUSTY),true)
-include $(IMX_SECURITY_PATH)/attestation/imx_attestation.mk
endif

# Copy rpmb test key and AVB test public key
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/security/rpmb_key_test.bin:rpmb_key_test.bin \
    $(CONFIG_REPO_PATH)/common/security/testkey_public_rsa4096.bin:testkey_public_rsa4096.bin
endif

# hardware backed keymaster service
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-service.trusty
endif
# Keymaster HAL
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.0-service-imx

# new gatekeeper HAL
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.software-imx

# Add Trusty OS backed gatekeeper and secure storage proxy
ifeq ($(PRODUCT_IMX_TRUSTY),true)
PRODUCT_PACKAGES += \
    android.hardware.gatekeeper@1.0-service.trusty \
    storageproxyd
endif

ifeq ($(PRODUCT_IMX_TRUSTY),true)
#Oemlock HAL 1.0 support
PRODUCT_PACKAGES += \
    android.hardware.oemlock@1.0-service.imx
endif

# Add oem unlocking option in settings.
PRODUCT_PROPERTY_OVERRIDES += ro.frp.pst=/dev/block/by-name/presistdata

# Specify rollback index for vbmeta and boot partition
ifneq ($(AVB_RBINDEX),)
BOARD_AVB_ROLLBACK_INDEX := $(AVB_RBINDEX)
else
BOARD_AVB_ROLLBACK_INDEX := 0
endif

ifneq ($(PRODUCT_IMX_CAR),true)
ifneq ($(AVB_BOOT_RBINDEX),)
BOARD_AVB_BOOT_ROLLBACK_INDEX := $(AVB_BOOT_RBINDEX)
else
BOARD_AVB_BOOT_ROLLBACK_INDEX := 0
endif
endif

$(call  inherit-product-if-exists, vendor/nxp-private/security/nxp_security.mk)

# Resume on Reboot support
PRODUCT_PACKAGES += \
    android.hardware.rebootescrow-service.default

PRODUCT_PROPERTY_OVERRIDES += \
    ro.rebootescrow.device=/dev/block/pmem0

#DRM Widevine 1.2 L3 support
PRODUCT_PACKAGES += \
    android.hardware.drm@1.3-service.widevine \
    android.hardware.drm@1.3-service.clearkey \
    libwvdrmcryptoplugin \
    libwvhidl \
    libwvdrmengine

# -------@block_audio-------
# To support multiple pcm device on cs42888, need delete below two lines:
#    $(CONFIG_REPO_PATH)/common/audio-json/wm8960_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/wm8960_config.json \
#    $(CONFIG_REPO_PATH)/common/audio-json/cs42888_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/cs42888_config.json \
# Then add below line:
#    $(CONFIG_REPO_PATH)/common/audio-json/cs42888_multi_device_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/cs42888_config.json \

# Audio card json
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/audio-json/wm8960_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/wm8960_config.json \
    $(CONFIG_REPO_PATH)/common/audio-json/cdnhdmi_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/cdnhdmi_config.json \
    $(CONFIG_REPO_PATH)/common/audio-json/btsco_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/btsco_config.json \
    $(CONFIG_REPO_PATH)/common/audio-json/readme.txt:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/readme.txt

ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/audio-json/cs42888_car_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/cs42888_config.json
else
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/audio-json/cs42888_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/audio/cs42888_config.json
endif

PRODUCT_PACKAGES += \
    android.hardware.audio@6.0-impl:32 \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@6.0-impl:32

ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/audio_effects_car.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(IMX_DEVICE_PATH)/audio_policy_configuration_car.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(IMX_DEVICE_PATH)/car_audio_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/car_audio_configuration.xml
else
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/audio_effects.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(IMX_DEVICE_PATH)/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml
endif

# AudioControl service
ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    android.hardware.automotive.audiocontrol@2.0-service
endif

# -------@block_camera-------
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/camera_config_imx8qm.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/camera_config_imx8qm.json \
    $(IMX_DEVICE_PATH)/camera_config_imx8qxp.json:$(TARGET_COPY_OUT_VENDOR)/etc/configs/camera_config_imx8qxp.json \
    $(IMX_DEVICE_PATH)/external_camera_config.xml:$(TARGET_COPY_OUT_VENDOR)/etc/external_camera_config.xml

PRODUCT_SOONG_NAMESPACES += hardware/google/camera
PRODUCT_SOONG_NAMESPACES += vendor/nxp-opensource/imx/camera

PRODUCT_PACKAGES += \
        imx_evs_app \
        imx_evs_app_default_resources

# -------@block_display-------
PRODUCT_AAPT_CONFIG += xlarge large tvdpi hdpi xhdpi xxhdpi

# HWC2 HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.composer@2.4-service

# define frame buffer count
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.surface_flinger.max_frame_buffer_acquired_buffers=3

# Gralloc HAL
PRODUCT_PACKAGES += \
    android.hardware.graphics.mapper@4.0-impl.imx \
    android.hardware.graphics.allocator@4.0-service.imx

# RenderScript HAL
PRODUCT_PACKAGES += \
    android.hardware.renderscript@1.0-impl

PRODUCT_PACKAGES += \
        libg2d-dpu \
        libg2d-opencl

# In user build, the Cluster display is not included in
# packages/services/Car/car_product/build/car.mk. Here add it back for testing
ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    DirectRenderingCluster
endif

ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/car_display_settings.xml:$(TARGET_COPY_OUT_VENDOR)/etc/display_settings.xml
endif

ifeq ($(PRODUCT_IMX_CAR),true)
  PRODUCT_CUSTOM_RECOVERY_DENSITY := ldpi
endif

PRODUCT_COPY_FILES += \
    vendor/nxp/linux-firmware-imx/firmware/hdmi/cadence/hdmitxfw.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/hdmitxfw.bin

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/input-port-associations.xml:$(TARGET_COPY_OUT_VENDOR)/etc/input-port-associations.xml
# -------@block_gpu-------
PRODUCT_PACKAGES += \
        libEGL_VIVANTE \
        libGLESv1_CM_VIVANTE \
        libGLESv2_VIVANTE \
        gralloc_viv.$(TARGET_BOARD_PLATFORM) \
        libGAL \
        libGLSLC \
        libVSC \
        libg2d-viv \
        libgpuhelper \
        libSPIRV_viv \
        libvulkan_VIVANTE \
        vulkan.$(TARGET_BOARD_PLATFORM) \
        libCLC \
        libLLVM_viv \
        libOpenCL \
        libOpenVX \
        libOpenVXU \
        libNNVXCBinary-evis \
        libNNVXCBinary-evis2 \
        libNNVXCBinary-lite \
        libOvx12VXCBinary-evis \
        libOvx12VXCBinary-evis2 \
        libOvx12VXCBinary-lite \
        libNNGPUBinary-evis \
        libNNGPUBinary-evis2 \
        libNNGPUBinary-lite \
        libNNGPUBinary-ulite \
        libNNArchPerf \
        libarchmodelSw

# GPU openCL g2d
PRODUCT_COPY_FILES += \
    $(IMX_PATH)/imx/opencl-2d/cl_g2d.cl:$(TARGET_COPY_OUT_VENDOR)/etc/cl_g2d.cl

# GPU openCL SDK header file
-include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/include/CL/cl_sdk.mk

# GPU openCL icdloader config file
-include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/gpu-viv/icdloader/icdloader.mk

# GPU openVX SDK header file
-include $(FSL_PROPRIETARY_PATH)/fsl-proprietary/include/nnxc_kernels/nnxc_kernels.mk

# -------@block_vpu-------
# VPU files
PRODUCT_COPY_FILES += \
	$(LINUX_FIRMWARE_IMX_PATH)/linux-firmware-imx/firmware/vpu/vpu_fw_imx8_dec.bin:vendor/firmware/vpu/vpu_fw_imx8_dec.bin \
	$(LINUX_FIRMWARE_IMX_PATH)/linux-firmware-imx/firmware/vpu/vpu_fw_imx8_enc.bin:vendor/firmware/vpu/vpu_fw_imx8_enc.bin

# -------@block_wifi-------
PRODUCT_COPY_FILES += \
    $(CONFIG_REPO_PATH)/common/wifi/p2p_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant_overlay.conf \
    $(CONFIG_REPO_PATH)/common/wifi/wpa_supplicant_overlay.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant_overlay.conf

# WiFi HAL
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0-service \
    wificond

# WiFi RRO
PRODUCT_PACKAGES += \
    WifiOverlay

# NXP 8997 Wifi and Bluetooth Combo Firmware
PRODUCT_COPY_FILES += \
    vendor/nxp/imx-firmware/nxp/FwImage_8997/pcieuart8997_combo_v4.bin:vendor/firmware/pcieuart8997_combo_v4.bin \
    vendor/nxp/imx-firmware/nxp/android_wifi_mod_para.conf:vendor/firmware/wifi_mod_para.conf

# Wifi regulatory
PRODUCT_COPY_FILES += \
    external/wireless-regdb/regulatory.db:vendor/firmware/regulatory.db \
    external/wireless-regdb/regulatory.db.p7s:vendor/firmware/regulatory.db.p7s

# -------@block_bluetooth-------
# Bluetooth HAL
PRODUCT_PACKAGES += \
    android.hardware.bluetooth@1.0-impl \
    android.hardware.bluetooth@1.0-service

# Bluetooth vendor config
PRODUCT_PACKAGES += \
    bt_vendor.conf

# -------@block_usb-------
# Usb HAL
PRODUCT_PACKAGES += \
    android.hardware.usb@1.1-service.imx

PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.usb.rc

# -------@block_multimedia_codec-------
# Vendor seccomp policy files for media components:
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/seccomp/mediaextractor-seccomp.policy:vendor/etc/seccomp_policy/mediaextractor.policy \
    $(IMX_DEVICE_PATH)/seccomp/mediacodec-seccomp.policy:vendor/etc/seccomp_policy/mediacodec.policy \
    $(CONFIG_REPO_PATH)/common/seccomp_policy/codec2.vendor.base.policy:vendor/etc/seccomp_policy/codec2.vendor.base.policy \
    $(CONFIG_REPO_PATH)/common/seccomp_policy/codec2.vendor.ext.policy:vendor/etc/seccomp_policy/codec2.vendor.ext.policy

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
ifneq ($(IMX8_BUILD_32BIT_ROOTFS),true)
INSTALL_64BIT_LIBRARY := true
endif
-include $(FSL_CODEC_PATH)/fsl-codec/fsl-codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_aacp_dec/imx_dsp_aacp_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_codec/imx_dsp_codec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp_wma_dec/imx_dsp_wma_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/imx_dsp/imx_dsp_8q.mk
endif

# -------@block_neural_network-------
# Neural Network HAL and Lib
PRODUCT_PACKAGES += \
    libovxlib \
    libnnrt \
    android.hardware.neuralnetworks@1.2-service-vsi-npu-server

ifneq ($(PRODUCT_IMX_CAR),true)
# Tensorflow lite camera demo
PRODUCT_PACKAGES += \
                    tflitecamerademo
endif

# -------@block_sensor-------
ifeq ($(PRODUCT_IMX_CAR),true)
  SOONG_CONFIG_IMXPLUGIN_BOARD_USE_LEGACY_SENSOR = false
else
  SOONG_CONFIG_IMXPLUGIN_BOARD_USE_LEGACY_SENSOR = true
endif
# imx8 sensor HAL libs.
PRODUCT_PACKAGES += \
        sensors.imx

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service
endif

# -------@block_miscellaneous-------

# Copy device related config and binary to board
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.imx8qm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.imx8qm.rc \
    $(IMX_DEVICE_PATH)/init.imx8qxp.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.imx8qxp.rc

ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init_car.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.rc \
    $(IMX_DEVICE_PATH)/required_hardware_auto.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/required_hardware.xml \
    $(IMX_DEVICE_PATH)/init.recovery.nxp.car.rc:root/init.recovery.nxp.rc

ifeq ($(PRODUCT_IMX_CAR_M4),true)
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init_car_m4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.car_additional.rc
else
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init_car_no_m4.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.car_additional.rc
endif #PRODUCT_IMX_CAR_M4
else
PRODUCT_COPY_FILES += \
    $(IMX_DEVICE_PATH)/init.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.nxp.rc \
    $(IMX_DEVICE_PATH)/required_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/required_hardware.xml \
    $(IMX_DEVICE_PATH)/init.recovery.nxp.rc:root/init.recovery.nxp.rc
endif

# ONLY devices that meet the CDD's requirements may declare these features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.output.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.output.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level-0.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version-1_1.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2020-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level-2020-03-01.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.software.backup.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.software.voice_recognizers.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.voice_recognizers.xml \
    frameworks/native/data/etc/android.software.activities_on_secondary_displays.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.activities_on_secondary_displays.xml \
    frameworks/native/data/etc/android.software.picture_in_picture.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.picture_in_picture.xml

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.ambient_temperature.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.ambient_temperature.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.compass.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.compass.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.camera.external.xml:vendor/etc/permissions/android.hardware.camera.external.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.device_admin.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_admin.xml \
    frameworks/native/data/etc/android.software.managed_users.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.managed_users.xml \
    frameworks/native/data/etc/android.software.print.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.print.xml
endif

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.screen.portrait.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.screen.portrait.xml
endif


ifneq ($(PRODUCT_IMX_CAR),true)
# Included GMS package
$(call inherit-product-if-exists, vendor/partner_gms/products/gms.mk)
PRODUCT_SOONG_NAMESPACES += vendor/partner_gms
else
# Included GAS package
$(call inherit-product-if-exists, vendor/partner_gas/products/gms.mk)
PRODUCT_SOONG_NAMESPACES += vendor/partner_gas
endif

ifeq ($(PRODUCT_IMX_CAR),true)
HAVE_GAS_INTEGRATED := $(shell test -f vendor/partner_gas/products/gms.mk && echo true)
ifneq ($(HAVE_GAS_INTEGRATED),true)
PRODUCT_PACKAGES += \
    CarMapsPlaceholder
endif
endif

