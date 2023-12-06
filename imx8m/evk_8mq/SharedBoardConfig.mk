# -------@block_kernel_bootimg-------

KERNEL_NAME := Image.lz4
TARGET_KERNEL_ARCH := arm64
LOADABLE_KERNEL_MODULE ?= true

#NXP 8997 wifi driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/mlan.ko \
    $(TARGET_OUT_INTERMEDIATES)/MXMWIFI_OBJ/moal.ko

# CONFIG_SND_SOC_WM8524: snd-soc-wm8524.ko, wm8524 audio codec
# CONFIG_IMX8MM_LCDIF_CORE: imx8mm-lcdif-core.ko
# CONFIG_PHY_FSL_IMX8MQ_USB: phy-fsl-imx8mq-usb.ko
# CONFIG_USB_DWC3_IMX8MP: dwc3-imx8mp.ko
# CONFIG_TYPEC_SWITCH_GPIO: gpio-switch.ko
# CONFIG_VIDEO_MXC_CAPTURE: only enable compile dir drivers/media/platform/mxc/capture/, no need mxc_v4l2_capture.c which used in imx6/7
# linux bsp team will add new configure for mxc_v4l2_capture.c in lf-5.4 branch.
# CONFIG_MXC_MIPI_CSI: mxc_mipi_csi.ko, mipi driver which get the sensor data and send data to csi
# CONFIG_MXC_CAMERA_OV5640_MIPI_V2: ov5640_camera_mipi_v2.ko, sensor ov5640 driver, the input of mipi
# CONFIG_IMX_SDMA: imx-sdma.ko, sdma used for audio
# CONFIG_SND_SOC_IMX_PCM_DMA: imx-pcm-dma.ko
# CONFIG_SND_SOC_FSL_SAI: snd-soc-fsl-sai.ko, imx core audio
# CONFIG_SND_SOC_IMX_SPDIF: snd-soc-imx-spdif.ko snd-soc-fsl-spdif.ko, sound spdif code
# CONFIG_SND_SOC_IMX_AK5558: snd-soc-ak5558.ko
# CONFIG_SND_SOC_BT_SCO: snd-soc-bt-sco.ko, audio hdmi code
# CONFIG_SND_SOC_IMX_CDNHDMI: snd-soc-hdmi-codec.ko snd-soc-imx-hdmi.ko snd-soc-fsl-aud2htx.ko, used for hdmi audio
# CONFIG_SND_SIMPLE_CARD: snd-soc-simple-card.ko snd-soc-simple-card-utils.ko, connect cpu and codec
# CONFIG_MXC_HANTRO: hantrodec.ko vpu decoder
# CONFIG_MXC_HANTRO_V4L2: vsiv4l2.ko vpu decodder
# CONFIG_RTC_DRV_SNVS: rtc-snvs.ko, snvs driver
# CONFIG_AT803X_PHY: ethernet phy driver at803x.ko
# CONFIG_FEC: fec.ko which depend on pps_core.ko and ptp.ko

ifeq ($(LOADABLE_KERNEL_MODULE),true)
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/mm/zsmalloc.ko \
    $(KERNEL_OUT)/drivers/block/zram/zram.ko \
    $(KERNEL_OUT)/net/wireless/cfg80211.ko \
    $(KERNEL_OUT)/net/mac80211/mac80211.ko \
    $(KERNEL_OUT)/drivers/mxc/gpu-viv/galcore.ko \
    $(KERNEL_OUT)/drivers/thermal/qoriq_thermal.ko \
    $(KERNEL_OUT)/drivers/media/platform/imx8/mxc-mipi-csi2_yav.ko \
    $(KERNEL_OUT)/drivers/media/platform/mxc/capture/mx6s_capture.ko \
    $(KERNEL_OUT)/drivers/media/platform/mxc/capture/mxc_mipi_csi.ko \
    $(KERNEL_OUT)/drivers/media/platform/mxc/capture/ov5640_camera_mipi_v2.ko \
    $(KERNEL_OUT)/sound/soc/fsl/imx-pcm-dma.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-aud2htx.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-utils.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-sai.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-hdmi-codec.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-hdmi.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-fsl-spdif.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-spdif.ko \
    $(KERNEL_OUT)/sound/soc/fsl/snd-soc-imx-card.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-wm8524.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-ak5558.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-ak4458.ko \
    $(KERNEL_OUT)/sound/soc/codecs/snd-soc-bt-sco.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card.ko \
    $(KERNEL_OUT)/sound/soc/generic/snd-soc-simple-card-utils.ko \
    $(KERNEL_OUT)/drivers/mxc/hantro/hantrodec.ko \
    $(KERNEL_OUT)/drivers/mxc/hantro_v4l2/vsiv4l2.ko \
    $(KERNEL_OUT)/drivers/rtc/rtc-snvs.ko \
    $(KERNEL_OUT)/drivers/pci/controller/dwc/pci-imx6.ko \
    $(KERNEL_OUT)/drivers/net/phy/at803x.ko \
    $(KERNEL_OUT)/drivers/net/ethernet/freescale/fec.ko
