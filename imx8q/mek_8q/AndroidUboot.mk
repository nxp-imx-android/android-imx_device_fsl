# uboot.imx in android combine scfw.bin and uboot.bin
MAKE += SHELL=/bin/bash

ifneq ($(AARCH64_GCC_CROSS_COMPILE),)
ATF_CROSS_COMPILE := $(strip $(AARCH64_GCC_CROSS_COMPILE))
else
ATF_TOOLCHAIN_ABS := $(realpath prebuilts/gcc/$(HOST_PREBUILT_TAG)/aarch64/aarch64-linux-android-4.9/bin)
ATF_CROSS_COMPILE := $(ATF_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-
endif

MCU_SDK_IMX8QM_DEMO_PATH := $(IMX_MCU_SDK_PATH)/mcu-sdk-auto/SDK_MEK-MIMX8QM/boards/mekmimx8qm/demo_apps/rear_view_camera/cm4_core1/armgcc
MCU_SDK_IMX8QM_CMAKE_FILE := ../../../../../../tools/cmake_toolchain_files/armgcc.cmake
MCU_SDK_IMX8QX_DEMO_PATH := $(IMX_MCU_SDK_PATH)/mcu-sdk-auto/SDK_MEK-MIMX8QX/boards/mekmimx8qx/demo_apps/rear_view_camera/armgcc
MCU_SDK_IMX8QX_CMAKE_FILE := ../../../../../tools/cmake_toolchain_files/armgcc.cmake
ifeq ($(IMX8QM_A72_BOOT),true)
MCU_SDK_IMX8QM_EXTRA_CONFIG := -DCMAKE_BOOT_FROM_A72=ON
else
MCU_SDK_IMX8QM_EXTRA_CONFIG :=
endif
MCU_SDK_IMX8QX_EXTRA_CONFIG :=

UBOOT_M4_OUT := $(TARGET_OUT_INTERMEDIATES)/MCU_OBJ
UBOOT_M4_BUILD_TYPE := ddr_release

define build_m4_image_core
	mkdir -p $(UBOOT_M4_OUT)/$2; \
	/usr/local/bin/cmake -DCMAKE_TOOLCHAIN_FILE="$4" -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=$3 $5 -S $1 -B $(UBOOT_M4_OUT)/$2 1>/dev/null; \
	$(MAKE) -C $(UBOOT_M4_OUT)/$2 1>/dev/null
endef

ifeq ($(PRODUCT_IMX_CAR_M4),true)
ifeq ($(ARMGCC_DIR),)
$(error please install arm-none-eabi-gcc toolchain and set the installed path to ARMGCC_DIR)
endif

define build_m4_image
	rm -rf $(UBOOT_M4_OUT); \
	mkdir -p $(UBOOT_M4_OUT); \
	cmake_version=$(shell /usr/local/bin/cmake --version | head -n 1 | tr " " "\n" | tail -n 1); \
	req_version="3.13.0"; \
	if [ "`echo "$$cmake_version $$req_version" | tr " " "\n" | sort -V | head -n 1`" != "$$req_version" ]; then \
		echo "please upgrade cmake version to 3.13.0 or newer"; \
		exit 1; \
	fi; \
	$(call build_m4_image_core,$(MCU_SDK_IMX8QM_DEMO_PATH),MIMX8QM,$(UBOOT_M4_BUILD_TYPE),$(MCU_SDK_IMX8QM_CMAKE_FILE),$(MCU_SDK_IMX8QM_EXTRA_CONFIG)); \
	$(call build_m4_image_core,$(MCU_SDK_IMX8QX_DEMO_PATH),MIMX8QX,$(UBOOT_M4_BUILD_TYPE),$(MCU_SDK_IMX8QX_CMAKE_FILE),$(MCU_SDK_IMX8QX_EXTRA_CONFIG))
endef
else
define build_m4_image
	echo "android build without building M4 image"
endef

endif # PRODUCT_IMX_CAR_M4

define build_imx_uboot
	if [ `echo $(2) | cut -d '-' -f1` = "imx8qm" ] && [ `echo $(2) | cut -d '-' -f2` != "xen" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
		ATF_PLATFORM=`echo imx8qm`; \
		REV=`echo B0`;  \
		if [ `echo $(2) | rev | cut -d '-' -f1` = "uuu" ]; then \
			FLASH_TARGET=`echo flash_b0`;  \
		else \
			FLASH_TARGET=`echo flash_linux_m4`;  \
		fi; \
		cp  $(FSL_PROPRIETARY_PATH)/imx-seco/firmware/seco/mx8qm*ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qm_m4_0_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_image.bin; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qm_m4_1_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_1_image.bin; \
		cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmitxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
		cp $(FSL_PROPRIETARY_PATH)/linux-firmware-imx/firmware/hdmi/cadence/hdmirxfw.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
		if [ "$(PRODUCT_IMX_CAR)" = "true" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
			if [ "$(PRODUCT_IMX_CAR_M4)" = "true" ] ; then \
				if [ "$(IMX8QM_A72_BOOT)" = "true" ] ; then \
					FLASH_TARGET=`echo flash_b0_spl_container_m4_1_trusty_a72`;  \
				else \
					FLASH_TARGET=`echo flash_b0_spl_container_m4_1_trusty`;  \
				fi; \
				if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_1_image.bin ]; then \
					rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_1_image.bin; \
				fi; \
				cp  $(UBOOT_M4_OUT)/MIMX8QM/$(UBOOT_M4_BUILD_TYPE)/m4_image.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_1_image.bin; \
			elif [ "$(IMX8QM_A72_BOOT)" = "true" ] ; then \
				FLASH_TARGET=`echo flash_b0_spl_container_m4_0_1_trusty_a72`;  \
			fi; \
			if [ `echo $(2) | cut -d '-' -f2` != "md" ]; then \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmitxfw.bin; \
				rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/hdmirxfw.bin; \
			fi; \
		fi; \
	elif [ "$(strip $(2))" = "imx8qm-xen-dom0" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		SCFW_PLATFORM=`echo 8qm`;  \
		ATF_PLATFORM=`echo imx8qm`; \
		REV=`echo B0`;  \
		cp  $(FSL_PROPRIETARY_PATH)/imx-seco/firmware/seco/mx8qm*ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/; \
		FLASH_TARGET=`echo flash_b0_spl_container_m4_1`;  \
		cp  $(UBOOT_M4_OUT)/MIMX8QM/$(UBOOT_M4_BUILD_TYPE)/m4_image.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_1_image.bin; \
	elif [ "$(strip $(2))" = "imx8qm-xen" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QM`; \
		FLASH_TARGET=`echo flash_b0_xen_uboot`;  \
		REV=`echo B0`;  \
	elif [ `echo $(2) | cut -d '-' -f1` = "imx8qxp" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8qx`; \
		ATF_PLATFORM=`echo imx8qx`; \
		if [ `echo $(2) | cut -d '-' -f2` = "c0" ] || [ `echo $(2) | cut -d '-' -f3` = "c0" ]; then \
			REV=`echo C0`;  \
		else \
			REV=`echo B0`;  \
		fi; \
		if [ `echo $(2) | rev | cut -d '-' -f1` = "uuu" ]; then \
			FLASH_TARGET=`echo flash`;  \
		else \
			FLASH_TARGET=`echo flash_linux_m4`;  \
		fi; \
		cp  $(FSL_PROPRIETARY_PATH)/imx-seco/firmware/seco/mx8qx*ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/; \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/mcu-sdk/imx8q/imx8qx_m4_default.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_image.bin; \
		if [ "$(PRODUCT_IMX_CAR)" = "true" ] && [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
			if [ "$(PRODUCT_IMX_CAR_M4)" = "true" ] ; then \
				FLASH_TARGET=`echo flash_all_spl_container_ddr_car`;  \
				if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_image.bin ]; then \
					rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_image.bin; \
				fi; \
				cp  $(UBOOT_M4_OUT)/MIMX8QX/$(UBOOT_M4_BUILD_TYPE)/rear_view_camera.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/m4_image.bin; \
			fi; \
		fi; \
	elif [ `echo $(2) | cut -d '-' -f1` = "imx8dx" ]; then \
		MKIMAGE_PLATFORM=`echo iMX8QX`; \
		SCFW_PLATFORM=`echo 8dx`; \
		ATF_PLATFORM=`echo imx8qx`; \
		REV=`echo C0`;  \
		if [ `echo $(2) | rev | cut -d '-' -f1` = "uuu" ]; then \
			FLASH_TARGET=`echo flash`;  \
		else \
			FLASH_TARGET=`echo flash_spl`;  \
		fi; \
		cp  $(FSL_PROPRIETARY_PATH)/imx-seco/firmware/seco/mx8qxc0-ahab-container.img $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/; \
	fi; \
	if [ "$(PRODUCT_IMX_CAR_M4)" = "true" ]; then \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q_car/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
	else \
		cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q/mx$$SCFW_PLATFORM-scfw-tcm.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/scfw_tcm.bin; \
	fi; \
	if [ "$(PRODUCT_IMX_CAR)" = "true" -a  `echo $(2) | rev | cut -d '-' -f1` != "uuu" -o `echo $(2) | cut -d '-' -f2` = "trusty" ]; then \
		if [ `echo $(2) | cut -d '-' -f1` = "imx8qm" ] && [ "$(IMX8QM_A72_BOOT)" = "true" ]; then \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q_car/tee-imx$$SCFW_PLATFORM-a72.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		else \
			cp  $(FSL_PROPRIETARY_PATH)/fsl-proprietary/uboot-firmware/imx8q_car/tee-imx$$SCFW_PLATFORM.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		fi; \
	else \
		if [ -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin ]; then \
			rm -f $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/tee.bin; \
		fi; \
	fi; \
	if [ "$(strip $(2))" != "imx8qm-xen" ]; then \
		$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ PLAT=$$ATF_PLATFORM clean; \
		if [ "$(PRODUCT_IMX_CAR)" = "true" -a "$(strip $(2))" != "imx8qm-xen-dom0" -a `echo $(2) | rev | cut -d '-' -f1` != "uuu" -o `echo $(2) | cut -d '-' -f2` = "trusty" ]; then \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=$$ATF_PLATFORM bl31 SPD=trusty -B 1>/dev/null || exit 1; \
		else \
			$(MAKE) -C $(IMX_PATH)/arm-trusted-firmware/ CROSS_COMPILE="$(ATF_CROSS_COMPILE)" PLAT=$$ATF_PLATFORM bl31 -B 1>/dev/null || exit 1; \
		fi; \
		cp $(IMX_PATH)/arm-trusted-firmware/build/$$ATF_PLATFORM/release/bl31.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/bl31.bin; \
		cp  $(UBOOT_OUT)/u-boot.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
		if [ `echo $(2) | rev | cut -d '-' -f1` != "uuu" ]; then \
			cp  $(UBOOT_OUT)/spl/u-boot-spl.bin $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot-spl.bin; \
		fi; \
		cp  $(UBOOT_OUT)/tools/mkimage  $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mkimage_uboot; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$$MKIMAGE_PLATFORM REV=$$REV $$FLASH_TARGET || exit 1; \
		if [ "$(PRODUCT_IMX_CAR)" != "true" ] || [ `echo $(2) | rev | cut -d '-' -f1` = "uuu" ] || [ "$(strip $(2))" = "imx8qm-xen-dom0" ]; then \
			cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/flash.bin $(UBOOT_COLLECTION)/u-boot-$(strip $(2)).imx; \
		else \
			cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/boot-spl-container.img $(UBOOT_COLLECTION)/spl-$(strip $(2)).bin; \
			cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot-atf-container.img $(UBOOT_COLLECTION)/bootloader-$(strip $(2)).img; \
		fi; \
	else \
		cp $(UBOOT_OUT)/u-boot.$(strip $(1)) $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot.bin; \
		cp $(UBOOT_OUT)/spl/u-boot-spl.bin $(UBOOT_COLLECTION)/spl-$(strip $(2)).bin; \
		cp $(UBOOT_OUT)/tools/mkimage  $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/mkimage_uboot; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ clean; \
		$(MAKE) -C $(IMX_MKIMAGE_PATH)/imx-mkimage/ SOC=$$MKIMAGE_PLATFORM REV=$$REV $$FLASH_TARGET || exit 1; \
		cp $(IMX_MKIMAGE_PATH)/imx-mkimage/$$MKIMAGE_PLATFORM/u-boot-xen-container.img $(UBOOT_COLLECTION)/bootloader-$(strip $(2)).img; \
	fi;
endef


