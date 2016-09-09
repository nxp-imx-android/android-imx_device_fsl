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
#ifndef _UAPI_PXP_DMA
#define _UAPI_PXP_DMA
#include <linux/posix_types.h>
#include <linux/types.h>
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
typedef unsigned long dma_addr_t;
#define fourcc(a,b,c,d) (((__u32) (a) << 0) | ((__u32) (b) << 8) | ((__u32) (c) << 16) | ((__u32) (d) << 24))
#define PXP_PIX_FMT_RGB332 fourcc('R', 'G', 'B', '1')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_RGB555 fourcc('R', 'G', 'B', 'O')
#define PXP_PIX_FMT_RGB565 fourcc('R', 'G', 'B', 'P')
#define PXP_PIX_FMT_RGB666 fourcc('R', 'G', 'B', '6')
#define PXP_PIX_FMT_BGR666 fourcc('B', 'G', 'R', '6')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_BGR24 fourcc('B', 'G', 'R', '3')
#define PXP_PIX_FMT_RGB24 fourcc('R', 'G', 'B', '3')
#define PXP_PIX_FMT_BGR32 fourcc('B', 'G', 'R', '4')
#define PXP_PIX_FMT_BGRA32 fourcc('B', 'G', 'R', 'A')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_RGB32 fourcc('R', 'G', 'B', '4')
#define PXP_PIX_FMT_RGBA32 fourcc('R', 'G', 'B', 'A')
#define PXP_PIX_FMT_ABGR32 fourcc('A', 'B', 'G', 'R')
#define PXP_PIX_FMT_YUYV fourcc('Y', 'U', 'Y', 'V')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_UYVY fourcc('U', 'Y', 'V', 'Y')
#define PXP_PIX_FMT_VYUY fourcc('V', 'Y', 'U', 'Y')
#define PXP_PIX_FMT_YVYU fourcc('Y', 'V', 'Y', 'U')
#define PXP_PIX_FMT_Y41P fourcc('Y', '4', '1', 'P')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_VUY444 fourcc('V', 'U', 'Y', 'A')
#define PXP_PIX_FMT_NV12 fourcc('N', 'V', '1', '2')
#define PXP_PIX_FMT_NV21 fourcc('N', 'V', '2', '1')
#define PXP_PIX_FMT_NV16 fourcc('N', 'V', '1', '6')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_NV61 fourcc('N', 'V', '6', '1')
#define PXP_PIX_FMT_GREY fourcc('G', 'R', 'E', 'Y')
#define PXP_PIX_FMT_GY04 fourcc('G', 'Y', '0', '4')
#define PXP_PIX_FMT_YVU410P fourcc('Y', 'V', 'U', '9')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_YUV410P fourcc('Y', 'U', 'V', '9')
#define PXP_PIX_FMT_YVU420P fourcc('Y', 'V', '1', '2')
#define PXP_PIX_FMT_YUV420P fourcc('I', '4', '2', '0')
#define PXP_PIX_FMT_YUV420P2 fourcc('Y', 'U', '1', '2')
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_PIX_FMT_YVU422P fourcc('Y', 'V', '1', '6')
#define PXP_PIX_FMT_YUV422P fourcc('4', '2', '2', 'P')
#define PXP_LUT_NONE 0x0
#define PXP_LUT_INVERT 0x1
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_LUT_BLACK_WHITE 0x2
#define PXP_LUT_USE_CMAP 0x4
#define PXP_DITHER_PASS_THROUGH 0
#define PXP_DITHER_FLOYD 1
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_DITHER_ATKINSON 2
#define PXP_DITHER_ORDERED 3
#define PXP_DITHER_QUANT_ONLY 4
#define NR_PXP_VIRT_CHANNEL 16
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_IOC_MAGIC 'P'
#define PXP_IOC_GET_CHAN _IOR(PXP_IOC_MAGIC, 0, struct pxp_mem_desc)
#define PXP_IOC_PUT_CHAN _IOW(PXP_IOC_MAGIC, 1, struct pxp_mem_desc)
#define PXP_IOC_CONFIG_CHAN _IOW(PXP_IOC_MAGIC, 2, struct pxp_mem_desc)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_IOC_START_CHAN _IOW(PXP_IOC_MAGIC, 3, struct pxp_mem_desc)
#define PXP_IOC_GET_PHYMEM _IOWR(PXP_IOC_MAGIC, 4, struct pxp_mem_desc)
#define PXP_IOC_PUT_PHYMEM _IOW(PXP_IOC_MAGIC, 5, struct pxp_mem_desc)
#define PXP_IOC_WAIT4CMPLT _IOWR(PXP_IOC_MAGIC, 6, struct pxp_mem_desc)
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#define PXP_IOC_FILL_DATA _IOWR(PXP_IOC_MAGIC, 7, struct pxp_mem_desc)
enum pxp_channel_status {
  PXP_CHANNEL_FREE,
  PXP_CHANNEL_INITIALIZED,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_CHANNEL_READY,
};
enum pxp_working_mode {
  PXP_MODE_LEGACY = 0x1,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_MODE_STANDARD = 0x2,
  PXP_MODE_ADVANCED = 0x4,
};
enum pxp_buffer_flag {
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_BUF_FLAG_WFE_A_FETCH0 = 0x0001,
  PXP_BUF_FLAG_WFE_A_FETCH1 = 0x0002,
  PXP_BUF_FLAG_WFE_A_STORE0 = 0x0004,
  PXP_BUF_FLAG_WFE_A_STORE1 = 0x0008,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_BUF_FLAG_WFE_B_FETCH0 = 0x0010,
  PXP_BUF_FLAG_WFE_B_FETCH1 = 0x0020,
  PXP_BUF_FLAG_WFE_B_STORE0 = 0x0040,
  PXP_BUF_FLAG_WFE_B_STORE1 = 0x0080,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_BUF_FLAG_DITHER_FETCH0 = 0x0100,
  PXP_BUF_FLAG_DITHER_FETCH1 = 0x0200,
  PXP_BUF_FLAG_DITHER_STORE0 = 0x0400,
  PXP_BUF_FLAG_DITHER_STORE1 = 0x0800,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
enum pxp_engine_ctrl {
  PXP_ENABLE_ROTATE0 = 0x001,
  PXP_ENABLE_ROTATE1 = 0x002,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_ENABLE_LUT = 0x004,
  PXP_ENABLE_CSC2 = 0x008,
  PXP_ENABLE_ALPHA_B = 0x010,
  PXP_ENABLE_INPUT_FETCH_SOTRE = 0x020,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_ENABLE_WFE_B = 0x040,
  PXP_ENABLE_WFE_A = 0x080,
  PXP_ENABLE_DITHER = 0x100,
  PXP_ENABLE_PS_AS_OUT = 0x200,
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  PXP_ENABLE_COLLISION_DETECT = 0x400,
  PXP_ENABLE_HANDSHAKE = 0x1000,
  PXP_ENABLE_DITHER_BYPASS = 0x2000,
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
struct rect {
  int top;
  int left;
  int width;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int height;
};
struct pxp_layer_param {
  unsigned short left;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned short top;
  unsigned short width;
  unsigned short height;
  unsigned short stride;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned int pixel_fmt;
  unsigned int flag;
  char combine_enable;
  unsigned int color_key_enable;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned int color_key;
  char global_alpha_enable;
  char global_override;
  unsigned char global_alpha;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  char alpha_invert;
  char local_alpha_enable;
  int comp_mask;
  dma_addr_t paddr;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct pxp_collision_info {
  unsigned int pixel_cnt;
  unsigned int rect_min_x;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned int rect_min_y;
  unsigned int rect_max_x;
  unsigned int rect_max_y;
  unsigned int victim_luts[2];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
};
struct pxp_proc_data {
  int scaling;
  int hflip;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int vflip;
  int rotate;
  int rot_pos;
  int yuv;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct rect srect;
  struct rect drect;
  unsigned int bgcolor;
  int overlay_state;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int lut_transform;
  unsigned char * lut_map;
  char lut_map_updated;
  char combine_enable;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  enum pxp_working_mode working_mode;
  enum pxp_engine_ctrl engine_enable;
  char partial_update;
  char alpha_en;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  char lut_update;
  char reagl_en;
  char reagl_d_en;
  char detection_only;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  int lut;
  unsigned int lut_status_1;
  unsigned int lut_status_2;
  int dither_mode;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  unsigned int quant_bit;
};
struct pxp_config_data {
  struct pxp_layer_param s0_param;
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct pxp_layer_param ol_param[8];
  struct pxp_layer_param out_param;
  struct pxp_layer_param wfe_a_fetch_param[2];
  struct pxp_layer_param wfe_a_store_param[2];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct pxp_layer_param wfe_b_fetch_param[2];
  struct pxp_layer_param wfe_b_store_param[2];
  struct pxp_layer_param dither_fetch_param[2];
  struct pxp_layer_param dither_store_param[2];
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
  struct pxp_proc_data proc_data;
  int layer_nr;
  int handle;
};
/* WARNING: DO NOT EDIT, AUTO-GENERATED CODE - SEE TOP FOR INSTRUCTIONS */
#endif
