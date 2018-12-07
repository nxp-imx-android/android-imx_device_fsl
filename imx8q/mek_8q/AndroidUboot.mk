# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash
ATF_TOOLCHAIN_ABS := $(realpath prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/bin)
ATF_CROSS_COMPILE := $(ATF_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-

define build_imx_uboot
	if [ `echo $(2) | cut -d '-' -f1` == "imx8qm" ] && [ `echo $(2) | cut -d '-' -f2` != "xen" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
		cp  $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qm-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mx8qm-ahab-container.img; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
		if [ "$(PRODUCT_IMX_CAR)" != "true" ] || [ `echo $(2) | rev | cut -d '-' -f1` == "uuu" ]; then \
			if [ "$(strip $(2))" == "imx8qm" ]; then\
				FLASH_TARGET=`echo flash_b0_spl_container`;  \
			else \
				FLASH_TARGET=`echo flash_b0`;  \
			fi; \
			cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmitxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
			cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmirxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
			fi; \
		else \
			if [ "$(PRODUCT_IMX_CAR_M4)" == "true" ] ; then \
				FLASH_TARGET=`echo flash_b0_spl_container_m4_1_trusty`;  \
				cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qm_m4_1_tcm_auto.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m41_tcm.bin; \
			else \
				FLASH_TARGET=`echo flash_b0_spl_container_trusty`;  \
			fi; \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
			fi; \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
			fi; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/tee-imx8qm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		fi; \
	elif [ `echo $(2) | cut -d '-' -f1` == "imx8qxp" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8qx`; \
		cp  $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qx-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mx8qx-ahab-container.img; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
		if [ `echo $(2) | rev | cut -d '-' -f1` == "uuu" ]; then \
			FLASH_TARGET=`echo flash_b0_all`;  \
		else \
			FLASH_TARGET=`echo flash_all_spl_container`;  \
		fi; \
		if [ "$(PRODUCT_IMX_CAR)" == "true" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
		    if [ "$(PRODUCT_IMX_CAR_M4)" == "true" ] ; then \
				cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_tcm_auto.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
			else \
				cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
			fi; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/tee-imx8qxp.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		else \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
			fi; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
		fi; \
	fi; \
	if [ "$(strip $(2))" != "imx8qm-xen" ]; then \
		$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ PLAT=`echo $(2) | cut -d '-' -f1` clean; \
		if [ "$(PRODUCT_IMX_CAR)" == "true" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=`echo $(2) | cut -d '-' -f1` bl31 SPD=trusty -B; \
		else \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=`echo $(2) | cut -d '-' -f1` bl31 -B; \
		fi; \
		cp $(IMX_PATH)/arm-trusted-firmware/build/`echo $(2) | cut -d '-' -f1`/release/bl31.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/bl31.bin; \
		cp  $(UBOOT_OUT)/u-boot.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
		cp  $(UBOOT_OUT)/spl/u-boot-spl.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot-spl.bin; \
		cp  $(UBOOT_OUT)/tools/mkimage  $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mkimage_uboot; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$$MKIMAGE_PLATFORM $$FLASH_TARGET; \
		cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx; \
	fi;
endef


