https://ffmpeg.org/doxygen/0.9/libavutil_2opt_8h-source.html


#ifndef AVUTIL_OPT_H
#define AVUTIL_OPT_H

#include "rational.h"
#include "avutil.h"
#include "dict.h"
#include "log.h"

enum AVOptionType{
    AV_OPT_TYPE_FLAGS,
    AV_OPT_TYPE_INT,
    AV_OPT_TYPE_INT64,
    AV_OPT_TYPE_DOUBLE,
    AV_OPT_TYPE_FLOAT,
    AV_OPT_TYPE_STRING,
    AV_OPT_TYPE_RATIONAL,
    AV_OPT_TYPE_BINARY,  
    AV_OPT_TYPE_CONST = 128,
#if FF_API_OLD_AVOPTIONS
    FF_OPT_TYPE_FLAGS = 0,
    FF_OPT_TYPE_INT,
    FF_OPT_TYPE_INT64,
    FF_OPT_TYPE_DOUBLE,
    FF_OPT_TYPE_FLOAT,
    FF_OPT_TYPE_STRING,
    FF_OPT_TYPE_RATIONAL,
    FF_OPT_TYPE_BINARY,  
    FF_OPT_TYPE_CONST=128,
#endif
};

typedef struct AVOption {
    const char *name;

    const char *help;

    int offset;
    enum AVOptionType type;

    union {
        double dbl;
        const char *str;
        /* TODO those are unused now */
        int64_t i64;
        AVRational q;
    } default_val;
    double min;                 
    double max;                 

    int flags;
#define AV_OPT_FLAG_ENCODING_PARAM  1   
#define AV_OPT_FLAG_DECODING_PARAM  2   
#define AV_OPT_FLAG_METADATA        4   
#define AV_OPT_FLAG_AUDIO_PARAM     8
#define AV_OPT_FLAG_VIDEO_PARAM     16
#define AV_OPT_FLAG_SUBTITLE_PARAM  32
//FIXME think about enc-audio, ... style flags

    const char *unit;
} AVOption;

#if FF_API_FIND_OPT

attribute_deprecated
const AVOption *av_find_opt(void *obj, const char *name, const char *unit, int mask, int flags);
#endif

#if FF_API_OLD_AVOPTIONS

attribute_deprecated
int av_set_string3(void *obj, const char *name, const char *val, int alloc, const AVOption **o_out);

attribute_deprecated const AVOption *av_set_double(void *obj, const char *name, double n);
attribute_deprecated const AVOption *av_set_q(void *obj, const char *name, AVRational n);
attribute_deprecated const AVOption *av_set_int(void *obj, const char *name, int64_t n);

double av_get_double(void *obj, const char *name, const AVOption **o_out);
AVRational av_get_q(void *obj, const char *name, const AVOption **o_out);
int64_t av_get_int(void *obj, const char *name, const AVOption **o_out);
attribute_deprecated const char *av_get_string(void *obj, const char *name, const AVOption **o_out, char *buf, int buf_len);
attribute_deprecated const AVOption *av_next_option(void *obj, const AVOption *last);
#endif

int av_opt_show2(void *obj, void *av_log_obj, int req_flags, int rej_flags);

void av_opt_set_defaults(void *s);

#if FF_API_OLD_AVOPTIONS
attribute_deprecated
void av_opt_set_defaults2(void *s, int mask, int flags);
#endif

int av_set_options_string(void *ctx, const char *opts,
                          const char *key_val_sep, const char *pairs_sep);

void av_opt_free(void *obj);

int av_opt_flag_is_set(void *obj, const char *field_name, const char *flag_name);

/*
 * Set all the options from a given dictionary on an object.
 *
 * @param obj a struct whose first element is a pointer to AVClass
 * @param options options to process. This dictionary will be freed and replaced
 *                by a new one containing all options not found in obj.
 *                Of course this new dictionary needs to be freed by caller
 *                with av_dict_free().
 *
 * @return 0 on success, a negative AVERROR if some option was found in obj,
 *         but could not be set.
 *
 * @see av_dict_copy()
 */
int av_opt_set_dict(void *obj, struct AVDictionary **options);

int av_opt_eval_flags (void *obj, const AVOption *o, const char *val, int        *flags_out);
int av_opt_eval_int   (void *obj, const AVOption *o, const char *val, int        *int_out);
int av_opt_eval_int64 (void *obj, const AVOption *o, const char *val, int64_t    *int64_out);
int av_opt_eval_float (void *obj, const AVOption *o, const char *val, float      *float_out);
int av_opt_eval_double(void *obj, const AVOption *o, const char *val, double     *double_out);
int av_opt_eval_q     (void *obj, const AVOption *o, const char *val, AVRational *q_out);
#define AV_OPT_SEARCH_CHILDREN   0x0001 
#define AV_OPT_SEARCH_FAKE_OBJ   0x0002

const AVOption *av_opt_find(void *obj, const char *name, const char *unit,
                            int opt_flags, int search_flags);

const AVOption *av_opt_find2(void *obj, const char *name, const char *unit,
                             int opt_flags, int search_flags, void **target_obj);

const AVOption *av_opt_next(void *obj, const AVOption *prev);

void *av_opt_child_next(void *obj, void *prev);

const AVClass *av_opt_child_class_next(const AVClass *parent, const AVClass *prev);

int av_opt_set       (void *obj, const char *name, const char *val, int search_flags);
int av_opt_set_int   (void *obj, const char *name, int64_t     val, int search_flags);
int av_opt_set_double(void *obj, const char *name, double      val, int search_flags);
int av_opt_set_q     (void *obj, const char *name, AVRational  val, int search_flags);
int av_opt_get       (void *obj, const char *name, int search_flags, uint8_t   **out_val);
int av_opt_get_int   (void *obj, const char *name, int search_flags, int64_t    *out_val);
int av_opt_get_double(void *obj, const char *name, int search_flags, double     *out_val);
int av_opt_get_q     (void *obj, const char *name, int search_flags, AVRational *out_val);
void *av_opt_ptr(const AVClass *avclass, void *obj, const char *name);
#endif /* AVUTIL_OPT_H */
