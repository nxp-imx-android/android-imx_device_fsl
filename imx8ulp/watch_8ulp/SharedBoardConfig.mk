# -------@block_kernel_bootimg-------

KERNEL_NAME := Image.lz4
TARGET_KERNEL_ARCH := arm64

LOADABLE_KERNEL_MODULE ?= true

# -------@block_memory-------
#Enable this to config 1GB ddr on evk_imx8ulp
LOW_MEMORY := false

# -------@block_security-------
#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

# CONFIG_ZRAM: zram.ko, compressed ram using LZ coding.
# CONFIG_ZSMALLOC: zsmalloc.ko
# CONFIG_HWMON: hwmon.ko, hardware monitor
# CONFIG_SENSORS_ARM_SCMI: scmi-hwmon.ko, ARM SCMI sensors
# CONFIG_ARM_SCMI_POWER_DOMAIN: scmi_pm_domain.ko, SCMI power domain driver
# CONFIG_MXC_CLK: mxc-clk.ko
# CONFIG_CLK_IMX8ULP: clk-imx8ulp.ko
# CONFIG_IMX_MBOX: imx-mailbox.ko
# CONFIG_IMX_REMOTEPROC: imx_rproc.ko
# CONFIG_IMX_SENCLAVE_MU: sentnl-mu.ko, sentnl firmware driver
# CONFIG_RPMSG_VIRTIO: virtio_rpmsg_bus.ko, rpmsg_ns.ko
# CONFIG_PINCTRL_IMX8ULP: pinctrl-imx.ko, pinctrl-imx8ulp.ko
# CONFIG_SERIAL_FSL_LPUART: fsl_lpuart.ko
# CONFIG_I2C_IMX_LPI2C: i2c-imx-lpi2c.ko
# CONFIG_I2C_RPBUS: i2c-rpmsg-imx.ko
# CONFIG_GPIO_PCA953X: gpio-pca953x.ko
# CONFIG_GPIO_VF610: gpio-vf610.ko
# CONFIG_GPIO_IMX_RPMSG: gpio-imx-rpmsg.ko
# CONFIG_MXC_PXP_CLIENT_DEVICE: pxp_device.ko
# CONFIG_MXC_PXP_V3: pxp_dma_v3.ko
# CONFIG_FSL_EDMA_V3: fsl-edma-v3.ko
# CONFIG_CLKSRC_IMX_TPM: timer-imx-tpm.ko
# CONFIG_MXS_DMA: stmp_device.ko, mxs-dma.ko
# CONFIG_PWRSEQ_SIMPLE: pwrseq_simple.ko
# CONFIG_MMC_SDHCI_ESDHC_IMX cqhci.ko, sdhci-esdhc-imx.ko
# CONFIG_NVMEM_IMX_OCOTP_FSB_S400: nvmem-imx-ocotp-fsb-s400.ko
# CONFIG_IMX7ULP_WDT: imx7ulp_wdt.ko
# CONFIG_PWM_RPCHIP: pwm-rpmsg-imx.ko
# CONFIG_BACKLIGHT_PWM: pwm_bl.ko
# CONFIG_RESET_IMX8ULP_SIM: reset-imx8ulp-sim.ko
# CONFIG_RTC_DRV_IMX_RPMSG: rtc-imx-rpmsg.ko
# CONFIG_RPMSG_LIFE_CYCLE: rpmsg_life_cycle.ko
# CONFIG_BATTERY_DUMMY: dummy_battery.ko
# CONFIG_BATTERY_MAX17042: max17042_battery.ko
# CONFIG_CHARGER_MP2662: mp2662_charger.ko
# CONFIG_DMABUF_HEAPS_DSP: dsp_heap.ko
# CONFIG_DMABUF_HEAPS_SYSTEM: system_heap.ko
# CONFIG_DMABUF_HEAPS_CMA: cma_heap.ko
# CONFIG_DMABUF_IMX: dma-buf-imx.ko
# CONFIG_USB_MXS_PHY: phy-mxs-usb.ko
# CONFIG_USB_CHIPIDEA_IMX: usbmisc_imx.ko, ci_hdrc_imx.ko
# CONFIG_USB_CHIPIDEA: ci_hdrc.ko
# CONFIG_MUX_MMIO: mux-core.ko, mux-mmio.ko
# CONFIG_TOUCHSCREEN_GOODIX: goodix_ts.ko
# CONFIG_PHY_MIXEL_MIPI_DPHY: phy-fsl-imx8-mipi-dphy.ko
# CONFIG_DRM_NWL_MIPI_DSI: nwl-dsi.ko
# CONFIG_DRM_ITE_IT6263: it6161.ko
# CONFIG_DRM_IMX_DCNANO: imx-dcnano-drm.ko
# CONFIG_DRM_PANEL_ROCKTECK_HIMAX8394F: panel-rocktech-hx8394f.ko
# CONFIG_MXC_GPU_VIV: galcore.ko
# CONFIG_VIDEO_OV5640: ov5640.ko
# CONFIG_IMX8_ISI_CAPTURE: imx8-capture.ko
# CONFIG_IMX8_ISI_CORE: imx8-isi-hw.ko, imx8-isi-cap.ko, imx8-isi-m2m.ko
# CONFIG_IMX8_MIPI_CSI2: imx8-mipi-csi2.ko
# CONFIG_IMX8_MEDIA_DEVICE: imx8-media-dev.ko
# CONFIG_TRUSTY: trusty-core.ko, trusty-irq.ko, trusty-log.ko, trusty-virtio.ko, trusty-ipc.ko
# CONFIG_CFG80211: cfg80211.ko
# CONFIG_MAC80211: mac80211.ko

