# -------@block_kernel_bootimg-------

KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64

IMX8ULP_USES_GKI := false

# -------@block_memory-------
#Enable this to config 1GB ddr on evk_imx8ulp
LOW_MEMORY := false

# -------@block_security-------
#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true
