/*
Try set flags of AVFormatContext to AVFMT_FLAG_NOBUFFER | AVFMT_FLAG_FLUSH_PACKETS

AVFormatContext *ctx;
...
ctx->flags = AVFMT_FLAG_NOBUFFER | AVFMT_FLAG_FLUSH_PACKETS;

Then try to set decoder thread to 1. It seems like more thread will cause more latency.

AVCodecContext *ctx;
...
ctx->thread_count = 1;
*/
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavformat/avio.h>

int main()
{
	AVFormatContext *ctx;
	ctx->flags = AVFMT_FLAG_NOBUFFER | AVFMT_FLAG_FLUSH_PACKETS;

	AVCodecContext *ctx;
	ctx->thread_count = 1;
}