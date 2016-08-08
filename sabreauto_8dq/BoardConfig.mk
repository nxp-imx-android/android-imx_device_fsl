#
# Product-specific compile-time definitions.
#

include device/fsl/imx8/soc/imx8dq.mk
include device/fsl/sabreauto_8dq/build_id.mk
include device/fsl/imx8/BoardConfigCommon.mk
ifeq ($(PREBUILT_FSL_IMX_CODEC),true)
include device/fsl-codec/fsl-codec64.mk
endif
# sabreauto_6dq default target for EXT4
BUILD_TARGET_FS ?= ext4
include device/fsl/imx8/imx8_target_fs.mk

ifeq ($(BUILD_TARGET_FS),ubifs)
ADDITIONAL_BUILD_PROPERTIES += \
                        ro.boot.storage_type=nand
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_8dq/fstab_nand.freescale
# build ubifs for nand devices
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_8dq/fstab_nand.freescale:root/fstab.freescale
else
ADDITIONAL_BUILD_PROPERTIES += \
                        ro.boot.storage_type=sd
ifneq ($(BUILD_TARGET_FS),f2fs)
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_8dq/fstab.freescale
# build for ext4
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_8dq/fstab.freescale:root/fstab.freescale
else
TARGET_RECOVERY_FSTAB = device/fsl/sabreauto_8dq/fstab-f2fs.freescale
# build for f2fs
PRODUCT_COPY_FILES +=	\
	device/fsl/sabreauto_8dq/fstab-f2fs.freescale:root/fstab.freescale
endif # BUILD_TARGET_FS
endif # BUILD_TARGET_FS

TARGET_BOOTLOADER_BOARD_NAME := SABREAUTO

BOARD_SOC_CLASS := IMX8
BOARD_SOC_TYPE := IMX8DQ
PRODUCT_MODEL := SABREAUTO-MX8DQ

USE_OPENGL_RENDERER := true
TARGET_CPU_SMP := true

TARGET_RELEASETOOLS_EXTENSIONS := device/fsl/imx8
# UNITE is a virtual device support both atheros and realtek wifi(ar6103 and rtl8723as)
BOARD_WLAN_DEVICE            := UNITE
WPA_SUPPLICANT_VERSION       := VER_0_8_UNITE
BOARD_WPA_SUPPLICANT_DRIVER  := NL80211
BOARD_HOSTAPD_DRIVER         := NL80211

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

BOARD_USE_SENSOR_FUSION_64BIT := true

# for recovery service
TARGET_SELECT_KEY := 28
# we don't support sparse image.
TARGET_USERIMAGES_SPARSE_EXT_DISABLED := false
DM_VERITY_RUNTIME_CONFIG := true

# camera hal v3
IMX_CAMERA_HAL_V3 := true

BOARD_HAVE_USB_CAMERA := true

USE_ION_ALLOCATOR := false
USE_GPU_ALLOCATOR := true

BOARD_KERNEL_CMDLINE := console=ttymxc2,115200 init=/init androidboot.zygote=zygote64_32 androidboot.console=ttymxc2 consoleblank=0 androidboot.hardware=freescale cma=800M androidboot.watchdogd=disabled androidboot.serialno=150831d4e1fdfca7

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
#UBI boot command line.
UBI_ROOT_INI := device/fsl/sabreauto_6q/ubi/ubinize.ini
TARGET_MKUBIFS_ARGS := -m 8192 -e 1032192 -c 4096 -x none -F
TARGET_UBIRAW_ARGS := -m 8192 -p 1024KiB $(UBI_ROOT_INI)

# Note: this NAND partition table must align with MFGTool's config.
BOARD_KERNEL_CMDLINE +=  mtdparts=gpmi-nand:64m(bootloader),16m(bootimg),16m(recovery),-(root) ubi.mtd=4
endif

ifeq ($(TARGET_USERIMAGES_USE_UBIFS),true)
ifeq ($(TARGET_USERIMAGES_USE_EXT4),true)
$(error "TARGET_USERIMAGES_USE_UBIFS and TARGET_USERIMAGES_USE_EXT4 config open in same time, please only choose one target file system image")
endif
endif

TARGET_BOARD_DTS_CONFIG := imx8dv:fsl-imx8dv-sabreauto.dtb
TARGET_BOOTLOADER_CONFIG := imx8dv:imx8dv_sabreauto_android_defconfig

BOARD_SEPOLICY_DIRS := \
       device/fsl/imx8/sepolicy \
       device/fsl/sabreauto_8dq/sepolicy

BOARD_SECCOMP_POLICY += device/fsl/sabreauto_8dq/seccomp
