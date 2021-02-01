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
#ifndef _UAPI__LINUX_IMX_VPU_H
#define _UAPI__LINUX_IMX_VPU_H
#include <linux/videodev2.h>
#include <linux/v4l2-controls.h>
#define V4L2_CID_NON_FRAME (V4L2_CID_USER_IMX_BASE)
#define V4L2_CID_DIS_REORDER (V4L2_CID_USER_IMX_BASE + 1)
#define V4L2_MAX_ROI_REGIONS 8
struct v4l2_enc_roi_param {
  struct v4l2_rect rect;
  __u32 enable;
  __s32 qp_delta;
  __u32 reserved[2];
};
struct v4l2_enc_roi_params {
  __u32 num_roi_regions;
  struct v4l2_enc_roi_param roi_params[V4L2_MAX_ROI_REGIONS];
  __u32 config_store;
  __u32 reserved[2];
};
#define V4L2_CID_ROI_COUNT (V4L2_CID_USER_IMX_BASE + 2)
#define V4L2_CID_ROI (V4L2_CID_USER_IMX_BASE + 3)
#define V4L2_MAX_IPCM_REGIONS 2
struct v4l2_enc_ipcm_param {
  struct v4l2_rect rect;
  __u32 enable;
  __u32 reserved[2];
};
struct v4l2_enc_ipcm_params {
  __u32 num_ipcm_regions;
  struct v4l2_enc_ipcm_param ipcm_params[V4L2_MAX_IPCM_REGIONS];
  __u32 config_store;
  __u32 reserved[2];
};
#define V4L2_CID_IPCM_COUNT (V4L2_CID_USER_IMX_BASE + 4)
#define V4L2_CID_IPCM (V4L2_CID_USER_IMX_BASE + 5)
#define V4L2_DEC_CMD_IMX_BASE (0x08000000)
#define V4L2_DEC_CMD_RESET (V4L2_DEC_CMD_IMX_BASE + 1)
#define V4L2_EVENT_CODEC_ERROR (V4L2_EVENT_PRIVATE_START + 1)
#define V4L2_EVENT_SKIP (V4L2_EVENT_PRIVATE_START + 2)
#define V4L2_EVENT_CROPCHANGE (V4L2_EVENT_PRIVATE_START + 3)
#define V4L2_EVENT_INVALID_OPTION (V4L2_EVENT_PRIVATE_START + 4)
#define V4L2_PIX_FMT_BGR565 v4l2_fourcc('B', 'G', 'R', 'P')
#define V4L2_PIX_FMT_NV12X v4l2_fourcc('N', 'V', 'X', '2')
#define V4L2_PIX_FMT_DTRC v4l2_fourcc('D', 'T', 'R', 'C')
#define V4L2_PIX_FMT_P010 v4l2_fourcc('P', '0', '1', '0')
#define V4L2_PIX_FMT_TILEX v4l2_fourcc('D', 'T', 'R', 'X')
#define V4L2_PIX_FMT_AV1 v4l2_fourcc('A', 'V', '1', '0')
#define V4L2_PIX_FMT_RV v4l2_fourcc('R', 'V', '0', '0')
#define V4L2_PIX_FMT_AVS v4l2_fourcc('A', 'V', 'S', '0')
#endif
