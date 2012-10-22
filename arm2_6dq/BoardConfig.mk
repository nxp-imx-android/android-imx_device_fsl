#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/arm2_6dq/build_id.mk
include device/fsl/imx6/arm2/BoardConfigArm2.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk

BOARD_KERNEL_CMDLINE := console=ttymxc0,115200 init=/init androidboot.console=ttymxc0 androidboot.hardware=freescale
TARGET_BOOTLOADER_CONFIG := 6q:mx6q_arm2_android_config 6dl:mx6dl_arm2_config
