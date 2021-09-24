
.PHONY : IMX_INSTALLED_RECOVERYIMAGE_TARGET
ifneq (true, $(strip $(filter true, $(BOARD_USES_RECOVERY_AS_BOOT) $(BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT))))

$(BOARD_PREBUILT_RECOVERY_DTBOIMAGE) : $(TARGET_DTB) | $(MKDTIMG)
	for dtsplat in $(TARGET_BOARD_DTS_CONFIG); do \
		DTS_PLATFORM=`echo $$dtsplat | cut -d':' -f1`; \
		DTB_NAME=`echo $$dtsplat | cut -d':' -f2`; \
		DTB=`echo $(KERNEL_OUT)/arch/$(TARGET_KERNEL_ARCH)/boot/dts/$(DTS_ADDITIONAL_PATH)/$${DTB_NAME}`; \
		DTBO_IMG_NO_FOOTER=`echo $(PRODUCT_OUT)/dtbo-no-footer-$${DTS_PLATFORM}.img`; \
		$(MKDTIMG) create $$DTBO_IMG_NO_FOOTER $$DTB; \
	done

IMX_INSTALLED_RECOVERYIMAGE_TARGET : $(PRODUCT_OUT)/recovery.img $(BOARD_PREBUILT_DTBOIMAGE) $(BOARD_PREBUILT_RECOVERY_DTBOIMAGE)
	$(eval INTERNAL_RECOVERYIMAGE_ARGS_BACK := $(INTERNAL_RECOVERYIMAGE_ARGS))
	$(foreach dtsplat,$(TARGET_BOARD_DTS_CONFIG), \
		$(eval DTS_PLATFORM := $(firstword $(subst :, ,$(dtsplat)))) \
		$(eval TEMP_BOARD_PREBUILT_DTBOIMAGE := $(PRODUCT_OUT)/dtbo-no-footer-$(DTS_PLATFORM).img) \
		$(eval INTERNAL_RECOVERYIMAGE_ARGS := $(INTERNAL_RECOVERYIMAGE_ARGS_BACK) --recovery_dtbo $(TEMP_BOARD_PREBUILT_DTBOIMAGE)) \
		$(call build-recoveryimage-target,$(PRODUCT_OUT)/recovery-$(DTS_PLATFORM).img,$(PRODUCT_OUT)/kernel);)
	cp $(PRODUCT_OUT)/recovery-$(shell echo $(word 1,$(TARGET_BOARD_DTS_CONFIG)) | cut -d':' -f1).img $(PRODUCT_OUT)/recovery.img
else
IMX_INSTALLED_RECOVERYIMAGE_TARGET :
endif
