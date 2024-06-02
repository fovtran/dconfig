https://ffmpeg.org/doxygen/0.9/avfilter_8h-source.html


#ifndef AVFILTER_AVFILTER_H
#define AVFILTER_AVFILTER_H

#include "libavutil/avutil.h"
#include "libavutil/log.h"
#include "libavutil/samplefmt.h"
#include "libavutil/pixfmt.h"
#include "libavutil/rational.h"

#define LIBAVFILTER_VERSION_MAJOR  2
#define LIBAVFILTER_VERSION_MINOR 53
#define LIBAVFILTER_VERSION_MICRO  0

#define LIBAVFILTER_VERSION_INT AV_VERSION_INT(LIBAVFILTER_VERSION_MAJOR, \
                                               LIBAVFILTER_VERSION_MINOR, \
                                               LIBAVFILTER_VERSION_MICRO)
#define LIBAVFILTER_VERSION     AV_VERSION(LIBAVFILTER_VERSION_MAJOR,   \
                                           LIBAVFILTER_VERSION_MINOR,   \
                                           LIBAVFILTER_VERSION_MICRO)
#define LIBAVFILTER_BUILD       LIBAVFILTER_VERSION_INT

#ifndef FF_API_OLD_VSINK_API
#define FF_API_OLD_VSINK_API        (LIBAVFILTER_VERSION_MAJOR < 3)
#endif
#ifndef FF_API_OLD_ALL_FORMATS_API
#define FF_API_OLD_ALL_FORMATS_API (LIBAVFILTER_VERSION_MAJOR < 3)
#endif

#include <stddef.h>

unsigned avfilter_version(void);

const char *avfilter_configuration(void);

const char *avfilter_license(void);


typedef struct AVFilterContext AVFilterContext;
typedef struct AVFilterLink    AVFilterLink;
typedef struct AVFilterPad     AVFilterPad;

typedef struct AVFilterBuffer {
    uint8_t *data[8];           
    int linesize[8];            

    unsigned refcount;          

    void *priv;
    void (*free)(struct AVFilterBuffer *buf);

    int format;                 
    int w, h;                   
} AVFilterBuffer;

#define AV_PERM_READ     0x01   
#define AV_PERM_WRITE    0x02   
#define AV_PERM_PRESERVE 0x04   
#define AV_PERM_REUSE    0x08   
#define AV_PERM_REUSE2   0x10   
#define AV_PERM_NEG_LINESIZES 0x20  
#define AV_PERM_ALIGN    0x40   

#define AVFILTER_ALIGN 16 //not part of ABI

typedef struct AVFilterBufferRefAudioProps {
    uint64_t channel_layout;    
    int nb_samples;             
    int sample_rate;            
    int planar;                 
} AVFilterBufferRefAudioProps;

typedef struct AVFilterBufferRefVideoProps {
    int w;                      
    int h;                      
    AVRational sample_aspect_ratio; 
    int interlaced;             
    int top_field_first;        
    enum AVPictureType pict_type; 
    int key_frame;              
} AVFilterBufferRefVideoProps;

typedef struct AVFilterBufferRef {
    AVFilterBuffer *buf;        
    uint8_t *data[8];           
    int linesize[8];            
    int format;                 

    int64_t pts;
    int64_t pos;                

    int perms;                  

    enum AVMediaType type;      
    AVFilterBufferRefVideoProps *video; 
    AVFilterBufferRefAudioProps *audio; 
} AVFilterBufferRef;

static inline void avfilter_copy_buffer_ref_props(AVFilterBufferRef *dst, AVFilterBufferRef *src)
{
    // copy common properties
    dst->pts             = src->pts;
    dst->pos             = src->pos;

    switch (src->type) {
    case AVMEDIA_TYPE_VIDEO: *dst->video = *src->video; break;
    case AVMEDIA_TYPE_AUDIO: *dst->audio = *src->audio; break;
    default: break;
    }
}

AVFilterBufferRef *avfilter_ref_buffer(AVFilterBufferRef *ref, int pmask);

void avfilter_unref_buffer(AVFilterBufferRef *ref);

typedef struct AVFilterFormats {
    unsigned format_count;      
    int64_t *formats;           

    unsigned refcount;          
    struct AVFilterFormats ***refs; 
}  AVFilterFormats;

AVFilterFormats *avfilter_make_format_list(const int *fmts);
AVFilterFormats *avfilter_make_format64_list(const int64_t *fmts);

