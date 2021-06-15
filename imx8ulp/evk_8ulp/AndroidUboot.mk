# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash
MKIMAGE_SOC := iMX8ULP
BOARD_MKIMAGE_PATH := $(IMX_MKIMAGE_PATH)/imx-mkimage/$(MKIMAGE_SOC)

ifneq ($(AARCH64_GCC_CROSS_COMPILE),)
  ATF_CROSS_COMPILE := $(strip $(AARCH64_GCC_CROSS_COMPILE))
else
  $(error shell env AARCH64_GCC_CROSS_COMPILE is not set)
endif

define build_imx_uboot
	$(hide) echo Building i.MX U-Boot with firmware; \
	cp $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8ulp/imx8ulp_mcu_demo.img $(BOARD_MKIMAGE_PATH)/m33_image.bin; \
	cp $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8ulp/upower.bin $(BOARD_MKIMAGE_PATH); \
	cp $(FSL_PROPRIETARY_PATH)/sentinel/mx8ulpa0-ahab-container.img $(BOARD_MKIMAGE_PATH); \
	cp $(UBOOT_OUT)/u-boot.$(strip $(1)) $(BOARD_MKIMAGE_PATH); \
	cp $(UBOOT_OUT)/spl/u-boot-spl.bin  $(BOARD_MKIMAGE_PATH); \
	cp $(UBOOT_OUT)/tools/mkimage  $(BOARD_MKIMAGE_PATH)/mkimage_uboot; \
	$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ PLAT=`echo $(2) | cut -d '-' -f1` clean; \
	if [ `echo $(2) | cut -d '-' -f2` = "trusty" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
		cp $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8ulp/tee-imx8ulp.bin $(BOARD_MKIMAGE_PATH)/tee.bin; \
		if [ `echo $(2) | cut -d '-' -f3` = "4g" ]; then \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=`echo $(2) | cut -d '-' -f1` bl31 -B BL32_BASE=0xfe000000 SPD=trusty 1>/dev/null || exit 1; \
		else \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=`echo $(2) | cut -d '-' -f1` bl31 -B SPD=trusty 1>/dev/null || exit 1; \
		fi; \
	else \
		if [ -f $(BOARD_MKIMAGE_PATH)/tee.bin ] ; then \
			rm -rf $(BOARD_MKIMAGE_PATH)/tee.bin; \
		fi; \
		$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=`echo $(2) | cut -d '-' -f1` bl31 -B 1>/dev/null || exit 1; \
	fi; \
	cp $(IMX_PATH)/arm-trusted-firmware/build/`echo $(2) | cut -d '-' -f1`/release/bl31.bin $(BOARD_MKIMAGE_PATH)/bl31.bin; \
	$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
	$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$(MKIMAGE_SOC) flash_singleboot_m33 || exit 1; \
	if [ `echo $(2) | rev | cut -d '-' -f1 | rev` != "dual" ]; then \
		cp $(BOARD_MKIMAGE_PATH)/flash.bin $(UBOOT_COLLECTION)/u-boot-$(strip $(2)).imx; \
	else \
		cp $(BOARD_MKIMAGE_PATH)/flash.bin $(UBOOT_COLLECTION)/spl-$(strip $(2)).bin; \
		cp $(BOARD_MKIMAGE_PATH)/u-boot-ivt.itb $(UBOOT_COLLECTION)/bootloader-$(strip $(2)).img; \
	fi;
endef


