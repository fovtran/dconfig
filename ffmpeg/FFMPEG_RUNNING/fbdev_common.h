/*
 * This file is part of FFmpeg.
 */

#ifndef AVDEVICE_FBDEV_COMMON_H
#define AVDEVICE_FBDEV_COMMON_H

#include <features.h>
#include <linux/fb.h>
#include "libavutil/pixfmt.h"

struct AVDeviceInfoList;
enum AVPixelFormat ff_get_pixfmt_from_fb_varinfo(struct fb_var_screeninfo *varinfo);
const char* ff_fbdev_default_device(void);
int ff_fbdev_get_device_list(struct AVDeviceInfoList *device_list);

#endif /* AVDEVICE_FBDEV_COMMON_H */
