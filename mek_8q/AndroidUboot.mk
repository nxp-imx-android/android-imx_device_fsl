# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	if [ "$(strip $(2))" == "imx8qm" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
		if [ "$(PRODUCT_IMX_CAR)" != "true" ]; then \
			cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmitxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
		elif [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin ]; then \
			rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
		fi; \
	elif [ "$(strip $(2))" == "imx8qxp" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8qx`; \
	fi; \
	cp  out/target/product/mek_8q/obj/BOOTLOADER_OBJ/u-boot.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
	cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
	cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/bl31-$(strip $(2)).bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/bl31.bin; \
	$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
	$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$$MKIMAGE_PLATFORM flash; \
	cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx;
endef


