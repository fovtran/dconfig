// https://ffmpeg.org/doxygen/0.9/lavfi_8c.html
// libavfilter virtual input device More...

#include "float.h"
#include "libavutil/log.h"
#include "libavutil/mem.h"
#include "libavutil/opt.h"
#include "libavutil/parseutils.h"
#include "libavutil/pixdesc.h"
#include "libavfilter/avfilter.h"
#include "libavfilter/avfiltergraph.h"
#include "libavfilter/buffersink.h"
#include "libavformat/internal.h"
#include "avdevice.h"

Go to the source code of this file.

Data Structures
struct  	LavfiContext

Defines
#define 	FAIL(ERR)   { ret = ERR; goto end; }
#define 	OFFSET(x)   offsetof(LavfiContext, x)
#define 	DEC   AV_OPT_FLAG_DECODING_PARAM

Functions
static int * 	create_all_formats (int n)
static av_cold int 	lavfi_read_close (AVFormatContext *avctx)
static av_cold int 	lavfi_read_header (AVFormatContext *avctx, AVFormatParameters *ap)
static int 	lavfi_read_packet (AVFormatContext *avctx, AVPacket *pkt)

Variables
static const AVOption 	options []
static const AVClass 	lavfi_class
AVInputFormat 	ff_lavfi_demuxer
Detailed Description
libavfilter virtual input device

Definition in file lavfi.c.
Define Documentation
#define DEC   AV_OPT_FLAG_DECODING_PARAM

Definition at line 326 of file lavfi.c.

#define FAIL 	( 	ERR  		 )  	   { ret = ERR; goto end; }

Referenced by lavfi_read_header().

#define OFFSET 	( 	x  		 )  	   offsetof(LavfiContext, x)

Definition at line 324 of file lavfi.c.

Function Documentation
static int* create_all_formats 	( 	int  	n 	 )  	[static]

Definition at line 50 of file lavfi.c.

Referenced by lavfi_read_header().

static av_cold int lavfi_read_close 	( 	AVFormatContext *  	avctx 	 )  	[static]

Definition at line 68 of file lavfi.c.

Referenced by lavfi_read_header().

static av_cold int lavfi_read_header 	( 	AVFormatContext *  	avctx,
		AVFormatParameters *  	ap	 
	) 			[static]

Definition at line 79 of file lavfi.c.

static int lavfi_read_packet 	( 	AVFormatContext *  	avctx,
		AVPacket *  	pkt	 
	) 			[static]

Definition at line 265 of file lavfi.c.

Variable Documentation
AVInputFormat ff_lavfi_demuxer

Initial value:

 {
    .name           = "lavfi",
    .long_name      = NULL_IF_CONFIG_SMALL("Libavfilter virtual input device"),
    .priv_data_size = sizeof(LavfiContext),
    .read_header    = lavfi_read_header,
    .read_packet    = lavfi_read_packet,
    .read_close     = lavfi_read_close,
    .flags          = AVFMT_NOFILE,
    .priv_class     = &lavfi_class,
}

Definition at line 340 of file lavfi.c.

const AVClass lavfi_class [static]

Initial value:

 {
    .class_name = "lavfi indev",
    .item_name  = av_default_item_name,
    .option     = options,
    .version    = LIBAVUTIL_VERSION_INT,
}

Definition at line 333 of file lavfi.c.

const AVOption options[] [static]

Initial value:

 {
    { "graph", "Libavfilter graph", OFFSET(graph_str),  AV_OPT_TYPE_STRING, {.str = NULL }, 0,  0, DEC },
    { NULL },
}
