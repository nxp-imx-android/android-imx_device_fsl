$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic.mk)
$(call inherit-product, $(TOPDIR)frameworks/base/data/sounds/AllAudio.mk)

# overrides
PRODUCT_BRAND := freescale
PRODUCT_MANUFACTUER := freescale
PRODUCT_MODEL := ICS AOSP on imx6q

# Android infrastructures
PRODUCT_PACKAGES += \
	LiveWallpapers				\
	LiveWallpapersPicker			\
	MagicSmokeWallpapers			\
	Gallery2				\
	SoundRecorder				\
        Camera                                  \
	FSLOta					\
	VideoEditor				\
	VisualizationWallpapers			\
	CubeLiveWallpapers			\
	PinyinIME				\
    libjni_pinyinime        \
	libRS					\
	librs_jni				\
	pppd					\
	chat					\
	ip-up-vpn				\
	ip-up-ppp0				\
	ip-down-ppp0				\
	wpa_supplicant				\
	wpa_supplicant.conf			\
	wpa_supplicant_p2p.conf			\
	dispd					\
	ts_calibrator				\
	libion                                  \
       display_mode.conf

# Debug utils
PRODUCT_PACKAGES += \
	busybox					\
	bash					\
	taskset					\
	sqlite3					\
	powerdebug

# Wifi AP mode
PRODUCT_PACKAGES += \
	hostapd 		\
	hostapd_cli		\
	hostapd_client          \
	hostapd.conf		\
	hostapd_wps		\
	libhostapd_client	\
	wmiconfig		\

# keyboard mapping files.
PRODUCT_PACKAGES +=				\
	Dell_Dell_USB_Keyboard.kcm			\
	mxckpd.kcm					\

#audio related lib
PRODUCT_PACKAGES +=		    \
	audio.sabresd_reva.freescale \
	audio.sabresd_revb.freescale \
	audio.legacy.freescale \
	alsa_aplay             \
	alsa_arecord	\
	alsa_amixer     \
	alsa_ctl        \
	libtinyalsa \
	libaudioutils

# imx6 Hardware HAL libs.
PRODUCT_PACKAGES +=				\
	sensors.freescale					\
	overlay.imx6					\
	lights.freescale				\
	gralloc.imx6					\
	copybit.imx6					\
	alsa.freescale					\
	audio.primary.freescale			\
	hwcomposer.imx6             \
	camera.imx6                 \
	magd

# Bluetooth firmware files.
PRODUCT_PACKAGES +=				\
	ar3kbdaddr.pst					\
	PS_ASIC.pst					\
	RamPatch.txt					\

# Freescale VPU firmware files.
PRODUCT_PACKAGES +=				\
	libvpu					\
	vpu_fw_imx6q.bin			\
	vpu_fw_imx6d.bin			\

# Atheros wifi firmwre files.
PRODUCT_PACKAGES +=				\
	fw-3                    \
	bdata                   \
	softmac                     \
	athtcmd_ram             \
	nullTestFlow            \
	cfg80211.ko             \
	compat.ko               \
	ath6kl_sdio.ko          \
	check_wifi_mac.sh


# gps related lib
PRODUCT_PACKAGES += \
	gps.default	\
	Orion.ini \
	AR1520A-Auto.img \
	ingsvcd \
	libOrionCtl.so \
	OrionSys.so

# drm related lib
PRODUCT_PACKAGES += \
	drmserver                   \
	libdrmframework_jni         \
	libdrmframework             \
	libdrmpassthruplugin        \
	libfwdlockengine            \

# Omx related libs, please align to device/fsl/proprietary/omx/fsl-omx.mk
omx_libs :=						\
	core_register					\
	component_register				\
	contentpipe_register				\
	fslomx.cfg					\
	media_profiles.xml				\
	ComponentRegistry.txt				\
	lib_omx_player_arm11_elinux			 \
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
	lib_ogg_parser_arm11_elinux.3.0		\
	libfslxec					\
	lib_omx_overlay_render_arm11_elinux             \
	lib_omx_fsl_muxer_v2_arm11_elinux \
	lib_omx_mp3_enc_v2_arm11_elinux \
	lib_omx_amr_enc_v2_arm11_elinux \
	lib_omx_android_audio_source_arm11_elinux \
	lib_omx_camera_source_arm11_elinux \
	lib_mp4_muxer_arm11_elinux \
	lib_mp3_enc_v2_arm12_elinux \
	lib_nb_amr_enc_v2_arm11_elinux \
	lib_omx_vpu_enc_v2_arm11_elinux \
	lib_ffmpeg_arm11_elinux	\
	lib_omx_https_pipe_v2_arm11_elinux \
	lib_omx_streaming_parser_arm11_elinux \
	lib_omx_surface_render_arm11_elinux \
	libfsl_jpeg_enc_arm11_elinux \
	lib_wb_amr_enc_arm11_elinux \
	lib_wb_amr_dec_arm9_elinux \
	lib_omx_aac_enc_v2_arm11_elinux

# Omx excluded libs
omx_excluded_libs :=					\
	lib_asf_parser_arm11_elinux.3.0			\
	lib_wma10_dec_v2_arm12_elinux.so		\
	lib_WMV789_dec_v2_arm11_elinux.so		\
	lib_aacplus_dec_v2_arm11_elinux			\
	lib_ac3_dec_v2_arm11_elinux			\
	\
	lib_omx_wma_dec_v2_arm11_elinux			\
	lib_omx_wmv_dec_v2_arm11_elinux			\
	lib_omx_ac3_dec_v2_arm11_elinux			\


PRODUCT_PACKAGES += $(omx_libs) $(omx_excluded_libs)

PRODUCT_PACKAGES += libubi ubinize ubiformat ubiattach ubidetach ubiupdatevol ubimkvol ubinfo mkfs.ubifs

# e2fsprogs libs
PRODUCT_PACKAGES += \
	mke2fs		\
	libext2_blkid	\
	libext2_com_err	\
	libext2_e2p	\
	libext2_profile	\
	libext2_uuid	\
	libext2fs

PRODUCT_LOCALES += hdpi mdpi

PRODUCT_COPY_FILES +=	\
	device/fsl/imx6/Dell_Dell_USB_Keyboard.kl:system/usr/keylayout/Dell_Dell_USB_Keyboard.kl \
	device/fsl/imx6/Dell_Dell_USB_Keyboard.idc:system/usr/idc/Dell_Dell_USB_Keyboard.idc \
	device/fsl/imx6/init.rc:root/init.rc \
    device/fsl/imx6/apns-conf.xml:system/etc/apns-conf.xml

# for all other directory
PRODUCT_COPY_FILES +=	\
	device/fsl/imx6/ueventd.freescale.rc:root/ueventd.freescale.rc \
	device/fsl/imx6/init.gprs-pppd:system/etc/init.gprs-pppd \
	device/fsl/imx6/ota.conf:system/etc/ota.conf

# for property
PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
	persist.sys.usb.config=mtp

# include a google recommand heap config file.
include frameworks/base/build/tablet-dalvik-heap.mk