int avfilter_add_format(AVFilterFormats **avff, int64_t fmt);

#if FF_API_OLD_ALL_FORMATS_API

attribute_deprecated
AVFilterFormats *avfilter_all_formats(enum AVMediaType type);
#endif

AVFilterFormats *avfilter_make_all_formats(enum AVMediaType type);

extern const int64_t avfilter_all_channel_layouts[];

AVFilterFormats *avfilter_make_all_channel_layouts(void);

AVFilterFormats *avfilter_make_all_packing_formats(void);

AVFilterFormats *avfilter_merge_formats(AVFilterFormats *a, AVFilterFormats *b);

void avfilter_formats_ref(AVFilterFormats *formats, AVFilterFormats **ref);

void avfilter_formats_unref(AVFilterFormats **ref);

void avfilter_formats_changeref(AVFilterFormats **oldref,
                                AVFilterFormats **newref);

struct AVFilterPad {
    const char *name;

    enum AVMediaType type;

    int min_perms;

    int rej_perms;

    void (*start_frame)(AVFilterLink *link, AVFilterBufferRef *picref);

    AVFilterBufferRef *(*get_video_buffer)(AVFilterLink *link, int perms, int w, int h);

    AVFilterBufferRef *(*get_audio_buffer)(AVFilterLink *link, int perms, int nb_samples);

    void (*end_frame)(AVFilterLink *link);

    void (*draw_slice)(AVFilterLink *link, int y, int height, int slice_dir);

    void (*filter_samples)(AVFilterLink *link, AVFilterBufferRef *samplesref);

    int (*poll_frame)(AVFilterLink *link);

    int (*request_frame)(AVFilterLink *link);

    int (*config_props)(AVFilterLink *link);
};

void avfilter_default_start_frame(AVFilterLink *link, AVFilterBufferRef *picref);

void avfilter_default_draw_slice(AVFilterLink *link, int y, int h, int slice_dir);

void avfilter_default_end_frame(AVFilterLink *link);

void avfilter_default_filter_samples(AVFilterLink *link, AVFilterBufferRef *samplesref);

AVFilterBufferRef *avfilter_default_get_video_buffer(AVFilterLink *link,
                                                     int perms, int w, int h);

AVFilterBufferRef *avfilter_default_get_audio_buffer(AVFilterLink *link,
                                                     int perms, int nb_samples);

void avfilter_set_common_pixel_formats(AVFilterContext *ctx, AVFilterFormats *formats);
void avfilter_set_common_sample_formats(AVFilterContext *ctx, AVFilterFormats *formats);
void avfilter_set_common_channel_layouts(AVFilterContext *ctx, AVFilterFormats *formats);
void avfilter_set_common_packing_formats(AVFilterContext *ctx, AVFilterFormats *formats);

int avfilter_default_query_formats(AVFilterContext *ctx);

void avfilter_null_start_frame(AVFilterLink *link, AVFilterBufferRef *picref);

void avfilter_null_draw_slice(AVFilterLink *link, int y, int h, int slice_dir);

void avfilter_null_end_frame(AVFilterLink *link);

void avfilter_null_filter_samples(AVFilterLink *link, AVFilterBufferRef *samplesref);

AVFilterBufferRef *avfilter_null_get_video_buffer(AVFilterLink *link,
                                                  int perms, int w, int h);

AVFilterBufferRef *avfilter_null_get_audio_buffer(AVFilterLink *link,
                                                  int perms, int nb_samples);

typedef struct AVFilter {
    const char *name;         

    int priv_size;      

    int (*init)(AVFilterContext *ctx, const char *args, void *opaque);

    void (*uninit)(AVFilterContext *ctx);

    int (*query_formats)(AVFilterContext *);

    const AVFilterPad *inputs;  
    const AVFilterPad *outputs; 

    const char *description;

    int (*process_command)(AVFilterContext *, const char *cmd, const char *arg, char *res, int res_len, int flags);
} AVFilter;

struct AVFilterContext {
    const AVClass *av_class;        

    AVFilter *filter;               

    char *name;                     

    unsigned input_count;           
    AVFilterPad   *input_pads;      
    AVFilterLink **inputs;          

    unsigned output_count;          
    AVFilterPad   *output_pads;     
    AVFilterLink **outputs;         

    void *priv;                     

    struct AVFilterCommand *command_queue;
};