endif

# CONFIG_TOUCHSCREEN_GOODIX: goodix_ts.ko, rm67199 mipi-panel touch driver module
# CONFIG_TOUCHSCREEN_SYNAPTICS_DSX_I2C: synaptics_dsx_i2c.ko, rm67191 mipi-panel touch driver module
# CONFIG_ZRAM: zram.ko compressed ram using LZ coding.
# CONFIG_ZSMALLOC: zsmalloc.ko
# CONFIG_CLK_IMX8MP: clk-imx8mq.ko
# CONFIG_TIMER_IMX_SYS_CTR: timer-imx-sysctr.ko
# CONFIG_IMX8M_BUSFREQ: busfreq-imx8mq.ko
# CONFIG_IMX_IRQSTEER: irq-imx-irqsteer.ko
# CONFIG_PINCTRL_IMX: pinctrl-imx.ko
# CONFIG_PINCTRL_IMX8MQ: pinctrl-imx8mq.ko
# CONFIG_SERIAL_IMX: imx.ko
# CONFIG_IMX2_WDT: imx2_wdt.ko
# CONFIG_GPIO_MXC: gpio-generic.ko gpio-mxc.ko
# CONFIG_CPUFREQ_DT: cpufreq-dt.ko
# CONFIG_ARM_IMX_CPUFREQ_DT: imx-cpufreq-dt.ko
# CONFIG_NVMEM_IMX_OCOTP: nvmem-imx-ocotp.ko
# CONFIG_PWM_IMX27: pwm-imx27.ko
# CONFIG_MMC_SDHCI_ESDHC_IMX: sdhci-esdhc-imx.ko, cqhci.ko
# CONFIG_I2C_IMX: i2c-imx.ko
# CONFIG_IMX_MBOX: imx-mailbox.ko, imx mailbox driver
# CONFIG_SND_IMX_SOC: SoC Audio for Freescale i.MX CPUs
# CONFIG_DMABUF_HEAPS_SYSTEM: system_heap.ko
# CONFIG_DMABUF_HEAPS_CMA: cma_heap.ko
# CONFIG_DMABUF_IMX: dma-buf-imx.ko
# CONFIG_RESET_IMX7: reset-imx7.ko
# CONFIG_PHY_FSL_IMX8MQ_USB: phy-fsl-imx8mq-usb.ko
# CONFIG_KEYBOARD_SNVS_PWRKEY: snvs_pwrkey.ko, snvs power key driver
# CONFIG_IMX8MM_LCDIF_CORE: imx8mm-lcdif-core.ko
# CONFIG_DRM_I2C_ADV7511: adv7511.ko
# CONFIG_DRM_IMX_CDNS_MHDP: cdns_mhdp_drmcore.ko cdns_mhdp_imx.ko
# CONFIG_DRM_IMX: imxdrm.ko imx8mm-lcdif-crtc.ko
# CONFIG_USB_DWC3: dwc3-imx8mp.ko
# CONFIG_TYPEC_SWITCH_GPIO: gpio-switch.ko
# CONFIG_VIDEO_IMX_CAPTURE: imx8-media-dev.ko, imx8-isi-capture.ko, imx8-isi-hw.ko, imx8-isi-mem2mem.ko, imx8-mipi-csi2-sam.ko, imx isi and mipi driver
# CONFIG_CFG80211: cfg80211.ko, cfg80211 - wireless configuration API
# CONFIG_MAC80211: mac80211.ko, Generic IEEE 802.11 Networking Stack

