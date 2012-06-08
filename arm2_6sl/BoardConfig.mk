#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/arm2/BoardConfigArm2.mk

BOARD_SOC_TYPE := IMX6SL

USE_OPENGL_RENDERER := false
TARGET_CPU_SMP := false

HAVE_FSL_IMX_GPU := false
HAVE_FSL_IMX_IPU := false
HAVE_FSL_IMX_CODEC := false
USE_CAMERA_STUB := true
BOARD_HAVE_IMX_CAMERA := false

BOARD_KERNEL_BASE := 0x80800000
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0
TARGET_KERNEL_DEFCONF := imx6s_android_defconfig
TARGET_BOOTLOADER_CONFIG := mx6sl:mx6sl_arm2_android_config

TARGET_HAVE_IMX_GRALLOC := false
TARGET_HAVE_IMX_HWCOMPOSER := false
