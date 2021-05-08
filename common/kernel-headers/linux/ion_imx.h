/****************************************************************************
 ****************************************************************************
 ***
 ***   This header was automatically generated from a Linux kernel header
 ***   of the same name, to make information necessary for userspace to
 ***   call into the kernel available to libc.  It contains only constants,
 ***   structures, and macros generated from the original header, and thus,
 ***   contains no copyrightable information.
 ***
 ***   To edit the content of this header, modify the corresponding
 ***   source file (e.g. under external/kernel-headers/original/) then
 ***   run bionic/libc/kernel/tools/update_all.py
 ***
 ***   Any manual change here will be lost the next time this script will
 ***   be run. You've been warned!
 ***
 ****************************************************************************
 ****************************************************************************/
#ifndef _LINUX_ION_IMX_H
#define _LINUX_ION_IMX_H
#include <linux/ion.h>
struct ion_imx_phys_data {
  int dmafd;
  unsigned long phys;
};
#define ION_GET_PHYS _IOWR(ION_IOC_MAGIC, 15, struct ion_imx_phys_data)
#endif
