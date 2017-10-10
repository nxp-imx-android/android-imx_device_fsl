# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	if [ "$(strip $(2))" == "imx8qm" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
	elif [ "$(strip $(2))" == "imx8qxp" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8qx`; \
	fi; \
	cp  out/target/product/arm2_8q/obj/BOOTLOADER_OBJ/u-boot.$(strip $(1)) external/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
	cp  device/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin external/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
	cp  device/fsl-proprietary/uboot-firmware/imx8q/bl31-$(strip $(2)).bin external/imx-mkimage/$$MKIMAGE_PLATFORM/bl31.bin; \
	$(MAKE) -C external/imx-mkimage/ clean; \
	$(MAKE) -C external/imx-mkimage/ SOC=$$MKIMAGE_PLATFORM flash; \
	cp external/imx-mkimage/$$MKIMAGE_PLATFORM/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx;
endef


