# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

ifneq ($(AARCH64_GCC_CROSS_COMPILE),)
  ATF_CROSS_COMPILE := $(strip $(AARCH64_GCC_CROSS_COMPILE))
else
  $(error shell env AARCH64_GCC_CROSS_COMPILE is not set)
endif

ifeq ($(POWERSAVE),true)
  POWERSAVE_STATE = ENABLE
endif

MCU_SDK_IMX8MP_DEMO_PATH := $(IMX_MCU_SDK_PATH)/mcu-sdk/imx8mp/boards/evkmimx8mp/demo_apps/sai_low_power_audio_low_ddr/armgcc
MCU_SDK_IMX8MP_CMAKE_FILE := ../../../../../tools/cmake_toolchain_files/armgcc.cmake

UBOOT_MCU_OUT := $(TARGET_OUT_INTERMEDIATES)/MCU_OBJ
UBOOT_MCU_BUILD_TYPE := release

define build_mcu_image_core
	mkdir -p $(UBOOT_MCU_OUT)/$2; \
	/usr/local/bin/cmake -DCMAKE_TOOLCHAIN_FILE="$4" -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=$3 -S $1 -B $(UBOOT_MCU_OUT)/$2 1>/dev/null; \
	$(MAKE) -C $(UBOOT_MCU_OUT)/$2 1>/dev/null
endef

ifeq ($(POWERSAVE),true)
ifeq ($(ARMGCC_DIR),)
$(error please install arm-none-eabi-gcc toolchain and set the installed path to ARMGCC_DIR)
endif

define build_m4_image
	rm -rf $(UBOOT_MCU_OUT); \
	mkdir -p $(UBOOT_MCU_OUT); \
	cmake_version=$(shell /usr/local/bin/cmake --version | head -n 1 | tr " " "\n" | tail -n 1); \
	req_version="3.13.0"; \
	if [ "`echo "$$cmake_version $$req_version" | tr " " "\n" | sort -V | head -n 1`" != "$$req_version" ]; then \
		echo "please upgrade cmake version to 3.13.0 or newer"; \
		exit 1; \
	fi; \
	$(call build_mcu_image_core,$(MCU_SDK_IMX8MP_DEMO_PATH),MIMX8MP,$(UBOOT_MCU_BUILD_TYPE),$(MCU_SDK_IMX8MP_CMAKE_FILE)); \
	cp $(MCU_SDK_IMX8MP_DEMO_PATH)/$(UBOOT_MCU_BUILD_TYPE)/*.bin $(PRODUCT_OUT)/imx8mp_mcu_demo.bin
endef
else # POWERSAVE != true
define build_m4_image
	echo "android build without building MCU image"
endef

endif # POWERSAVE

define build_imx_uboot
	$(hide) echo Building i.MX U-Boot with firmware; \
	cp $(UBOOT_OUT)/u-boot-nodtb.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp $(UBOOT_OUT)/spl/u-boot-spl.bin  $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp $(UBOOT_OUT)/tools/mkimage  $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/mkimage_uboot; \
	cp $(UBOOT_OUT)/arch/arm/dts/imx8mp-evk.dtb $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/ddr/synopsys/lpddr4_pmu_train* $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/.; \
	$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ PLAT=`echo $(2) | cut -d '-' -f1` clean; \
	if [ `echo $(2) | cut -d '-' -f2` = "trusty" ]; then \
		cp $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8m/tee-imx8mp.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/tee.bin; \
		$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=`echo $(2) | cut -d '-' -f1` bl31 -B SPD=trusty LPA=$(POWERSAVE_STATE) 1>/dev/null || exit 1; \
	else \
		if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/tee.bin ] ; then \
			rm -rf $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/tee.bin; \
		fi; \
		$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=`echo $(2) | cut -d '-' -f1` bl31 -B LPA=$(POWERSAVE_STATE) 1>/dev/null || exit 1; \
	fi; \
	cp $(IMX_PATH)/arm-trusted-firmware/build/`echo $(2) | cut -d '-' -f1`/release/bl31.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/bl31.bin; \
	$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
	if [ `echo $(2) | rev | cut -d '-' -f1 | rev` = "dual" ]; then \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=iMX8MP flash_evk_no_hdmi_dual_bootloader || exit 1; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=iMX8MP PRINT_FIT_HAB_OFFSET=0x0 print_fit_hab || exit 1; \
		cp $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/flash.bin $(UBOOT_COLLECTION)/spl-$(strip $(2)).bin; \
		cp $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/u-boot-ivt.itb $(UBOOT_COLLECTION)/bootloader-$(strip $(2)).img; \
	else \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=iMX8MP flash_evk || exit 1; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=iMX8MP print_fit_hab || exit 1; \
		cp $(IMX_MKIMAGE_PATH)/imx-mkimage/iMX8M/flash.bin $(UBOOT_COLLECTION)/u-boot-$(strip $(2)).imx; \
	fi;
endef