ifeq ($(LOADABLE_KERNEL_MODULE),true)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/hwmon/hwmon.ko \
    $(KERNEL_OUT)/drivers/hwmon/scmi-hwmon.ko \
    $(KERNEL_OUT)/drivers/firmware/arm_scmi/scmi_pm_domain.ko \
    $(KERNEL_OUT)/drivers/clk/imx/mxc-clk.ko \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx8ulp.ko \
    $(KERNEL_OUT)/drivers/mailbox/imx-mailbox.ko \
    $(KERNEL_OUT)/drivers/remoteproc/imx_rproc.ko \
    $(KERNEL_OUT)/drivers/firmware/imx/el_enclave.ko \
    $(KERNEL_OUT)/drivers/rpmsg/rpmsg_ns.ko \
    $(KERNEL_OUT)/drivers/rpmsg/virtio_rpmsg_bus.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx8ulp.ko \
    $(KERNEL_OUT)/drivers/tty/serial/fsl_lpuart.ko \
    $(KERNEL_OUT)/drivers/mfd/imx-flexio.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-imx-lpi2c.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-rpmsg-imx.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-flexio.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/display-imx-rpmsg.ko \
    $(KERNEL_OUT)/drivers/i2c/i2c-dev.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-pca953x.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-vf610.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-imx-rpmsg.ko \
    $(KERNEL_OUT)/drivers/dma/pxp/pxp_device.ko \
    $(KERNEL_OUT)/drivers/dma/pxp/pxp_dma_v3.ko \
    $(KERNEL_OUT)/drivers/dma/fsl-edma-v3.ko \
    $(KERNEL_OUT)/drivers/clocksource/timer-imx-tpm.ko \
    $(KERNEL_OUT)/lib/stmp_device.ko \
    $(KERNEL_OUT)/drivers/dma/mxs-dma.ko \
    $(KERNEL_OUT)/drivers/mmc/core/pwrseq_simple.ko \
    $(KERNEL_OUT)/drivers/mmc/host/cqhci.ko \
    $(KERNEL_OUT)/drivers/mmc/host/sdhci-esdhc-imx.ko \
    $(KERNEL_OUT)/drivers/nvmem/nvmem-imx-ocotp-fsb-s400.ko \
    $(KERNEL_OUT)/drivers/watchdog/imx7ulp_wdt.ko \
    $(KERNEL_OUT)/drivers/pwm/pwm-rpmsg-imx.ko \
    $(KERNEL_OUT)/drivers/video/backlight/pwm_bl.ko \
    $(KERNEL_OUT)/drivers/reset/reset-imx8ulp-sim.ko \
    $(KERNEL_OUT)/drivers/rtc/rtc-imx-rpmsg.ko \
    $(KERNEL_OUT)/drivers/soc/imx/rpmsg_life_cycle.ko \
    $(KERNEL_OUT)/drivers/power/supply/dummy_battery.ko \
    $(KERNEL_OUT)/drivers/power/supply/max17042_battery.ko \
    $(KERNEL_OUT)/drivers/power/supply/mp2662_charger.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/system_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/cma_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/dsp_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/dma-buf-imx.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/usbmisc_imx.ko \
    $(KERNEL_OUT)/drivers/usb/phy/phy-mxs-usb.ko \
    $(KERNEL_OUT)/drivers/usb/common/ulpi.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc_imx.ko \
    $(KERNEL_OUT)/drivers/mux/mux-core.ko \
    $(KERNEL_OUT)/drivers/mux/mux-mmio.ko \
    $(KERNEL_OUT)/drivers/input/touchscreen/goodix_ts.ko \
    $(KERNEL_OUT)/drivers/input/touchscreen/elants_i2c.ko\
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/drm_dma_helper.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/nwl-dsi.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/it6161.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/dcnano/imx-dcnano-drm.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/panel/panel-rocktech-hx8394f.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/panel/panel-nxp-rm67162.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-async.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-fwnode.ko \
    $(KERNEL_OUT)/drivers/media/i2c/ov5640.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-hw.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-capture.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-mem2mem.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-capture.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-mipi-csi2.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-core.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-irq.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-log.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-virtio.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-ipc.ko
