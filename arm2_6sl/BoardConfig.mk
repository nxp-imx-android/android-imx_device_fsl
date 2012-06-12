#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6sl.mk
include device/fsl/imx6/arm2/BoardConfigArm2.mk

USE_CAMERA_STUB := true
BOARD_HAVE_IMX_CAMERA := false

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0
TARGET_BOOTLOADER_CONFIG := mx6sl:mx6sl_arm2_android_config
