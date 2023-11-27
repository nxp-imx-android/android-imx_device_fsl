#!/bin/bash

# hardcode this one again in this shell script
CONFIG_REPO_PATH=device/nxp

# import other paths in the file "common/imx_path/ImxPathConfig.mk" of this
# repository

while read -r line
do
	if [ "$(echo ${line} | grep "=")" != "" ]; then
		env_arg=`echo ${line} | cut -d "=" -f1`
		env_arg=${env_arg%:}
		env_arg=`eval echo ${env_arg}`

		env_arg_value=`echo ${line} | cut -d "=" -f2`
		env_arg_value=`eval echo ${env_arg_value}`

		eval ${env_arg}=${env_arg_value}
	fi
done < ${CONFIG_REPO_PATH}/common/imx_path/ImxPathConfig.mk

if [ "${AARCH64_GCC_CROSS_COMPILE}" != "" ]; then
	ATF_CROSS_COMPILE=`eval echo ${AARCH64_GCC_CROSS_COMPILE}`
else
	echo ERROR: \*\*\* env AARCH64_GCC_CROSS_COMPILE is not set
	exit 1
fi

MKIMAGE_SOC=iMX8ULP
BOARD_MKIMAGE_PATH=${IMX_MKIMAGE_PATH}/imx-mkimage/${MKIMAGE_SOC}

build_m4_image()
{
	:
}

build_imx_uboot()
{
	echo Building i.MX U-Boot with firmware
	if [ `echo $2 | rev | cut -d '-' -f2 | rev` = "dualboot" ]; then
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/mcu-sdk/imx8ulp/imx8ulp_mcu_demo_lpd.img ${BOARD_MKIMAGE_PATH}/m33_image.bin
	elif [ `echo $2 | rev |cut -d '-' -f2 | rev` = "lpa" ]; then
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/mcu-sdk/imx8ulp/imx8ulp_mcu_demo_lpa.img ${BOARD_MKIMAGE_PATH}/m33_image.bin
	else
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/mcu-sdk/imx8ulp/imx8ulp_mcu_demo.img ${BOARD_MKIMAGE_PATH}/m33_image.bin
	fi
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/uboot-firmware/imx8ulp/upower.bin ${BOARD_MKIMAGE_PATH}/upower.bin
		cp ${FSL_PROPRIETARY_PATH}/ele/mx8ulpa2-ahab-container.img ${BOARD_MKIMAGE_PATH}
	cp ${UBOOT_OUT}/u-boot.$1 ${BOARD_MKIMAGE_PATH}
	cp ${UBOOT_OUT}/spl/u-boot-spl.bin ${BOARD_MKIMAGE_PATH}
	cp ${UBOOT_OUT}/tools/mkimage ${BOARD_MKIMAGE_PATH}/mkimage_uboot

	# build ATF based on whether tee is involved
	make -C ${IMX_PATH}/arm-trusted-firmware/ PLAT=`echo $2 | cut -d '-' -f1` clean
	if [ `echo $2 | cut -d '-' -f2` = "trusty" ] && [ `echo $2 | rev | cut -d '-' -f1` != "uuu" ]; then
		cp ${FSL_PROPRIETARY_PATH}/fsl-proprietary/uboot-firmware/imx8ulp/tee-imx8ulp.bin ${BOARD_MKIMAGE_PATH}/tee.bin
		if [ "`echo $2 | cut -d '-' -f3`" = "4g" ]; then
			make -C ${IMX_PATH}/arm-trusted-firmware/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" PLAT=`echo $2 | cut -d '-' -f1` bl31 -B BL32_BASE=0xfe000000 SPD=trusty 1>/dev/null || exit 1
		else
			make -C ${IMX_PATH}/arm-trusted-firmware/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" PLAT=`echo $2 | cut -d '-' -f1` bl31 -B SPD=trusty 1>/dev/null || exit 1
		fi
	else
		if [ -f ${BOARD_MKIMAGE_PATH}/tee.bin ] ; then
			rm -rf ${BOARD_MKIMAGE_PATH}/tee.bin
		fi
		make -C ${IMX_PATH}/arm-trusted-firmware/ CROSS_COMPILE="${ATF_CROSS_COMPILE}" PLAT=`echo $2 | cut -d '-' -f1` bl31 -B 1>/dev/null || exit 1
	fi

	cp ${IMX_PATH}/arm-trusted-firmware/build/`echo $2 | cut -d '-' -f1`/release/bl31.bin ${BOARD_MKIMAGE_PATH}/bl31.bin

	make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ clean
	# in imx-mkimage/Makefile, MKIMG is assigned with a value of "$(PWD)/mkimage_imx8", the value of PWD is set by shell to current
	# directory. Directly execute "make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ ..." command in this script, PWD is the top dir of Android
	# codebase, so mkimage_imx8 will be generated under Android codebase top dir.
	pwd_backup=${PWD}
	PWD=${PWD}/${IMX_MKIMAGE_PATH}/imx-mkimage/
	if [ `echo $2 | rev | cut -d '-' -f2 | rev` = "dualboot" ]; then
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} REV=A2 flash_dualboot_m33 || exit 1
		cp ${BOARD_MKIMAGE_PATH}/flash.bin ${UBOOT_COLLECTION}/`echo $2 | cut -d '-' -f1`_mcu_demo_sf.img
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ clean
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} REV=A2 flash_dualboot || exit 1
	elif [ `echo $2 | rev |cut -d '-' -f2 | rev` = "lpa" ]; then
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} REV=A2 flash_dualboot_m33 || exit 1
		cp ${BOARD_MKIMAGE_PATH}/flash.bin ${UBOOT_COLLECTION}/`echo $2 | cut -d '-' -f1`_mcu_demo_lpa.img
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ clean
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} REV=A2 flash_dualboot || exit 1
	else
		make -C ${IMX_MKIMAGE_PATH}/imx-mkimage/ SOC=${MKIMAGE_SOC} REV=A2 flash_singleboot_m33 || exit 1
	fi
	PWD=${pwd_backup}

	if [ `echo $2 | rev | cut -d '-' -f1 | rev` != "dual" ]; then
		cp ${BOARD_MKIMAGE_PATH}/flash.bin ${UBOOT_COLLECTION}/u-boot-$2.imx
	else
		cp ${BOARD_MKIMAGE_PATH}/boot-spl-container.img ${UBOOT_COLLECTION}/spl-$2.bin
		cp ${BOARD_MKIMAGE_PATH}/u-boot-atf-container.img ${UBOOT_COLLECTION}/bootloader-$2.img
	fi

}
