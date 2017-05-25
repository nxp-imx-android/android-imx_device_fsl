# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	cp  bootable/bootloader/uboot-imx/u-boot.$(strip $(1)) external/imx-mkimage/iMX8QM/u-boot.bin; \
	cp  external/linux-firmware-imx/firmware/scfw_tcm/scfw_tcm.bin external/imx-mkimage/iMX8QM/scfw_tcm.bin; \
	$(MAKE) -C external/imx-mkimage/iMX8QM/ clean; \
	$(MAKE) -C external/imx-mkimage/iMX8QM/ flash; \
	cp external/imx-mkimage/iMX8QM/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx;
endef


