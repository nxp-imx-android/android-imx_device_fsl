$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

# overrides
PRODUCT_BRAND := Freescale
PRODUCT_MANUFACTURER := Freescale

# Android infrastructures
PRODUCT_PACKAGES += \
	LiveWallpapers				\
	LiveWallpapersPicker			\
	MagicSmokeWallpapers			\
	VisualizationWallpapers			\
	Galaxy4					\
	NoiseField				\
	PhaseBeam				\
	HoloSpiralWallpaper			\
	Gallery2				\
	LegacyCamera				\
	SoundRecorder				\
	FSLOta					\
	VideoEditor				\
	Email					\
	PinyinIME				\
	librs_jni				\
	pppd					\
	chat					\
	setup_fs				\
	ip-up-vpn				\
	ip-up-ppp0				\
	ip-down-ppp0				\
	wpa_supplicant				\
	wpa_supplicant.conf			\
	wpa_supplicant_p2p.conf			\
	dispd					\
	ts_calibrator				\
	libion

# Debug utils
PRODUCT_PACKAGES += \
	busybox					\
	bash					\
	taskset					\
	sqlite3					\
	powerdebug

# Wifi AP mode
PRODUCT_PACKAGES += \
	hostapd					\
	hostapd_cli

# keyboard mapping files.
PRODUCT_PACKAGES += \
	Dell_Dell_USB_Keyboard.kcm		\
	mxckpd.kcm				\

#audio related lib
PRODUCT_PACKAGES += \
	audio.primary.imx5x			\
	audio.usb.default			\
	audio.a2dp.default			\
	tinyplay				\
	tinycap					\
	tinymix					\
	libsrec_jni				\
	libtinyalsa 				\
	libaudioutils

# imx5x Hardware HAL libs.
PRODUCT_PACKAGES += \
	sensors.SMD				\
	overlay.imx5x				\
	lights.imx5x				\
	gralloc.imx5x				\
	copybit.imx5x				\
	hwcomposer.imx5x				\
	camera.imx5x					\
	power.imx5x				\
	libbt-vendor				\
	bt_vendor.conf				\
	audio.r_submix.default			\
	magd

# Bluetooth firmware files.
PRODUCT_PACKAGES += \
	ar3kbdaddr_ar3001			\
	PS_ASIC_ar3001				\
	RamPatch_ar3001				\
	ar3kbdaddr_ar3002			\
	PS_ASIC_ar3002				\
	RamPatch_ar3002

# Freescale VPU firmware files.
PRODUCT_PACKAGES += \
	libvpu					\
	vpu_fw_imx51.bin			\
	vpu_fw_imx53.bin			\

# Atheros wifi firmwre files.
PRODUCT_PACKAGES += \
	fw-3					\
	bdata					\
	athtcmd_ram				\
	nullTestFlow				\
	cfg80211.ko				\
	compat.ko				\
	ath6kl_sdio.ko				\
	check_wifi_mac.sh

# Atheros wifi tool
PRODUCT_PACKAGES += \
	abtfilt					\
	artagent				\
	ath6kl-fwlog-record			\
	athtestcmd				\
	psatUtil				\
	wmiconfig

# Intel PCIE wifi firmware
PRODUCT_PACKAGES += \
	iwlwifi-6000-4.ucode			\
	iwlwifi-5000-5.ucode			\
	iwlagn.ko

# gpu related libs. align to device/fsl-proprietary/gpu/fsl-gpu.mk
PRODUCT_PACKAGES += \
	libEGL_imx51.so				\
	libGLESv1_CM_imx51.so			\
	libGLESv2_imx51.so			\
	egl.cfg					\
	libgsl-fsl				\
	libc2d_z160				\
	libc2d_z430				\

# gps related lib
PRODUCT_PACKAGES += \
	gps.SMD 				\
	Orion.ini 				\
	AR1520A-Auto.img 			\
	ingsvcd					\
	libOrionCtl.so 				\
	OrionSys.so

# drm related lib
PRODUCT_PACKAGES += \
	drmserver				\
	libdrmframework_jni			\
	libdrmframework				\
	libdrmpassthruplugin			\
	libfwdlockengine

