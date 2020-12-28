$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
ifeq ($(PRODUCT_IMX_CAR),true)
$(call inherit-product, packages/services/Car/car_product/build/car.mk)
endif
ifneq ($(TARGET_PRODUCT),mek_8q_car)
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
endif
$(call inherit-product, $(TOPDIR)frameworks/base/data/sounds/AllAudio.mk)

# Installs gsi keys into ramdisk.
$(call inherit-product, $(SRC_TARGET_DIR)/product/developer_gsi_keys.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)
PRODUCT_PACKAGES += \
    adb_debug.prop

# overrides
PRODUCT_BRAND := Android
PRODUCT_MANUFACTURER := nxp

# related to the definition and load of library modules
TARGET_BOARD_PLATFORM := imx

# Android infrastructures
PRODUCT_PACKAGES += \
    CactusPlayer \
    SystemUpdaterSample \
    MultiClientInputMethod \
    charger_res_images \
    charger \
    libedid \
    libion


ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    MultiDisplay
else
PRODUCT_PACKAGES += \
    MultiDisplaySecondaryHomeTestLauncher
endif

ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    CubeLiveWallpapers \
    ethernet \
    Gallery2 \
    LiveWallpapersPicker \
    SoundRecorder
endif

# HAL
PRODUCT_PACKAGES += \
    gralloc.imx \
    hwcomposer.imx

# A/B OTA
PRODUCT_PACKAGES += \
    android.hardware.boot@1.1-impl \
    android.hardware.boot@1.1-impl.recovery \
    android.hardware.boot@1.1-service \
    update_engine \
    update_engine_client \
    update_verifier

PRODUCT_PACKAGES += \
    update_engine_sideload

PRODUCT_HOST_PACKAGES += \
    brillo_update_payload \
    nxp.hardware.display@1.0

# audio
PRODUCT_PACKAGES += \
    audio.a2dp.default \
    audio.primary.imx \
    audio.r_submix.default \
    audio.usb.default \
    tinycap \
    tinymix \
    tinyplay \
    tinypcminfo

# LDAC codec
PRODUCT_PACKAGES += \
    libldacBT_enc \
    libldacBT_abr

# wifi
PRODUCT_PACKAGES += \
    hostapd \
    hostapd_cli \
    wpa_supplicant \
    wpa_supplicant.conf

PRODUCT_PACKAGES += \
    netutils-wrapper-1.0

# sensor
PRODUCT_PACKAGES += \
    fsl_sensor_fusion \
    libbt-vendor

# memtrack
PRODUCT_PACKAGES += \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    memtrack.imx

# health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-service \
    android.hardware.health@2.1-impl-imx

# Support Dynamic partition userspace fastboot
PRODUCT_PACKAGES += \
    fastbootd

# camera
ifneq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.6-service-google \
    android.hardware.camera.provider@2.6-impl-google \
    libgooglecamerahal \
    libgooglecamerahalutils \
    lib_profiler \
    libimxcamerahwl_impl

PRODUCT_PACKAGES += \
    android.hardware.camera.provider@2.4-external-service \
    android.hardware.camera.provider@2.4-impl \
    camera.device@1.0-impl \
    camera.device@3.2-impl
endif

ifeq ($(PRODUCT_IMX_CAR),true)
PRODUCT_PACKAGES += \
    android.hardware.automotive.evs@1.1-EvsEnumeratorHw

PRODUCT_PACKAGES += \
    evs_service
endif

# display
PRODUCT_PACKAGES += \
    libdrm_android \
    libfsldisplay

# drm
PRODUCT_PACKAGES += \
    libdrmpassthruplugin \
    libfwdlockengine

# vivante libdrm support
PRODUCT_PACKAGES += \
    libdrm_vivante

# gpu debug tool
PRODUCT_PACKAGES += \
    gmem_info \
    gpu-top

# Omx related libs, please align to device/nxp/proprietary/omx/fsl-omx.mk
PRODUCT_PACKAGES += \
    lib_aac_dec_v2_arm12_elinux \
    lib_aacd_wrap_arm12_elinux_android \
    lib_mp3_dec_v2_arm12_elinux \
    lib_mp3d_wrap_arm12_elinux_android \
    media_codecs.xml \
    media_codecs_performance.xml \
    media_codecs_c2_ac3.xml \
    media_codecs_c2_ddp.xml \
    media_codecs_c2_ms.xml \
    media_codecs_c2_wmv9.xml \
    media_codecs_c2_ra.xml \
    media_codecs_c2_rv.xml \
    media_codecs_c2_dsp.xml \
    media_codecs_c2_dsp_aacp.xml \
    media_codecs_c2_dsp_wma.xml \
    media_profiles_V1_0.xml \
    media_codecs_c2.xml \
    media_codecs_performance_c2.xml \


#parser
PRODUCT_PACKAGES += \
    libimxextractor \
    lib_aac_parser_arm11_elinux.3.0 \
    lib_amr_parser_arm11_elinux.3.0 \
    lib_avi_parser_arm11_elinux.3.0 \
    lib_dsf_parser_arm11_elinux.3.0 \
    lib_flac_parser_arm11_elinux.3.0 \
    lib_flv_parser_arm11_elinux.3.0 \
    lib_mkv_parser_arm11_elinux.3.0 \
    lib_mp3_parser_arm11_elinux.3.0 \
    lib_mp4_parser_arm11_elinux.3.0 \
    lib_mpg2_parser_arm11_elinux.3.0 \
    lib_ogg_parser_arm11_elinux.3.0 \

