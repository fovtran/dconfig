#include <stdio.h>
#include <stdlib.h>
#include <libavutil/imgutils.h>
#include <libavutil/samplefmt.h>
#include <libavutil/timestamp.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>

int ret;
int got_output;
int scr_width;
int scr_height;
AVCodecContext* c;
AVPacket pkt;
AVCodec* codec;

int main()
{
    //Encoder initialization
    avcodec_register_all();
    codec=avcodec_find_encoder(AV_CODEC_ID_H264);
    c = avcodec_alloc_context3(codec);
    c->width=scr_width;
    c->height=scr_height;
    c->bit_rate = 400000;
    int base_num=1;
    int base_den=1;//for one frame per second
    c->time_base= (AVRational){base_num,base_den};
    c->gop_size = 10;
    c->max_b_frames=1;
    c->pix_fmt = AV_PIX_FMT_YUV444P;
    av_opt_set(c->priv_data, "preset", "slow", 0);

    frame = avcodec_alloc_frame();
    frame->format = c->pix_fmt;
    frame->width  = c->width;
    frame->height = c->height;

    for(int counter=0;counter<10;counter++)
    {
    ///////////////////////////
    //Capturing Screen
    ///////////////////////////
        GetCapScr(shotbuf,scr_width,scr_height);//result: shotbuf is filled by screendata from HBITMAP
    ///////////////////////////
    //Convert buffer to YUV444 (standard formula)
    //It's handmade function because of problems with prepare buffer to swscale from HBITMAP
    ///////////////////////////
        RGBtoYUV(shotbuf,frame->linesize,frame->data,scr_width,scr_height);//result in frame->data
    ///////////////////////////
    //Encode Screenshot
    ///////////////////////////
        av_init_packet(&pkt);
        pkt.data = NULL;    // packet data will be allocated by the encoder
        pkt.size = 0;
        frame->pts = counter;
        avcodec_encode_video2(c, &pkt, frame, &got_output);
        if (got_output) 
        {
            //I think that  sending packet by rtmp  must be here!
            av_free_packet(&pkt);             

        }

    }
    // Get the delayed frames
    for (int got_output = 1,i=0; got_output; i++)
    {
        ret = avcodec_encode_video2(c, &pkt, NULL, &got_output);
        if (ret < 0)
            {
                fprintf(stderr, "Error encoding frame\n");
                exit(1);
            }
            if (got_output)
            {
            //I think that  sending packet by rtmp  must be here!
            av_free_packet(&pkt);      
            }
    }

    ///////////////////////////
    //Deinitialize encoder
    ///////////////////////////
    avcodec_close(c);
    av_free(c);
    av_freep(&frame->data[0]);
    //avcodec_free_frame(&frame);
    delete &frame;

    return EXIT_SUCCESS;
}