# Omx related libs, please align to device/fsl/proprietary/omx/fsl-omx.mk
omx_libs := \
	core_register					\
	component_register				\
	contentpipe_register				\
	fslomx.cfg					\
	media_profiles.xml				\
	media_codecs.xml				\
	ComponentRegistry.txt				\
	lib_omx_player_arm11_elinux			\
	lib_omx_client_arm11_elinux			\
	lib_omx_core_mgr_v2_arm11_elinux		\
	lib_omx_core_v2_arm11_elinux			\
	lib_omx_osal_v2_arm11_elinux			\
	lib_omx_common_v2_arm11_elinux			\
	lib_omx_utils_v2_arm11_elinux			\
	lib_omx_res_mgr_v2_arm11_elinux			\
	lib_omx_clock_v2_arm11_elinux			\
	lib_omx_local_file_pipe_v2_arm11_elinux		\
	lib_omx_shared_fd_pipe_arm11_elinux		\
	lib_omx_https_pipe_arm11_elinux			\
	lib_omx_fsl_parser_v2_arm11_elinux		\
	lib_omx_wav_parser_v2_arm11_elinux		\
	lib_omx_mp3_parser_v2_arm11_elinux		\
	lib_omx_aac_parser_v2_arm11_elinux		\
	lib_omx_flac_parser_v2_arm11_elinux		\
	lib_omx_pcm_dec_v2_arm11_elinux			\
	lib_omx_mp3_dec_v2_arm11_elinux			\
	lib_omx_aac_dec_v2_arm11_elinux			\
	lib_omx_amr_dec_v2_arm11_elinux			\
	lib_omx_vorbis_dec_v2_arm11_elinux		\
	lib_omx_flac_dec_v2_arm11_elinux		\
	lib_omx_audio_processor_v2_arm11_elinux		\
	lib_omx_sorenson_dec_v2_arm11_elinux		\
	lib_omx_android_audio_render_arm11_elinux	\
	lib_omx_audio_fake_render_arm11_elinux		\
	lib_omx_ipulib_render_arm11_elinux		\
	lib_omx_https_pipe_v3_arm11_elinux		\
	lib_omx_udps_pipe_arm11_elinux			\
	lib_omx_rtps_pipe_arm11_elinux			\
	lib_avi_parser_arm11_elinux.3.0			\
	lib_divx_drm_arm11_elinux			\
	lib_mp4_parser_arm11_elinux.3.0			\
	lib_mkv_parser_arm11_elinux.3.0			\
	lib_flv_parser_arm11_elinux.3.0			\
	lib_id3_parser_arm11_elinux			\
	lib_wav_parser_arm11_elinux			\
	lib_mp3_parser_v2_arm11_elinux			\
	lib_aac_parser_arm11_elinux			\
	lib_flac_parser_arm11_elinux			\
	lib_mp3_dec_v2_arm12_elinux			\
	lib_aac_dec_v2_arm12_elinux			\
	lib_flac_dec_v2_arm11_elinux			\
	lib_nb_amr_dec_v2_arm9_elinux			\
	lib_oggvorbis_dec_v2_arm11_elinux		\
	lib_peq_v2_arm11_elinux				\
	lib_mpg2_parser_arm11_elinux.3.0		\
	libstagefrighthw				\
	libxec						\
	lib_omx_vpu_v2_arm11_elinux			\
	lib_omx_vpu_dec_v2_arm11_elinux			\
	lib_vpu_wrapper					\
	lib_ogg_parser_arm11_elinux.3.0			\
	libfslxec					\
	lib_omx_overlay_render_arm11_elinux		\
	lib_omx_fsl_muxer_v2_arm11_elinux		\
	lib_omx_mp3_enc_v2_arm11_elinux			\
	lib_omx_amr_enc_v2_arm11_elinux			\
	lib_omx_android_audio_source_arm11_elinux	\
	lib_omx_camera_source_arm11_elinux		\
	lib_mp4_muxer_arm11_elinux			\
	lib_mp3_enc_v2_arm12_elinux			\
	lib_nb_amr_enc_v2_arm11_elinux			\
	lib_omx_vpu_enc_v2_arm11_elinux			\
	lib_ffmpeg_arm11_elinux				\
	lib_omx_https_pipe_v2_arm11_elinux		\
	lib_omx_streaming_parser_arm11_elinux		\
	lib_omx_surface_render_arm11_elinux		\
	libfsl_jpeg_enc_arm11_elinux			\
	lib_wb_amr_enc_arm11_elinux			\
	lib_wb_amr_dec_arm9_elinux			\
	lib_omx_aac_enc_v2_arm11_elinux \
	lib_amr_parser_arm11_elinux.3.0 \
	lib_aac_parser_arm11_elinux.3.0 \
	lib_aacd_wrap_arm12_elinux_android \
	lib_mp3d_wrap_arm12_elinux_android \
	lib_vorbisd_wrap_arm11_elinux_android \
	lib_mp3_parser_arm11_elinux.3.0 \
	lib_flac_parser_arm11_elinux.3.0 \
	lib_wav_parser_arm11_elinux.3.0 \
	lib_omx_ac3toiec937_arm11_elinux \


