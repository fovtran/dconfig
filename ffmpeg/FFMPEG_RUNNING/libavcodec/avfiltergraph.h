https://ffmpeg.org/doxygen/0.9/avfiltergraph_8h-source.html


#ifndef AVFILTER_AVFILTERGRAPH_H
#define AVFILTER_AVFILTERGRAPH_H

#include "avfilter.h"

typedef struct AVFilterGraph {
    unsigned filter_count;
    AVFilterContext **filters;

    char *scale_sws_opts; 
} AVFilterGraph;

AVFilterGraph *avfilter_graph_alloc(void);

AVFilterContext *avfilter_graph_get_filter(AVFilterGraph *graph, char *name);

int avfilter_graph_add_filter(AVFilterGraph *graphctx, AVFilterContext *filter);

int avfilter_graph_create_filter(AVFilterContext **filt_ctx, AVFilter *filt,
                                 const char *name, const char *args, void *opaque,
                                 AVFilterGraph *graph_ctx);

int avfilter_graph_config(AVFilterGraph *graphctx, void *log_ctx);

void avfilter_graph_free(AVFilterGraph **graph);

typedef struct AVFilterInOut {
    char *name;

    AVFilterContext *filter_ctx;

    int pad_idx;

    struct AVFilterInOut *next;
} AVFilterInOut;

AVFilterInOut *avfilter_inout_alloc(void);

void avfilter_inout_free(AVFilterInOut **inout);

int avfilter_graph_parse(AVFilterGraph *graph, const char *filters,
                         AVFilterInOut **inputs, AVFilterInOut **outputs,
                         void *log_ctx);

int avfilter_graph_send_command(AVFilterGraph *graph, const char *target, const char *cmd, const char *arg, char *res, int res_len, int flags);

int avfilter_graph_queue_command(AVFilterGraph *graph, const char *target, const char *cmd, const char *arg, int flags, double ts);



#endif /* AVFILTER_AVFILTERGRAPH_H */
