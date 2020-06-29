KERNEL_NAME := Image
TARGET_KERNEL_ARCH := arm64
# IMX8MM_USES_GKI := true
# after selecting the target by "lunch" command, TARGET_PRODUCT will be set
ifeq ($(TARGET_PRODUCT),evk_8mm_ddr4)
  PRODUCT_8MM_DDR4 := true
endif

#Enable this to config 1GB ddr on evk_imx8mm
#LOW_MEMORY := true

#Enable this to include trusty support
PRODUCT_IMX_TRUSTY := true

#Enable this to disable product partition build.
#IMX_NO_PRODUCT_PARTITION := true

# mipi-panel touch driver module
BOARD_VENDOR_KERNEL_MODULES += \
    $(KERNEL_OUT)/drivers/input/touchscreen/synaptics_dsx/synaptics_dsx_i2c.ko

# CONFIG_CLK_IMX8MM: clk-imx8mm.ko
# CONFIG_IMX8M_PM_DOMAINS: imx8m_pm_domains.ko, this driver still not upstream
# CONFIG_PINCTRL_IMX8MM: pinctrl-imx8mm.ko
# CONFIG_SERIAL_IMX: imx.ko
# CONFIG_IMX2_WDT: imx2_wdt.ko
# CONFIG_MFD_ROHM_BD718XX: rohm-bd718x7.ko
# CONFIG_GPIO_MXC: gpio-generic.ko gpio-mxc.ko
# CONFIG_MMC_SDHCI_ESDHC_IMX: sdhci-esdhc-imx.ko cqhci.ko
# CONFIG_I2C_IMX:i2c-imx.ko
# CONFIG_ION_CMA_HEAP: ion_cma_heap.ko
# depend on clk module: reset-dispmix.ko, it will been select as m if clk build as m.
# CONFIG_IMX_LCDIF_CORE: imx-lcdif-core.ko
# CONFIG_DRM_IMX: imxdrm.ko imx-lcdif-crtc.ko
# CONFIG_DRM_SEC_MIPI_DSIM: sec-dsim.ko
# CONFIG_DRM_IMX_SEC_DSIM: sec_mipi_dsim-imx.ko
# CONFIG_DRM_I2C_ADV7511: adv7511.ko cec.ko
# CONFIG_USB_CHIPIDEA_OF: usbmisc_imx.ko ci_hdrc_imx.ko
# CONFIG_USB_CHIPIDEA: ci_hdrc.ko
# CONFIG_NOP_USB_XCEIV: phy-generic.ko
# CONFIG_TYPEC_TCPCI: tcpci.ko
# CONFIG_USB_EHCI_HCD: ehci-hcd.ko

ifneq ($(IMX8MM_USES_GKI),)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES +=     \
    $(KERNEL_OUT)/drivers/clk/imx/clk-imx8mm.ko \
    $(KERNEL_OUT)/drivers/soc/imx/imx8m_pm_domains.ko \
    $(KERNEL_OUT)/drivers/pinctrl/freescale/pinctrl-imx8mm.ko \
    $(KERNEL_OUT)/drivers/tty/serial/imx.ko \
    $(KERNEL_OUT)/drivers/watchdog/imx2_wdt.ko \
    $(KERNEL_OUT)/drivers/mfd/rohm-bd718x7.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-generic.ko \
    $(KERNEL_OUT)/drivers/gpio/gpio-mxc.ko \
    $(KERNEL_OUT)/drivers/mmc/host/sdhci-esdhc-imx.ko \
    $(KERNEL_OUT)/drivers/mmc/host/cqhci.ko \
    $(KERNEL_OUT)/drivers/i2c/busses/i2c-imx.ko \
    $(KERNEL_OUT)/drivers/staging/android/ion/heaps/ion_cma_heap.ko \
    $(KERNEL_OUT)/drivers/reset/reset-dispmix.ko \
    $(KERNEL_OUT)/drivers/gpu/imx/lcdif/imx-lcdif-core.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/lcdif/imx-lcdif-crtc.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/imxdrm.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/sec-dsim.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/imx/sec_mipi_dsim-imx.ko \
    $(KERNEL_OUT)/drivers/media/cec/cec.ko \
    $(KERNEL_OUT)/drivers/gpu/drm/bridge/adv7511/adv7511.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/usbmisc_imx.ko \
    $(KERNEL_OUT)/drivers/usb/common/ulpi.ko \
    $(KERNEL_OUT)/drivers/usb/host/ehci-hcd.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc_imx.ko \
    $(KERNEL_OUT)/drivers/usb/chipidea/ci_hdrc.ko \
    $(KERNEL_OUT)/drivers/usb/phy/phy-generic.ko \
    $(KERNEL_OUT)/drivers/usb/typec/tcpm/tcpci.ko
endif
