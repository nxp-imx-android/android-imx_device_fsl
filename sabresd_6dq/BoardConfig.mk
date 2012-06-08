#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/sabresd/SabreSDBoardConfigComm.mk

BOARD_SOC_TYPE := IMX6DQ

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init video=mxcfb0 fbmem=10M vmalloc=400M androidboot.console=ttymxc0

TARGET_BOOTLOADER_CONFIG := 6q:mx6q_sabresd_android_config 6dl:mx6dl_sabresd_android_config

