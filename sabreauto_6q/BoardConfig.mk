#
# Product-specific compile-time definitions.
#

include device/fsl/imx6/soc/imx6dq.mk
include device/fsl/sabreauto_6q/build_id.mk
include device/fsl/imx6/BoardConfigCommon.mk
include device/fsl-proprietary/gpu-viv/fsl-gpu.mk
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx6/imx6_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab_nand.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_6q/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_6q/fstab.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

BOARD_SOC_CLASS := IMX6
BOARD_SOC_TYPE := IMX6DQ
PRODUCT_MODEL := SABREAUTO-MX6Q

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

# UNITE is a virtual device support both atheros and realtek wifi(ar6103 and rtl8723as)
BOARD_WLAN_DEVICE            := UNITE
WPA_SUPPLICANT_VERSION       := VER_0_8_UNITE
TARGET_KERNEL_MODULES        := \
                                kernel_imx/drivers/net/wireless/rtl8723as/8723as.ko:system/lib/modules/8723as.ko \
                                kernel_imx/net/wireless/cfg80211.ko:system/lib/modules/cfg80211_realtek.ko
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

BOARD_HOSTAPD_PRIVATE_LIB_QCOM              := lib_driver_cmd_qcwcn
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_QCOM       := lib_driver_cmd_qcwcn
BOARD_HOSTAPD_PRIVATE_LIB_RTL               := lib_driver_cmd_rtl
BOARD_WPA_SUPPLICANT_PRIVATE_LIB_RTL        := lib_driver_cmd_rtl
#for intel vendor
ifeq ($(BOARD_WLAN_VENDOR),INTEL)
BOARD_HOSTAPD_PRIVATE_LIB                := private_lib_driver_cmd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd
WPA_SUPPLICANT_VERSION                   := VER_0_8_X
HOSTAPD_VERSION                          := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB         := private_lib_driver_cmd_intel
WIFI_DRIVER_MODULE_PATH                  := "/system/lib/modules/iwlagn.ko"
WIFI_DRIVER_MODULE_NAME                  := "iwlagn"
WIFI_DRIVER_MODULE_PATH                  ?= auto
endif

BOARD_MODEM_VENDOR := AMAZON

USE_ATHR_GPS_HARDWARE := false
USE_QEMU_GPS_HARDWARE := false

#for accelerator sensor, need to define sensor type here
BOARD_HAS_SENSOR := true
SENSOR_MMA8451 := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

# atheros 3k BT
BOARD_USE_AR3K_BLUETOOTH := true

# camera hal v2
IMX_CAMERA_HAL_V2 := true

BOARD_HAVE_USB_CAMERA := true

# define frame buffer count
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

BOARD_KERNEL_CMDLINE := console=ttymxc3,115200 init=/init video=mxcfb0:dev=ldb,bpp=32 video=mxcfb1:off video=mxcfb2:off fbmem=10M vmalloc=400M androidboot.console=ttymxc3 androidboot.hardware=freescale

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
UBI_ROOT_INI := device/fsl/sabreauto_6q/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 4096 -e 516096 -c 4096 -x none
TARGET_UBIRAW_ARGS := -m 4096 -p 512KiB $(UBI_ROOT_INI)

# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:16m(bootloader),16m(bootimg),128m(recovery),-(root) ubi.mtd=3
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

TARGET_BOOTLOADER_CONFIG := mx6q:mx6q_sabreauto_android_config mx6dl:mx6dl_sabreauto_android_config mx6solo:mx6solo_sabreauto_android_config mx6q-nand:mx6q_sabreauto_nand_android_config mx6dl-nand:mx6dl_sabreauto_nand_android_config mx6solo-nand:mx6solo_sabreauto_nand_android_config
