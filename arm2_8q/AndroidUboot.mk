# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	if [ "$(strip $(2))" == "imx8qm" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
	elif [ "$(strip $(2))" == "imx8qxp" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8qxp`; \
	fi; \
	cp  out/target/product/arm2_8q/obj/BOOTLOADER_OBJ/u-boot.$(strip $(1)) external/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
	cp  external/linux-firmware-imx/firmware/scfw_tcm/scfw_tcm_$$SCFW_PLATFORM.bin external/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
	$(MAKE) -C external/imx-mkimage/$$MKIMAGE_PLATFORM/ clean; \
	$(MAKE) -C external/imx-mkimage/$$MKIMAGE_PLATFORM/ flash; \
	cp external/imx-mkimage/$$MKIMAGE_PLATFORM/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx;
endef


