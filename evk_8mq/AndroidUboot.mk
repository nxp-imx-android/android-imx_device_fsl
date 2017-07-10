# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	cp bootable/bootloader/uboot-imx/u-boot.$(strip $(1)) external/imx-mkimage/iMX8M/u-boot.bin; \
	cp bootable/bootloader/uboot-imx/spl/u-boot-spl.bin  external/imx-mkimage/iMX8M/.; \
	$(MAKE) -C external/imx-mkimage/iMX8M/ clean; \
	$(MAKE) -C external/imx-mkimage/iMX8M/ flash_spl_uboot; \
	cp external/imx-mkimage/iMX8M/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx;
endef


