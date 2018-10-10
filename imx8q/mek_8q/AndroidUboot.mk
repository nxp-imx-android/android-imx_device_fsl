# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_imx_uboot
	if [ "$(strip $(2))" == "imx8qm" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
		cp  $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qm-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mx8qm-ahab-container.img; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
		if [ "$(PRODUCT_IMX_CAR)" != "true" ]; then \
			FLASH_TARGET=`echo flash_b0`;  \
			cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmitxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
			cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmirxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
		else \
			FLASH_TARGET=`echo flash_b0_multi_cores_m4_1_trusty`;  \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
			fi; \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
			fi; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qm_m4_1_tcm_auto.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m41_tcm.bin; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/tee-imx8qm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		fi; \
	elif [ "$(strip $(2))" == "imx8qxp" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8qx`; \
		cp  $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qx-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mx8qx-ahab-container.img; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
		if [ "$(PRODUCT_IMX_CAR)" == "true" ]; then \
			FLASH_TARGET=`echo flash_b0_all_trusty`;  \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_tcm_auto.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/tee-imx8qxp.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		else \
			FLASH_TARGET=`echo flash_b0_all`;  \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
		fi; \
	fi; \
	if [ "$(strip $(2))" != "imx8qm-xen" ]; then \
		cp  $(UBOOT_OUT)/u-boot.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
		if [ "$(PRODUCT_IMX_CAR)" == "true" ]; then \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/bl31-$(strip $(2))-trusty.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/bl31.bin; \
		else \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/bl31-$(strip $(2)).bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/bl31.bin; \
		fi; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$$MKIMAGE_PLATFORM $$FLASH_TARGET; \
		cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx; \
	fi;
endef