else
BOARD_VENDOR_RAMDISK_KERNEL_MODULES +=     \
    $(KERNEL_OUT)/drivers/input/touchscreen/goodix_ts.ko \
    $(KERNEL_OUT)/drivers/input/touchscreen/elants_i2c.ko\
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko
endif

# CONFIG_MFD_FP9931: fp9931-core.ko
# CONFIG_REGULATOR_FP9931: fp9931-regulator.ko
# CONFIG_SENSORS_FP9931: fp9931-hwmon.ko
# CONFIG_FB: cfbcopyarea.ko, cfbfillrect.ko, cfbimgblt.ko, fb.ko
# CONFIG_FB_NOTIFY: fb_notify.ko
# CONFIG_FB_FENCE: fb_fence.ko
# CONFIG_FB_MXC, CONFIG_FB_MXC_EINK_V2_PANEL: mxc_edid.ko, mxc_epdc_v2_fb.ko
# CONFIG_SND_SOC_BT_SCO: snd-soc-bt-sco.ko
# CONFIG_SND_IMX_SOC: imx-pcm-dma.ko
# CONFIG_SND_SOC_FSL_SPDIF: snd-soc-fsl-spdif.ko
# CONFIG_SND_SOC_IMX_SPDIF: snd-soc-imx-spdif.ko
# CONFIG_SND_SIMPLE_CARD: snd-soc-simple-card-utils.ko, snd-soc-simple-card.ko
# CONFIG_SND_SOC_FSL_SAI: snd-soc-fsl-sai.ko
# CONFIG_SND_SOC_IMX_PCM_RPMSG: imx-pcm-rpmsg.ko
# CONFIG_SND_SOC_IMX_RPMSG: imx-audio-rpmsg.ko
# CONFIG_SND_SOC_FSL_RPMSG: snd-soc-fsl-rpmsg.ko
# CONFIG_SND_SOC_IMX_AUDIO_RPMSG: snd-soc-imx-rpmsg.ko
# CONFIG_SND_SOC_RPMSG_WM8960: snd-soc-rpmsg-wm8960.ko
# CONFIG_SND_SOC_RPMSG_WM8960_I2C: snd-soc-rpmsg-wm8960-i2c.ko
# CONFIG_IMX_DSP_REMOTEPROC: imx_dsp_rproc.ko
# CONFIG_MPL3115: mpl3115.ko
# CONFIG_RPMSG_IIO_PEDOMETER: rpmsg_iio_pedometer.ko
# CONFIG_KEYBOARD_RPMSG: rpmsg-keys.ko
# CONFIG_IIO_ST_LSM6DSX: st_lsm6dsx.ko
# CONFIG_IIO_ST_LSM6DSX_I2C: st_lsm6dsx_i2c.ko
# CONFIG_MTD: mtd.ko, chipreg.ko, ofpart.ko
# CONFIG_SPI_FSL_LPSPI: spi-fsl-lpspi.ko
# CONFIG_SPI_SPIDEV: spidev.ko
# CONFIG_SPI_NXP_FLEXSPI: spi-nxp-fspi.ko
# CONFIG_MTD_SPI_NOR: spi-nor.ko
# CONFIG_MICREL_PHY: micrel.ko
# CONFIG_FEC: fec.ko
ifeq ($(LOADABLE_KERNEL_MODULE),true)
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/mm/zsmalloc.ko \
    $(KERNEL_OUT)/drivers/block/zram/zram.ko \
    $(KERNEL_OUT)/net/wireless/cfg80211.ko \
    $(KERNEL_OUT)/net/mac80211/mac80211.ko \
    $(KERNEL_OUT)/drivers/mxc/gpu-viv/galcore.ko \
    $(KERNEL_OUT)/drivers/mfd/fp9931-core.ko \
    $(KERNEL_OUT)/drivers/regulator/fp9931-regulator.ko \
    $(KERNEL_OUT)/drivers/hwmon/fp9931-hwmon.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/cfbcopyarea.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/cfbfillrect.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/cfbimgblt.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/fb_notify.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/core/fb.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/mxc/fb_fence.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/mxc/mxc_epdc_v2_fb.ko \
    $(KERNEL_OUT)/drivers/video/fbdev/mxc/mxc_edid.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-bt-sco.ko \
    $(KERNEL_OUT)/sound/soc/fsl/imx-pcm-dma.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-utils.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-spdif.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-spdif.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card-utils.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-sai.ko \
    $(KERNEL_OUT)/sound/soc/fsl/imx-pcm-rpmsg.ko \
    $(KERNEL_OUT)/sound/soc/fsl/imx-audio-rpmsg.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-rpmsg.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-rpmsg.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-rpmsg-wm8960.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-rpmsg-wm8960-i2c.ko \
    $(KERNEL_OUT)/drivers/remoteproc/imx_dsp_rproc.ko \
    $(KERNEL_OUT)/drivers/firmware/imx/imx-dsp.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof-utils.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof.ko \
    $(KERNEL_OUT)/sound/soc/sof/snd-sof-of.ko \
    $(KERNEL_OUT)/sound/soc/sof/xtensa/snd-sof-xtensa-dsp.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/imx-common.ko \
    $(KERNEL_OUT)/sound/soc/sof/imx/snd-sof-imx8ulp.ko \
    $(KERNEL_OUT)/drivers/input/keyboard/rpmsg-keys.ko \
    $(KERNEL_OUT)/drivers/iio/buffer/kfifo_buf.ko \
    $(KERNEL_OUT)/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.ko \
    $(KERNEL_OUT)/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.ko \
    $(KERNEL_OUT)/drivers/iio/buffer/industrialio-triggered-buffer.ko \
    $(KERNEL_OUT)/drivers/iio/pressure/mpl3115.ko \
    $(KERNEL_OUT)/drivers/iio/imu/rpmsg_iio_pedometer.ko \
    $(KERNEL_OUT)/drivers/iio/health/max30102.ko \
    $(KERNEL_OUT)/drivers/iio/light/tsl2540.ko \
    $(KERNEL_OUT)/drivers/mtd/mtd.ko \
    $(KERNEL_OUT)/drivers/mtd/chips/chipreg.ko \
    $(KERNEL_OUT)/drivers/mtd/parsers/ofpart.ko \
    $(KERNEL_OUT)/drivers/spi/spi-fsl-lpspi.ko \
    $(KERNEL_OUT)/drivers/spi/spidev.ko \
    $(KERNEL_OUT)/drivers/spi/spi-nxp-fspi.ko \
    $(KERNEL_OUT)/drivers/mtd/spi-nor/spi-nor.ko \
    $(KERNEL_OUT)/drivers/net/phy/micrel.ko \
    $(KERNEL_OUT)/drivers/net/ethernet/freescale/fec.ko \
    $(KERNEL_OUT)/drivers/soc/imx/imx8ulp_lpm.ko \
    $(KERNEL_OUT)/drivers/leds/leds-pwm.ko
endif

# -------@block_storage-------
# the bootloader image used in dual-bootloader OTA
BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8ulp-trusty-dual.img
