#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/arm2/BoardConfigArm2.mk

BOARD_SOC_TYPE := IMX6DQ

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

HAVE_FSL_IMX_GPU := true
HAVE_FSL_IMX_IPU := true
HAVE_FSL_IMX_CODEC := true

BOARD_KERNEL_BASE := 0x10800000
BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0
TARGET_KERNEL_DEFCONF := imx6_android_defconfig
TARGET_BOOTLOADER_CONFIG := 6q:mx6q_arm2_android_config 6dl:mx6dl_arm2_config
