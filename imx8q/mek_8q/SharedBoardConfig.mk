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
else
  KERNEL_NAME := Image
endif
TARGET_KERNEL_ARCH := arm64

# NXP 8997 mxmdriver wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/mlan.ko \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/moal.ko

# Support SOF modules
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/firmware/imx/imx-dsp.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof-utils.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof-of.ko \
    $(KERNEL_OUT)/sound/soc/sof/xtensa/snd-sof-xtensa-dsp.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/imx-common.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/snd-sof-imx8.ko

ifeq ($(PRODUCT_IMX_CAR),true)
BOARD_VENDOR_KERNEL_MODULES += \
                            $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc.ko \
                            $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc_imx.ko \
                            $(KERNEL_OUT)/drivers/usb/chipidea/usbmisc_imx.ko \
                            $(KERNEL_OUT)/drivers/usb/common/ulpi.ko \
                            $(KERNEL_OUT)/drivers/usb/host/ehci-hcd.ko \
                            $(KERNEL_OUT)/drivers/usb/storage/usb-storage.ko \
                            $(KERNEL_OUT)/drivers/scsi/sd_mod.ko \
                            $(KERNEL_OUT)/drivers/bluetooth/mx8_bt_rfkill.ko \
                            $(KERNEL_OUT)/drivers/hid/hid-multitouch.ko

ifeq ($(PRODUCT_IMX_CAR_M4),true)
#BOARD_VENDOR_KERNEL_MODULES += \
                            $(KERNEL_OUT)/drivers/staging/media/imx/gmsl-max9286.ko \
                            $(KERNEL_OUT)/drivers/staging/media/imx/imx8-mipi-csi2.ko \
                            $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko \
                            $(KERNEL_OUT)/drivers/staging/media/imx/imx8-capture.ko

endif
endif

ifeq ($(PRODUCT_IMX_CAR),)
  IMX8Q_USES_GKI_DEFCONFIG := true
endif

ifeq ($(IMX8Q_USES_GKI_DEFCONFIG),true)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/mailbox/imx-mailbox.ko \
    $(KERNEL_OUT)/drivers/firmware/imx/imx-scu-firmware.ko \
    $(KERNEL_OUT)/drivers/rpmsg/rpmsg_ns.ko \
    $(KERNEL_OUT)/drivers/rpmsg/virtio_rpmsg_bus.ko \
    $(KERNEL_OUT)/drivers/firmware/imx/seco_mu.ko \
    $(KERNEL_OUT)/drivers/firmware/imx/scu-pd.ko \
    $(KERNEL_OUT)/drivers/clk/imx/mxc-clk.ko \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx-scu.ko \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx-lpcg-scu.ko \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx-acm-utils.ko \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx8qxp-acm.ko \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx8qm-acm.ko \
    $(KERNEL_OUT)/drivers/irqchip/irq-imx-irqsteer.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-scu.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx8qxp.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx8qm.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-core.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-irq.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-log.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-virtio.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-ipc.ko \
    $(KERNEL_OUT)/drivers/iommu/arm/arm-smmu/arm_smmu.ko \
    $(KERNEL_OUT)/drivers/cpufreq/cpufreq-dt.ko \
    $(KERNEL_OUT)/drivers/tty/serial/fsl_lpuart.ko \
    $(KERNEL_OUT)/drivers/reset/gpio-reset.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-max732x.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-pca953x.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-mxc.ko \
    $(KERNEL_OUT)/drivers/pwm/pwm-imx27.ko \
    $(KERNEL_OUT)/drivers/video/backlight/pwm_bl.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-rpmsg-imx.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-imx-lpi2c.ko \
    $(KERNEL_OUT)/drivers/spi/spi-fsl-lpspi.ko \
    $(KERNEL_OUT)/drivers/spi/spi-nxp-fspi.ko \
    $(KERNEL_OUT)/drivers/iio/buffer/kfifo_buf.ko \
    $(KERNEL_OUT)/drivers/iio/buffer/industrialio-triggered-buffer.ko \
    $(KERNEL_OUT)/drivers/iio/light/isl29018.ko \
    $(KERNEL_OUT)/drivers/iio/pressure/mpl3115.ko \
    $(KERNEL_OUT)/drivers/iio/gyro/fxas21002c_core.ko \
    $(KERNEL_OUT)/drivers/iio/gyro/fxas21002c_i2c.ko \
    $(KERNEL_OUT)/drivers/iio/imu/fxos8700_core.ko \
    $(KERNEL_OUT)/drivers/iio/imu/fxos8700_i2c.ko \
    $(KERNEL_OUT)/drivers/soc/imx/busfreq-imx8mq.ko \
    $(KERNEL_OUT)/drivers/mmc/host/cqhci.ko \
    $(KERNEL_OUT)/drivers/mmc/host/sdhci-esdhc-imx.ko \
    $(KERNEL_OUT)/lib/stmp_device.ko \
    $(KERNEL_OUT)/drivers/remoteproc/imx_rproc.ko \
    $(KERNEL_OUT)/drivers/usb/typec/mux/gpio-switch.ko \
    $(KERNEL_OUT)/drivers/usb/phy/phy-mxs-usb.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/usbmisc_imx.ko \
    $(KERNEL_OUT)/drivers/usb/common/ulpi.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc_imx.ko \
    $(KERNEL_OUT)/drivers/phy/cadence/phy-cadence-salvo.ko \
    $(KERNEL_OUT)/drivers/usb/cdns3/cdns-usb-common.ko \
    $(KERNEL_OUT)/drivers/usb/cdns3/cdns3-imx.ko \
    $(KERNEL_OUT)/drivers/usb/cdns3/cdns3.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/system_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/dsp_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/cma_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/dma-buf-imx.ko \
    $(KERNEL_OUT)/drivers/dma/mxs-dma.ko \
    $(KERNEL_OUT)/drivers/input/keyboard/imx_sc_key.ko \
    $(KERNEL_OUT)/drivers/gpu/imx/imx8_prg.ko \
    $(KERNEL_OUT)/drivers/gpu/imx/imx8_dprc.ko \
    $(KERNEL_OUT)/drivers/gpu/imx/imx8_pc.ko \
    $(KERNEL_OUT)/drivers/gpu/imx/dpu/imx-dpu-core.ko \
    $(KERNEL_OUT)/drivers/gpu/imx/dpu-blit/imx-dpu-blit.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/dpu/imx-dpu-render.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/drm_dma_helper.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/dpu/imx-dpu-crtc.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imxdrm.ko \
    $(KERNEL_OUT)/drivers/phy/phy-mixel-lvds.ko \
    $(KERNEL_OUT)/drivers/phy/phy-mixel-lvds-combo.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/fsl-imx-ldb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imx8qxp-ldb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imx8qm-ldb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/it6263.ko \
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.ko \
    $(KERNEL_OUT)/drivers/mux/mux-core.ko \
    $(KERNEL_OUT)/drivers/mux/mux-mmio.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/nwl-dsi.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/adv7511/adv7511.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-async.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-fwnode.ko \
    $(KERNEL_OUT)/drivers/media/i2c/ov5640.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/gmsl-max9286.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-mipi-csi2.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-parallel-csi.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-capture.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-hw.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-capture.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-mem2mem.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko

BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/mxc/gpu-viv/galcore.ko \
    $(KERNEL_OUT)/drivers/thermal/device_cooling.ko \
    $(KERNEL_OUT)/drivers/thermal/imx_sc_thermal.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-jpeg.ko \
    $(KERNEL_OUT)/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg-encdec.ko \
    $(KERNEL_OUT)/drivers/media/platform/amphion/amphion-vpu.ko \
    $(KERNEL_OUT)/drivers/power/supply/dummy_battery.ko \
    $(KERNEL_OUT)/drivers/dma/fsl-edma-v3.ko \
    $(KERNEL_OUT)/sound/soc/fsl/imx-pcm-dma.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-audmux.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-audmix.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-asrc.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-easrc.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-utils.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-sai.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-esai.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-wm8960.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-cs42xx8.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-cs42xx8-i2c.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-bt-sco.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-asoc-card.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-audmix.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card-utils.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card.ko \
    $(KERNEL_OUT)/drivers/remoteproc/imx_dsp_rproc.ko \
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-imx8q-pcie.ko \
    $(KERNEL_OUT)/drivers/pci/controller/dwc/pci-imx6.ko \
    $(KERNEL_OUT)/drivers/net/phy/at803x.ko \
    $(KERNEL_OUT)/drivers/net/ethernet/freescale/fec.ko \
    $(KERNEL_OUT)/drivers/mtd/mtd.ko \
    $(KERNEL_OUT)/drivers/mtd/nand/nandcore.ko \
    $(KERNEL_OUT)/drivers/mtd/nand/raw/nand.ko \
    $(KERNEL_OUT)/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.ko \
    $(KERNEL_OUT)/drivers/perf/fsl_imx8_ddr_perf.ko \
    $(KERNEL_OUT)/drivers/iio/adc/imx8qxp-adc.ko \
    $(KERNEL_OUT)/drivers/net/can/flexcan/flexcan.ko \
    $(KERNEL_OUT)/drivers/watchdog/imx_sc_wdt.ko \
    $(KERNEL_OUT)/drivers/rtc/rtc-imx-sc.ko \
    $(KERNEL_OUT)/drivers/nvmem/nvmem-imx-ocotp-scu.ko \
    $(KERNEL_OUT)/drivers/soc/imx/secvio/soc-imx-secvio-sc.ko
else
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko \
    $(KERNEL_OUT)/drivers/remoteproc/imx_dsp_rproc.ko

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