# Omx excluded libs
PRODUCT_PACKAGES += \
    lib_aacplus_dec_v2_arm11_elinux \
    lib_aacplusd_wrap_arm12_elinux_android \
    lib_ac3_dec_v2_arm11_elinux \
    lib_ac3d_wrap_arm11_elinux_android \
    lib_asf_parser_arm11_elinux.3.0 \
    lib_ddpd_wrap_arm12_elinux_android \
    lib_ddplus_dec_v2_arm12_elinux \
    lib_dsp_aac_dec \
    lib_dsp_bsac_dec \
    lib_dsp_codec_wrap \
    lib_dsp_mp3_dec \
    lib_dsp_mp3_dec_ext \
    lib_dsp_codec_wrap_ext \
    lib_dsp_wrap_arm12_android \
    lib_aacd_wrap_dsp \
    lib_mp3d_wrap_dsp \
    lib_wma10d_wrap_dsp \
    lib_realad_wrap_arm11_elinux_android \
    lib_realaudio_dec_v2_arm11_elinux \
    lib_rm_parser_arm11_elinux.3.0 \
    lib_wma10_dec_v2_arm12_elinux \
    lib_wma10d_wrap_arm12_elinux_android

# imx c2 codec binary
PRODUCT_PACKAGES += \
    android.hardware.media.c2@1.0-service \
    libsfplugin_ccodec \
    lib_imx_c2_componentbase \
    lib_imx_c2_videodec_common \
    lib_imx_c2_videodec \
    lib_imx_c2_videoenc_common \
    lib_imx_c2_videoenc \
    lib_imx_c2_v4l2_dev \
    lib_imx_c2_v4l2_dec \
    lib_imx_c2_v4l2_enc \
    lib_imx_c2_process \
    lib_imx_c2_process_isi_pre \
    lib_imx_c2_process_g2d_post \
    lib_c2_imx_store \
    lib_c2_imx_audio_dec_common \
    lib_c2_imx_aac_dec \
    lib_c2_imx_ac3_dec \
    lib_c2_imx_eac3_dec \
    lib_c2_imx_mp3_dec \
    lib_c2_imx_ra_dec \
    lib_c2_imx_wma_dec \
    c2_component_register \
    c2_component_register_ms \
    c2_component_register_wmv9 \
    c2_component_register_rv \
    c2_component_register_ra \
    c2_component_register_dsp \
    c2_component_register_dsp_wma \
    c2_component_register_dsp_aacp

# vndservicemanager
PRODUCT_PACKAGES += \
    vndservicemanager

# Copy soc related config and binary to board
PRODUCT_COPY_FILES += \
    device/nxp/common/input/Dell_Dell_USB_Entry_Keyboard.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Dell_Dell_USB_Entry_Keyboard.idc \
    device/nxp/common/input/Dell_Dell_USB_Keyboard.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Dell_Dell_USB_Keyboard.idc \
    device/nxp/common/input/Dell_Dell_USB_Keyboard.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Dell_Dell_USB_Keyboard.kl \
    device/nxp/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/HannStar_P1003_Touchscreen.idc \
    device/nxp/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/Novatek_NT11003_Touch_Screen.idc \
    device/nxp/common/input/eGalax_Touch_Screen.idc:$(TARGET_COPY_OUT_VENDOR)/usr/idc/eGalax_Touch_Screen.idc \
    device/nxp/imx8m/com.example.android.systemupdatersample.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/com.example.android.systemupdatersample.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \

PRODUCT_PROPERTY_OVERRIDES += \
    pm.dexopt.boot=quicken

# wifionly device
PRODUCT_PROPERTY_OVERRIDES += \
    ro.radio.noril=yes

# Set c2 codec in default
PRODUCT_PROPERTY_OVERRIDES += \
    debug.stagefright.ccodec=4  \
    debug.stagefright.omx_default_rank=0x200 \
    debug.stagefright.c2-poolmask=0x70000

# enable incremental installation
PRODUCT_PROPERTY_OVERRIDES += \
    ro.incremental.enable=1

# we have enough storage space to hold precise GC data
PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_DEFAULT_DEV_CERTIFICATE := \
	device/nxp/common/security/testkey

# In userdebug, add minidebug info the the boot image and the system server to support
# diagnosing native crashes.
ifneq (,$(filter userdebug, $(TARGET_BUILD_VARIANT)))
    # Boot image.
    PRODUCT_DEX_PREOPT_BOOT_FLAGS += --generate-mini-debug-info
    # System server and some of its services.
    # Note: we cannot use PRODUCT_SYSTEM_SERVER_JARS, as it has not been expanded at this point.
    $(call add-product-dex-preopt-module-config,services,--generate-mini-debug-info)
    $(call add-product-dex-preopt-module-config,wifi-service,--generate-mini-debug-info)
endif

PRODUCT_AAPT_CONFIG := normal mdpi
PRODUCT_SHIPPING_API_LEVEL := 30

# Enforce privapp-permissions whitelist
PRODUCT_PROPERTY_OVERRIDES += \
    ro.control_privapp_permissions=enforce

#OEM Unlock reporting
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.oem_unlock_supported=1

# include a google recommand heap config file.
include frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk

-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_real_dec/fsl_real_dec.mk
-include $(FSL_RESTRICTED_CODEC_PATH)/fsl-restricted-codec/fsl_ms_codec/fsl_ms_codec.mk

BOARD_SOC_TYPE := IMX8Q
PREBUILT_FSL_IMX_CODEC := true

PRODUCT_SOONG_NAMESPACES += external/mesa3d
