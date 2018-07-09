# Copyright (C) 2018 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

KERNEL_TOOLCHAIN_ABS := $(realpath $(TARGET_TOOLCHAIN_ROOT)/bin)
TARGET_KERNEL_ARCH := $(strip $(TARGET_KERNEL_ARCH))
TARGET_KERNEL_SRC := $(KERNEL_IMX_PATH)/kernel_imx
KERNEL_CC_WRAPPER := $(CC_WRAPPER)
KERNEL_AFLAGS :=
KERNEL_CFLAGS :=

ifeq ($(TARGET_KERNEL_ARCH), arm)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/arm-linux-androidkernel-
KERNEL_SRC_ARCH := arm
DTS_ADDITIONAL_PATH :=
else ifeq ($(TARGET_KERNEL_ARCH), arm64)
KERNEL_CROSS_COMPILE := $(KERNEL_TOOLCHAIN_ABS)/aarch64-linux-androidkernel-
KERNEL_SRC_ARCH := arm64
DTS_ADDITIONAL_PATH := freescale
else
$(error kernel arch not supported at present)
endif

# Use ccache if requested by USE_CCACHE variable
KERNEL_CROSS_COMPILE_WRAPPER := $(realpath $(KERNEL_CC_WRAPPER)) $(KERNEL_CROSS_COMPILE)

MKDTIMG := $(HOST_OUT_EXECUTABLES)/mkdtimg
DTS_PATH := $(TARGET_KERNEL_SRC)/arch/$(KERNEL_SRC_ARCH)/boot/dts/$(DTS_ADDITIONAL_PATH)/
DTS_SRC :=
$(foreach dts_config,$(TARGET_BOARD_DTS_CONFIG), \
    $(eval DTS_SRC += $(addprefix $(DTS_PATH),$(shell echo ${dts_config} | cut -d':' -f2 | sed 's/dtb/dts/g' ))))

define build_dtb
	CCACHE_NODIRECT="true" $(MAKE) -C $(TARGET_KERNEL_SRC) \
	O=$(realpath $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ) \
	ARCH=$(KERNEL_ARCH) \
	CROSS_COMPILE="$(KERNEL_CROSS_COMPILE_WRAPPER)" \
	KCFLAGS="$(KERNEL_CFLAGS)" \
	KAFLAGS="$(KERNEL_AFLAGS)" \
	dtbs
endef

.PHONY: dtboimage
dtboimage: $(KERNEL_CONFIG) $(DTS_SRC) | $(MKDTIMG)
	$(hide) echo "Building $(KERNEL_ARCH) dtbo ..."
	$(hide) rm -rf $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/arch/$(KERNEL_ARCH)/boot/dts
	$(hide) PATH=$$PATH $(MAKE) -C $(TARGET_KERNEL_SRC) mrproper
	$(call build_dtb); \
	for dtsplat in $(TARGET_BOARD_DTS_CONFIG); do \
		DTS_PLATFORM=`echo $$dtsplat | cut -d':' -f1`; \
		DTB_NAME=`echo $$dtsplat | cut -d':' -f2`; \
		DTB=`echo $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/arch/$(TARGET_KERNEL_ARCH)/boot/dts/$(DTS_ADDITIONAL_PATH)/$${DTB_NAME}`; \
		DTBO_IMG=`echo $(PRODUCT_OUT)/dtbo-$${DTS_PLATFORM}.img`; \
		$(MKDTIMG) create $$DTBO_IMG $$DTB; \
	done
droid: dtboimage