enum AVFilterPacking {
    AVFILTER_PACKED = 0,
    AVFILTER_PLANAR,
};

struct AVFilterLink {
    AVFilterContext *src;       
    AVFilterPad *srcpad;        

    AVFilterContext *dst;       
    AVFilterPad *dstpad;        

    enum {
        AVLINK_UNINIT = 0,      
        AVLINK_STARTINIT,       
        AVLINK_INIT             
    } init_state;

    enum AVMediaType type;      

    /* These parameters apply only to video */
    int w;                      
    int h;                      
    AVRational sample_aspect_ratio; 
    /* These parameters apply only to audio */
    uint64_t channel_layout;    
#if LIBAVFILTER_VERSION_MAJOR < 3
    int64_t sample_rate;        
#else
    int sample_rate;            
#endif
    int planar;                 

    int format;                 

    AVFilterFormats *in_formats;
    AVFilterFormats *out_formats;

    AVFilterFormats *in_chlayouts;
    AVFilterFormats *out_chlayouts;
    AVFilterFormats *in_packing;
    AVFilterFormats *out_packing;

    AVFilterBufferRef *src_buf;

    AVFilterBufferRef *cur_buf;
    AVFilterBufferRef *out_buf;

    AVRational time_base;

    struct AVFilterPool *pool;
};

int avfilter_link(AVFilterContext *src, unsigned srcpad,
                  AVFilterContext *dst, unsigned dstpad);

void avfilter_link_free(AVFilterLink **link);

int avfilter_config_links(AVFilterContext *filter);

AVFilterBufferRef *avfilter_get_video_buffer(AVFilterLink *link, int perms,
                                          int w, int h);

AVFilterBufferRef *
avfilter_get_video_buffer_ref_from_arrays(uint8_t * const data[4], const int linesize[4], int perms,
                                          int w, int h, enum PixelFormat format);

AVFilterBufferRef *avfilter_get_audio_buffer(AVFilterLink *link, int perms,
                                             int nb_samples);

AVFilterBufferRef *
avfilter_get_audio_buffer_ref_from_arrays(uint8_t *data[8], int linesize[8], int perms,
                                          int nb_samples, enum AVSampleFormat sample_fmt,
                                          uint64_t channel_layout, int planar);
int avfilter_request_frame(AVFilterLink *link);

int avfilter_poll_frame(AVFilterLink *link);

void avfilter_start_frame(AVFilterLink *link, AVFilterBufferRef *picref);

void avfilter_end_frame(AVFilterLink *link);

void avfilter_draw_slice(AVFilterLink *link, int y, int h, int slice_dir);

#define AVFILTER_CMD_FLAG_ONE   1 
#define AVFILTER_CMD_FLAG_FAST  2 


int avfilter_process_command(AVFilterContext *filter, const char *cmd, const char *arg, char *res, int res_len, int flags);

void avfilter_filter_samples(AVFilterLink *link, AVFilterBufferRef *samplesref);

void avfilter_register_all(void);

void avfilter_uninit(void);

int avfilter_register(AVFilter *filter);

AVFilter *avfilter_get_by_name(const char *name);

AVFilter **av_filter_next(AVFilter **filter);

int avfilter_open(AVFilterContext **filter_ctx, AVFilter *filter, const char *inst_name);

int avfilter_init_filter(AVFilterContext *filter, const char *args, void *opaque);

void avfilter_free(AVFilterContext *filter);

int avfilter_insert_filter(AVFilterLink *link, AVFilterContext *filt,
                           unsigned filt_srcpad_idx, unsigned filt_dstpad_idx);

void avfilter_insert_pad(unsigned idx, unsigned *count, size_t padidx_off,
                         AVFilterPad **pads, AVFilterLink ***links,
                         AVFilterPad *newpad);

static inline void avfilter_insert_inpad(AVFilterContext *f, unsigned index,
                                         AVFilterPad *p)
{
    avfilter_insert_pad(index, &f->input_count, offsetof(AVFilterLink, dstpad),
                        &f->input_pads, &f->inputs, p);
}

static inline void avfilter_insert_outpad(AVFilterContext *f, unsigned index,
                                          AVFilterPad *p)
{
    avfilter_insert_pad(index, &f->output_count, offsetof(AVFilterLink, srcpad),
                        &f->output_pads, &f->outputs, p);
}

#endif /* AVFILTER_AVFILTER_H */