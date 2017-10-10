# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	cp out/target/product/evk_8mq/obj/BOOTLOADER_OBJ/u-boot.$(strip $(1)) external/imx-mkimage/iMX8M/u-boot.bin; \
	cp out/target/product/evk_8mq/obj/BOOTLOADER_OBJ/spl/u-boot-spl.bin  external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/hdmi_imx8m.bin external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_imem.bin external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_dmem.bin external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/bl31.bin external/imx-mkimage/iMX8M/.; \
	$(MAKE) -C external/imx-mkimage/ clean; \
	$(MAKE) -C external/imx-mkimage/ SOC=iMX8M  flash_hdmi_spl_uboot; \
	cp external/imx-mkimage/iMX8M/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx;
endef


