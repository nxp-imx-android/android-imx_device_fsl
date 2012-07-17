#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/imx6/sabresd/SabreSDBoardConfigComm.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc0


ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init video=mxcfb0 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc0  mtdparts=gpmi-nand:20m(bootloader),20m(bootimg),20m(recovery),-(root) gpmi_debug_init ubi.mtd=3
endif


TARGET_BOOTLOADER_CONFIG := 6q:mx6q_sabresd_android_config 6dl:mx6dl_sabresd_android_config


