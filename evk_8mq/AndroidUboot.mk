# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

define build_uboot
	cp out/target/product/evk_8mq/obj/BOOTLOADER_OBJ/u-boot-nodtb.$(strip $(1)) external/imx-mkimage/iMX8M/.; \
	cp out/target/product/evk_8mq/obj/BOOTLOADER_OBJ/spl/u-boot-spl.bin  external/imx-mkimage/iMX8M/.; \
	cp out/target/product/evk_8mq/obj/BOOTLOADER_OBJ/tools/mkimage  external/imx-mkimage/iMX8M/mkimage_uboot; \
	cp out/target/product/evk_8mq/obj/BOOTLOADER_OBJ/arch/arm/dts/fsl-imx8mq-evk.dtb  external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/signed_hdmi_imx8m.bin  external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_1d_dmem.bin external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_1d_imem.bin external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_2d_dmem.bin external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/lpddr4_pmu_train_2d_imem.bin external/imx-mkimage/iMX8M/.; \
	cp device/fsl-proprietary/uboot-firmware/imx8m/bl31.bin external/imx-mkimage/iMX8M/.; \
	$(MAKE) -C external/imx-mkimage/ clean; \
	$(MAKE) -C external/imx-mkimage/ SOC=iMX8M  flash_hdmi_spl_uboot; \
	cp external/imx-mkimage/iMX8M/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx;
endef