ifeq ($(LOADABLE_KERNEL_MODULE),true)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/clk/imx/mxc-clk.ko \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx8mq.ko \
    $(KERNEL_OUT)/drivers/soc/imx/soc-imx8m.ko \
    $(KERNEL_OUT)/drivers/soc/imx/gpcv2.ko \
    $(KERNEL_OUT)/drivers/soc/imx/gpcv2-imx.ko \
    $(KERNEL_OUT)/drivers/clocksource/timer-imx-sysctr.ko \
    $(KERNEL_OUT)/drivers/soc/imx/busfreq-imx8mq.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-ipc.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-core.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-irq.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-log.ko \
    $(KERNEL_OUT)/drivers/trusty/trusty-virtio.ko \
    $(KERNEL_OUT)/drivers/irqchip/irq-imx-irqsteer.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx8mq.ko \
    $(KERNEL_OUT)/drivers/tty/serial/imx.ko \
    $(KERNEL_OUT)/drivers/watchdog/imx2_wdt.ko \
    $(KERNEL_OUT)/drivers/regulator/pca9450-regulator.ko \
    $(KERNEL_OUT)/drivers/regulator/gpio-regulator.ko \
    $(KERNEL_OUT)/drivers/regulator/pfuze100-regulator.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-mxc.ko \
    $(KERNEL_OUT)/drivers/perf/fsl_imx8_ddr_perf.ko \
    $(KERNEL_OUT)/drivers/cpufreq/cpufreq-dt.ko \
    $(KERNEL_OUT)/drivers/cpufreq/imx-cpufreq-dt.ko \
    $(KERNEL_OUT)/drivers/nvmem/nvmem-imx-ocotp.ko \
    $(KERNEL_OUT)/drivers/pwm/pwm-imx27.ko \
    $(KERNEL_OUT)/drivers/mmc/host/sdhci-esdhc-imx.ko \
    $(KERNEL_OUT)/drivers/mmc/host/cqhci.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-imx.ko \
    $(KERNEL_OUT)/drivers/i2c/i2c-dev.ko \
    $(KERNEL_OUT)/drivers/spi/spi-fsl-qspi.ko \
    $(KERNEL_OUT)/drivers/spi/spi-bitbang.ko \
    $(KERNEL_OUT)/drivers/spi/spi-imx.ko \
    $(KERNEL_OUT)/lib/stmp_device.ko \
    $(KERNEL_OUT)/drivers/dma/mxs-dma.ko \
    $(KERNEL_OUT)/drivers/mailbox/imx-mailbox.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/system_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/heaps/cma_heap.ko \
    $(KERNEL_OUT)/drivers/dma-buf/dma-buf-imx.ko \
    $(KERNEL_OUT)/drivers/reset/gpio-reset.ko \
    $(KERNEL_OUT)/drivers/reset/reset-imx7.ko \
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-imx8-mipi-dphy.ko \
    $(KERNEL_OUT)/drivers/phy/freescale/phy-fsl-imx8mq-usb.ko \
    $(KERNEL_OUT)/drivers/input/keyboard/snvs_pwrkey.ko \
    $(KERNEL_OUT)/drivers/input/touchscreen/goodix_ts.ko \
    $(KERNEL_OUT)/drivers/input/touchscreen/synaptics_dsx/synaptics_dsx_i2c.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/panel/panel-raydium-rm67191.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/dcss/imx-dcss.ko \
    $(KERNEL_OUT)/drivers/gpu/imx/lcdif/imx8mm-lcdif-core.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/drm_dma_helper.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/display/drm_display_helper.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/adv7511/adv7511.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/cadence/cdns_mhdp_drmcore.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/mhdp/cdns_mhdp_imx.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imxdrm.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/lcdif/imx8mm-lcdif-crtc.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/mxsfb/mxsfb.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/nwl-dsi.ko \
    $(KERNEL_OUT)/drivers/mux/mux-mmio.ko \
    $(KERNEL_OUT)/drivers/mux/mux-core.ko \
    $(KERNEL_OUT)/drivers/usb/dwc3/dwc3-imx8mp.ko \
    $(KERNEL_OUT)/drivers/usb/typec/mux/gpio-switch.ko \
    $(KERNEL_OUT)/drivers/power/supply/dummy_battery.ko \
    $(KERNEL_OUT)/drivers/media/rc/gpio-ir-recv.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-async.ko \
    $(KERNEL_OUT)/drivers/media/v4l2-core/v4l2-fwnode.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-capture.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-hw.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-isi-mem2mem.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-mipi-csi2-sam.ko \
    $(KERNEL_OUT)/drivers/staging/media/imx/imx8-media-dev.ko \
    $(KERNEL_OUT)/drivers/dma/imx-sdma.ko
else
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/input/touchscreen/goodix_ts.ko \
    $(KERNEL_OUT)/drivers/input/touchscreen/synaptics_dsx/synaptics_dsx_i2c.ko
endif

# -------@block_security-------
#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

# -------@block_storage-------
# the bootloader image used in dual-bootloader OTA
BOARD_OTA_BOOTLOADERIMAGE := bootloader-imx8mq-trusty-wevk-dual.img
