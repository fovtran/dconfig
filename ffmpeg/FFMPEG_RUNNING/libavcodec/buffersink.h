https://ffmpeg.org/doxygen/0.9/buffersink_8h-source.html


#ifndef AVFILTER_VSINK_BUFFER_H
#define AVFILTER_VSINK_BUFFER_H

#include "avfilter.h"

typedef struct {
    const enum PixelFormat *pixel_fmts; 
} AVBufferSinkParams;

AVBufferSinkParams *av_buffersink_params_alloc(void);

typedef struct {
    const enum AVSampleFormat *sample_fmts; 
    const int64_t *channel_layouts;         
    const int *packing_fmts;                
} AVABufferSinkParams;

AVABufferSinkParams *av_abuffersink_params_alloc(void);

#define AV_BUFFERSINK_FLAG_PEEK 1

int av_buffersink_get_buffer_ref(AVFilterContext *buffer_sink,
                                 AVFilterBufferRef **bufref, int flags);


int av_buffersink_poll_frame(AVFilterContext *ctx);

#if FF_API_OLD_VSINK_API

attribute_deprecated
int av_vsink_buffer_get_video_buffer_ref(AVFilterContext *buffer_sink,
                                         AVFilterBufferRef **picref, int flags);
#endif

#endif /* AVFILTER_VSINK_BUFFER_H */