# Omx excluded libs
omx_excluded_libs :=					\
	lib_asf_parser_arm11_elinux.3.0			\
	lib_wma10_dec_v2_arm12_elinux			\
	lib_WMV789_dec_v2_arm11_elinux			\
	lib_aacplus_dec_v2_arm11_elinux			\
	lib_ac3_dec_v2_arm11_elinux			\
	lib_omx_wma_dec_v2_arm11_elinux			\
	lib_omx_wmv_dec_v2_arm11_elinux			\
	lib_omx_ac3_dec_v2_arm11_elinux			\
	lib_wma10d_wrap_arm12_elinux_android \
	lib_aacplusd_wrap_arm12_elinux_android \
	lib_ac3d_wrap_arm11_elinux_android \

PRODUCT_PACKAGES += $(omx_libs) $(omx_excluded_libs)

PRODUCT_PACKAGES += libubi ubinize ubiformat ubiattach ubidetach ubiupdatevol ubimkvol ubinfo mkfs.ubifs

# FUSE based emulated sdcard daemon
PRODUCT_PACKAGES += sdcard

# ntfs-3g binary
PRODUCT_PACKAGES += \
	ntfs-3g		\
	ntfsfix

# for CtsVerifier
PRODUCT_PACKAGES += \
    com.android.future.usb.accessory

PRODUCT_AAPT_CONFIG := normal xlarge mdpi

PRODUCT_COPY_FILES +=	\
	device/fsl/common/input/Dell_Dell_USB_Keyboard.kl:system/usr/keylayout/Dell_Dell_USB_Keyboard.kl \
	device/fsl/common/input/Dell_Dell_USB_Keyboard.idc:system/usr/idc/Dell_Dell_USB_Keyboard.idc \
	device/fsl/imx5x/init.rc:root/init.rc \
	device/fsl/imx5x/layout_version:root/layout_version \
	device/fsl/imx5x/apns-conf.xml:system/etc/apns-conf.xml \
	device/fsl/imx5x/init.freescale.usb.rc:root/init.freescale.usb.rc \
	device/fsl/imx5x/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/fsl/imx5x/init.gprs-pppd:system/etc/ppp/init.gprs-pppd \
	device/fsl/imx5x/initlogo.rle:root/initlogo.rle

# VPU firmware
PRODUCT_COPY_FILES +=	\
	external/linux-firmware-imx/firmware/vpu/vpu_fw_imx53.bin:system/lib/firmware/vpu/vpu_fw_imx53.bin

PRODUCT_TAGS += dalvik.gc.type-precise

# for property
PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
	persist.sys.usb.config=mtp

PRODUCT_DEFAULT_DEV_CERTIFICATE := \
        device/fsl/common/security/testkey

# include a google recommand heap config file.
include frameworks/native/build/tablet-7in-hdpi-1024-dalvik-heap.mk

