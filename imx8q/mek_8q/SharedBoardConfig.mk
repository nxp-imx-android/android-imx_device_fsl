# -------@block_common_config-------
# after selecting the target by "lunch" command, TARGET_PRODUCT will be set
ifeq ($(TARGET_PRODUCT),mek_8q_car)
  PRODUCT_IMX_CAR := true
  PRODUCT_IMX_CAR_M4 := true
# i.MX8QM  will boot from A72 core on Android Auto by default.
# Remove below defination will make i.MX8QM boot from A53 core.
  IMX8QM_A72_BOOT := true
# Enable dual bootloader feature
  PRODUCT_IMX_DUAL_BOOTLOADER := true
endif
ifeq ($(TARGET_PRODUCT),mek_8q_car2)
  PRODUCT_IMX_CAR := true
  # the env setting in mek_8q_car to make the build without M4 image
  PRODUCT_IMX_CAR_M4 := false
# i.MX8QM  will boot from A72 core on Android Auto by default.
# Remove below defination will make i.MX8QM boot from A53 core.
  IMX8QM_A72_BOOT := true
endif

# -------@block_kernel_bootimg-------
ifeq ($(PRODUCT_IMX_CAR),true)
  KERNEL_NAME := Image.lz4
  IMX8Q_USES_GKI := true
else
  KERNEL_NAME := Image
  IMX8Q_USES_GKI := false
endif
TARGET_KERNEL_ARCH := arm64

# NXP 8997 mxmdriver wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/mlan.ko \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/moal.ko

# Support SOF modules
ifeq ($(IMX8Q_USES_GKI),false)
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof-of.ko \
    $(KERNEL_OUT)/sound/soc/sof/xtensa/snd-sof-xtensa-dsp.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/imx-common.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/snd-sof-imx8.ko
endif

ifeq ($(PRODUCT_IMX_CAR),true)
    ifeq ($(IMX8Q_USES_GKI),true)

# zsmalloc + irq steer
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/mm/zsmalloc.ko \
    $(KERNEL_OUT)/drivers/irqchip/irq-imx-irqsteer.ko

# PHys (hdmi, mipi, lvs)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/phy/cadence/phy-cadence-salvo.ko \
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.ko \
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-samsung-hdmi.ko \
    $(KERNEL_OUT)/drivers/phy/phy-mixel-lvds.ko \
    $(KERNEL_OUT)/drivers/phy/phy-mixel-lvds-combo.ko

# PHYs (PCIe)
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-imx8-pcie.ko

# pinctrl + ocotp
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-scu.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx8qm.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx8qxp.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-pca953x.ko \
    $(KERNEL_OUT)/drivers/nvmem/nvmem-imx-ocotp-scu.ko

# Display backlight
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/pwm/pwm-imx27.ko \
    $(KERNEL_OUT)/drivers/video/backlight/pwm_bl.ko \

# Display (FB)
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/video/fbdev/core/fb_notify.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/fb.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/cfbfillrect.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/cfbcopyarea.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/cfbimgblt.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/mxc/mxc_edid.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/mxc/fb_fence.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/mx3fb.ko

# PCIe
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/pci/controller/dwc/pci-imx6.ko

# Misc
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/dma/fsl-edma-v3.ko \
    $(KERNEL_OUT)/drivers/dma/mxs-dma.ko \
    $(KERNEL_OUT)/drivers/soc/imx/busfreq-imx8mq.ko \
    $(KERNEL_OUT)/drivers/soc/imx/imx8m_pm_domains.ko \
    $(KERNEL_OUT)/drivers/regulator/gpio-regulator.ko \
    $(KERNEL_OUT)/drivers/regulator/pf8x00-regulator.ko \
    $(KERNEL_OUT)/drivers/tty/serial/fsl_lpuart.ko \
    $(KERNEL_OUT)/drivers/iommu/arm/arm-smmu/arm_smmu.ko \
    $(KERNEL_OUT)/drivers/iommu/arm/arm-smmu-v3/arm_smmu_v3.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imx-ldb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imx8qm-ldb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imx8qxp-ldb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/sec_mipi_dsim-imx.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/dcss/imx-dcss.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/mhdp/cdns_mhdp_imx.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/cadence/cdns_mhdp_drmcore.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/fsl-imx-ldb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/adv7511/adv7511.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/nwl-dsi.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/it6263.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/sec-dsim.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/system_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/cma_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/dsp_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/secure_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/dma-buf-imx.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-imx-lpi2c.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-rpmsg-imx.ko \
    $(KERNEL_OUT)/drivers/i2c/muxes/i2c-mux-pca954x.ko \
    $(KERNEL_OUT)/drivers/i2c/i2c-dev.ko \
    $(KERNEL_OUT)/drivers/i2c/i2c-mux.ko

# SPI
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/spi/spidev.ko \
    $(KERNEL_OUT)/drivers/spi/spi-bitbang.ko \
    $(KERNEL_OUT)/drivers/spi/spi-fsl-lpspi.ko \
    $(KERNEL_OUT)/drivers/spi/spi-imx.ko \
    $(KERNEL_OUT)/drivers/spi/spi-slave-time.ko \
    $(KERNEL_OUT)/drivers/spi/spi-slave-system-control.ko

