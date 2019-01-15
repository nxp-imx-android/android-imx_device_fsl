# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash
ATF_TOOLCHAIN_ABS := $(realpath prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/bin)
ATF_CROSS_COMPILE := $(ATF_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-
MCU_SDK_IMX8QM_DEMO_PATH := $(IMX_MCU_SDK_PATH)/mcu-sdk-auto/SDK_MEK-MIMX8QM/boards/mekmimx8qm/demo_apps/rear_view_camera/cm4_core1/armgcc
MCU_SDK_IMX8QM_CMAKE_FILE := ../../../../../../tools/cmake_toolchain_files/armgcc.cmake
MCU_SDK_IMX8QX_DEMO_PATH := $(IMX_MCU_SDK_PATH)/mcu-sdk-auto/SDK_MEK-MIMX8QX/boards/mekmimx8qx/demo_apps/rear_view_camera/armgcc
MCU_SDK_IMX8QX_CMAKE_FILE := ../../../../../tools/cmake_toolchain_files/armgcc.cmake

UBOOT_M4_OUT := $(TARGET_OUT_INTERMEDIATES)/MCU_OBJ

define build_M4_image
	mkdir -p $(UBOOT_M4_OUT)/$2; \
	cmake -DCMAKE_TOOLCHAIN_FILE="$4" -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=$3 -S $1 -B $(UBOOT_M4_OUT)/$2; \
	$(MAKE) -C $(UBOOT_M4_OUT)/$2
endef

ifeq ($(PRODUCT_IMX_CAR_M4_BUILD),true)
ifeq ($(ARMGCC_DIR),)
$(error please install arm-none-eabi-gcc toolchain and set the installed path to ARMGCC_DIR)
endif

$(UBOOT_M4_OUT):
	rm -rf $@
	mkdir -p $@

UBOOT_M4_BIN: $(UBOOT_M4_OUT)
	$(hide) echo "Building M4 image for UBoot ..."
	cmake_version=$(shell cmake --version | head -n 1 | tr " " "\n" | tail -n 1); \
	req_version="3.13.0"; \
	if [ "$(shell echo "$$cmake_version $$req_version" | tr " " "\n" | sort -V | head -n 1)" != "$$req_version" ]; then \
		echo "please upgrade cmake version to 3.13.0 or newer"; \
		exit 1; \
	fi; \
	$(call build_M4_image,$(MCU_SDK_IMX8QM_DEMO_PATH),MIMX8QM,ddr_release,$(MCU_SDK_IMX8QM_CMAKE_FILE)); \
	$(call build_M4_image,$(MCU_SDK_IMX8QX_DEMO_PATH),MIMX8QX,ddr_release,$(MCU_SDK_IMX8QX_CMAKE_FILE))
else
UBOOT_M4_BIN:
endif # PRODUCT_IMX_CAR_M4_BUILD

define build_imx_uboot
	if [ `echo $(2) | cut -d '-' -f1` == "imx8qm" ] && [ `echo $(2) | cut -d '-' -f2` != "xen" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
		ATF_PLATFORM=`echo imx8qm`; \
		cp  $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qm-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mx8qm-ahab-container.img; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
		if [ "$(PRODUCT_IMX_CAR)" != "true" ] || [ `echo $(2) | rev | cut -d '-' -f1` == "uuu" ]; then \
			if [ "$(strip $(2))" == "imx8qm" ]; then\
				FLASH_TARGET=`echo flash_b0_spl_container`;  \
			else \
				FLASH_TARGET=`echo flash_b0`;  \
			fi; \
			cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmitxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
			cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmirxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
			fi; \
		else \
			if [ "$(PRODUCT_IMX_CAR_M4)" == "true" ] ; then \
				FLASH_TARGET=`echo flash_b0_spl_container_m4_1_trusty`;  \
				cp  $(UBOOT_M4_OUT)/MIMX8QM/release/m4_image.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m41_tcm.bin; \
			else \
				FLASH_TARGET=`echo flash_b0_spl_container_trusty`;  \
			fi; \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
			fi; \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
			fi; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/tee-imx8qm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		fi; \
	elif [ "$(strip $(2))" == "imx8qm-xen-dom0" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
		ATF_PLATFORM=`echo imx8qm`; \
		cp  $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qm-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mx8qm-ahab-container.img; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
		FLASH_TARGET=`echo flash_b0_multi_cores_m4_1`;  \
		cp  $(UBOOT_M4_OUT)/MIMX8QM/release/m4_image.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m41_tcm.bin; \
	elif [ `echo $(2) | cut -d '-' -f1` == "imx8qxp" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8qx`; \
		ATF_PLATFORM=`echo imx8qxp`; \
		cp  $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/seco/mx8qx-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mx8qx-ahab-container.img; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
		if [ `echo $(2) | rev | cut -d '-' -f1` == "uuu" ]; then \
			FLASH_TARGET=`echo flash_b0_all`;  \
		else \
			FLASH_TARGET=`echo flash_all_spl_container`;  \
		fi; \
		if [ "$(PRODUCT_IMX_CAR)" == "true" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
		    if [ "$(PRODUCT_IMX_CAR_M4)" == "true" ] ; then \
				cp  $(UBOOT_M4_OUT)/MIMX8QX/release/rear_view_camera.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
			else \
				cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
			fi; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/tee-imx8qxp.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		else \
			if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
			fi; \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/CM4.bin; \
		fi; \
	fi; \
	if [ "$(strip $(2))" != "imx8qm-xen" ]; then \
		$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ PLAT=$$ATF_PLATFORM clean; \
		if [ "$(PRODUCT_IMX_CAR)" == "true" ] && [ "$(strip $(2))" != "imx8qm-xen-dom0" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=$$ATF_PLATFORM bl31 SPD=trusty -B; \
		else \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=$$ATF_PLATFORM bl31 -B; \
		fi; \
		cp $(IMX_PATH)/arm-trusted-firmware/build/$$ATF_PLATFORM/release/bl31.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/bl31.bin; \
		cp  $(UBOOT_OUT)/u-boot.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
		if [ "$(strip $(2))" != "imx8qm-xen-dom0" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
			cp  $(UBOOT_OUT)/spl/u-boot-spl.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot-spl.bin; \
		fi; \
		cp  $(UBOOT_OUT)/tools/mkimage  $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mkimage_uboot; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$$MKIMAGE_PLATFORM $$FLASH_TARGET || exit 1; \
		cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/flash.bin $(PRODUCT_OUT)/u-boot-$(strip $(2)).imx; \
	fi;
endef


