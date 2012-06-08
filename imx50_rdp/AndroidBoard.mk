include device/fsl/imx5x/AndroidBoardCommon.mk

ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
include device/fsl/proprietary/codec/fsl-codec.mk
endif

include device/fsl/proprietary/omx/fsl-omx.mk
include device/fsl/proprietary/gpu/fsl-gpu.mk