# Ethernet (FEC)
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/net/phy/at803x.ko \
    $(KERNEL_OUT)/drivers/net/ethernet/freescale/fec.ko

# USB3.0
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/usb/phy/phy-mxs-usb.ko \
    $(KERNEL_OUT)/drivers/usb/typec/mux/gpio-switch.ko \
    $(KERNEL_OUT)/drivers/usb/cdns3/cdns-usb-common.ko \
    $(KERNEL_OUT)/drivers/usb/cdns3/cdns3.ko \
    $(KERNEL_OUT)/drivers/usb/cdns3/cdns3-imx.ko \
    $(KERNEL_OUT)/lib/stmp_device.ko

# USB2.0
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/usb/phy/phy-generic.ko \
    $(KERNEL_OUT)/drivers/usb/common/ulpi.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc_imx.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/usbmisc_imx.ko

# RTC + sc_pwrkey
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/input/keyboard/imx_sc_pwrkey.ko \
    $(KERNEL_OUT)/drivers/rtc/rtc-imx-sc.ko

# Capture + V4L + fw + systimer + trusty
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/media/i2c/ov5640.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-fwnode.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-async.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-jpeg.ko \
    $(KERNEL_OUT)/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-encdec.ko \
    $(KERNEL_OUT)/drivers/media/platform/imx8/mxc-mipi-csi2_yav.ko \
    $(KERNEL_OUT)/drivers/media/platform/amphion/amphion-vpu.ko \
    $(KERNEL_OUT)/drivers/watchdog/imx_sc_wdt.ko \
    $(KERNEL_OUT)/drivers/cpufreq/cpufreq-dt.ko \
    $(KERNEL_OUT)/drivers/cpufreq/imx-cpufreq-dt.ko \
    $(KERNEL_OUT)/drivers/mmc/host/sdhci-esdhc-imx.ko \
    $(KERNEL_OUT)/drivers/mmc/host/cqhci.ko \
    $(KERNEL_OUT)/drivers/firmware/imx/imx-dsp.ko \
    $(KERNEL_OUT)/drivers/firmware/imx/seco_mu.ko \
    $(KERNEL_OUT)/drivers/firmware/qcom-scm.ko \
    $(KERNEL_OUT)/drivers/clocksource/timer-imx-sysctr.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-mipi-csi2.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-mipi-csi2-sam.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/dwc-mipi-csi2.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-hw.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-mem2mem.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-capture.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-capture.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/gmsl-max9286.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-parallel-csi.ko \
    $(KERNEL_OUT)/drivers/remoteproc/imx_rproc.ko \
    $(KERNEL_OUT)/drivers/mxc/vehicle/vehicle-core.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-core.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-irq.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-log.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-virtio.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-ipc.ko \
    $(KERNEL_OUT)/drivers/mux/mux-core.ko \
    $(KERNEL_OUT)/drivers/mux/mux-mmio.ko

# GPU
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/mxc/gpu-viv/galcore.ko \
    $(KERNEL_OUT)/drivers/thermal/imx_sc_thermal.ko \
    $(KERNEL_OUT)/drivers/thermal/device_cooling.ko \

# Vehicle drv (dummy. rpmsg_m4)
ifeq ($(PRODUCT_IMX_CAR_M4),true)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/mxc/vehicle/vehicle_rpmsg_m4.ko
else
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/mxc/vehicle/vehicle_dummy_hw.ko
endif

# sound cards
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-wm8960.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card-utils.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-asoc-card.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-sai.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-audmux.ko \
    $(KERNEL_OUT)/sound/soc/fsl/imx-pcm-dma.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-bt-sco.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-esai.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-cs42xx8.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-cs42xx8-i2c.ko

# SOF
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/remoteproc/imx_dsp_rproc.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/snd-sof-imx8.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/imx-common.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof-of.ko \
    $(KERNEL_OUT)/sound/soc/sof/xtensa/snd-sof-xtensa-dsp.ko \

# WIFI
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/net/wireless/cfg80211.ko \
    $(KERNEL_OUT)/net/mac80211/mac80211.ko

    else
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc_imx.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/usbmisc_imx.ko \
    $(KERNEL_OUT)/drivers/usb/common/ulpi.ko \
    $(KERNEL_OUT)/drivers/usb/host/ehci-hcd.ko \
    $(KERNEL_OUT)/drivers/usb/storage/usb-storage.ko \
    $(KERNEL_OUT)/block/t10-pi.ko \
    $(KERNEL_OUT)/drivers/scsi/sd_mod.ko \
    $(KERNEL_OUT)/drivers/hid/hid-multitouch.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko
    endif
endif

# -------@block_security-------
#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

# -------@block_storage-------
ifneq ($(TARGET_PRODUCT),mek_8q_car2)
  AB_OTA_PARTITIONS += bootloader

  ifeq ($(PRODUCT_IMX_CAR),true)
    BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8qm.img
    ifeq ($(OTA_TARGET),8qxp)
      BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8qxp.img
    else ifeq ($(OTA_TARGET),8qxp-c0)
      BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8qxp-c0.img
    endif
  else
    BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8qm-trusty-dual.img
    ifeq ($(OTA_TARGET),8qxp)
      BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8qxp-trusty-dual.img
    else ifeq ($(OTA_TARGET),8qxp-c0)
      BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8qxp-c0-trusty-dual.img
    endif
  endif
endif
