# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	dd if=bootable/bootloader/uboot-imx/SPL of=bootable/bootloader/uboot-imx/uboot.tmp; \
	dd if=bootable/bootloader/uboot-imx/u-boot.img of=bootable/bootloader/uboot-imx/uboot.tmp bs=1k seek=351; \
	cp bootable/bootloader/uboot-imx/uboot.tmp $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx; \
	rm bootable/bootloader/uboot-imx/uboot.tmp;
endef


