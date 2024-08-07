#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#ifdef HAVE_AV_CONFIG_H
#undef HAVE_AV_CONFIG_H
#endif

extern "C"
{
#include "libavutil/imgutils.h"
#include "libavutil/opt.h"
#include "libavcodec/avcodec.h"
#include "libavutil/mathematics.h"
#include "libavutil/samplefmt.h"
}

#define INBUF_SIZE 4096
#define AUDIO_INBUF_SIZE 20480
#define AUDIO_REFILL_THRESH 4096

static void video_encode_example(const char *filename, int codec_id)
{
   AVCodec *codec;
   AVCodecContext *c= NULL;
   int i, out_size, size, x, y, outbuf_size;
   FILE *f;
   AVFrame *picture;
   uint8_t *outbuf;
   int nrOfFramesPerSecond  =25;
   int nrOfSeconds =1;
   printf("Video encoding\n");

//    find the mpeg1 video encoder
   codec = avcodec_find_encoder((CodecID) codec_id);
   if (!codec) {
       fprintf(stderr, "codec not found\n");
       exit(1);
   }

   c = avcodec_alloc_context3(codec);
   picture= avcodec_alloc_frame();

//    put sample parameters
   c->bit_rate = 400000;
//    resolution must be a multiple of two
   c->width = 352;
   c->height = 288;
//    frames per second
   c->time_base= (AVRational){1,25};
   c->gop_size = 10;  //emit one intra frame every ten frames
   c->max_b_frames=1;
   c->pix_fmt = PIX_FMT_YUV420P;

   if(codec_id == CODEC_ID_H264)
       av_opt_set(c->priv_data, "preset", "slow", 0);

//    open it
   if (avcodec_open2(c, codec, NULL) < 0) {
       fprintf(stderr, "could not open codec\n");
       exit(1);
   }

   f = fopen(filename, "wb");
   if (!f) {
       fprintf(stderr, "could not open %s\n", filename);
       exit(1);
   }

//    alloc image and output buffer
   outbuf_size = 100000;
   outbuf = (uint8_t*) malloc(outbuf_size);

//    the image can be allocated by any means and av_image_alloc() is
//    * just the most convenient way if av_malloc() is to be used
   av_image_alloc(picture->data, picture->linesize,
                  c->width, c->height, c->pix_fmt, 1);

//    encode 1 second of video
   int nrOfFramesTotal = nrOfFramesPerSecond * nrOfSeconds;

//    encode 1 second of video
   for(i=0;i < nrOfFramesTotal; i++) {
       fflush(stdout);
//        prepare a dummy image

       for(y=0;y<c->height;y++) {
           for(x=0;x<c->width;x++) {
               picture->data[0][y * picture->linesize[0] + x] = x + y + i * 3;
           }
       }

//        Cb and Cr
       for(y=0;y<c->height/2;y++) {
           for(x=0;x<c->width/2;x++) {
               picture->data[1][y * picture->linesize[1] + x] = 128 + y + i * 2;
               picture->data[2][y * picture->linesize[2] + x] = 64 + x + i * 5;
           }
       }

//        encode the image
       out_size = avcodec_encode_video(c, outbuf, outbuf_size, picture);
       printf("encoding frame %3d (size=%5d)\n", i, out_size);
       fwrite(outbuf, 1, out_size, f);
   }

//    get the delayed frames
   for(; out_size; i++) {
       fflush(stdout);

       out_size = avcodec_encode_video(c, outbuf, outbuf_size, NULL);
       printf("write frame %3d (size=%5d)\n", i, out_size);
       fwrite(outbuf, 1, out_size, f);
   }

//    add sequence end code to have a real mpeg file
   outbuf[0] = 0x00;
   outbuf[1] = 0x00;
   outbuf[2] = 0x01;
   outbuf[3] = 0xb7;
   fwrite(outbuf, 1, 4, f);
   fclose(f);
   free(outbuf);

   avcodec_close(c);
//   av_free(c);
//   av_free(picture->data[0]);
//   av_free(picture);
   printf("\n");
}

int main(int argc, char **argv)
{
   const char *filename;


   avcodec_register_all();

   if (argc <= 1) {

       video_encode_example("/home/radix/Desktop/OpenCV/FFMPEG_Output/op89.png", AV_CODEC_ID_H264);
   } else {
       filename = argv[1];
   }


   return 0;
}