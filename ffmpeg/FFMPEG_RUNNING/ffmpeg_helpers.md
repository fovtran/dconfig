## FFMPEG HELPERS
ffmpeg -decoders | grep h264

# H264 decoders
 VFS..D h264                 H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10
 V..... h264_crystalhd       CrystalHD H264 decoder (codec h264)
 V..... h264_v4l2m2m         V4L2 mem2mem H.264 decoder wrapper (codec h264)
# H264 encoders
 V..... libx264              libx264 H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 (codec h264)
 V..... libx264rgb           libx264 H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10 RGB (codec h264)
 V..... h264_omx             OpenMAX IL H.264 video encoder (codec h264)
 V..... h264_v4l2m2m         V4L2 mem2mem H.264 encoder wrapper (codec h264)
 V..... h264_vaapi           H.264/AVC (VAAPI) (codec h264)

# FLV encoders/decoders
 V..... flv                  FLV / Sorenson Spark / Sorenson H.263 (Flash Video) (codec flv1)
 V...BD flv                  FLV / Sorenson Spark / Sorenson H.263 (Flash Video) (codec flv1)

# Devices:
 D. = Demuxing supported
 .E = Muxing supported
 --
 DE alsa            ALSA audio output
  E caca            caca (color ASCII art) output device
 DE fbdev           Linux framebuffer
 D  iec61883        libiec61883 (new DV1394) A/V input device
 D  jack            JACK Audio Connection Kit
 D  kmsgrab         KMS screen capture
 D  lavfi           Libavfilter virtual input device
 D  libcdio          
 D  libdc1394       dc1394 v.2 A/V grab
 D  openal          OpenAL audio capture device
  E opengl          OpenGL output
 DE oss             OSS (Open Sound System) playback
 DE pulse           Pulse audio output
  E sdl,sdl2        SDL2 output device
 DE sndio           sndio audio playback
 DE video4linux2,v4l2 Video4Linux2 output device
 D  x11grab         X11 screen capture, using XCB
  E xv              XV (XVideo) output device


video capturing --> scaling ----> encoding \
                                            \
                                             muxing --> ....
                                            /
audio capturing --> filtering --> encoding /

- Stream #0:0: Video: rawvideo (BGR[0] / 0x524742), bgr0, 1440x900, 29.97 fps, 1000k tbr, 1000k tbn, 1000k tbc

ffmpeg  -video_size 1440x900 -f x11grab -i :0.0+100,100 -vcodec libx264 -f alsa -i pulse -acodec ac3 -threads 0  ./video$(date +%F-%H-%M-%S).mp4

ffmpeg -video_size 1440x900 -framerate 25 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i default output.mkv

ffmpeg -video_size 1440x900 -framerate 25 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -f rawvideo -f flv pipe:1 >/tmp/0
ffplay -x 640 -y 480 pipe:0 </tmp/0

// ffplay -f matroska pipe:0
// ffplay -f matroska -listen 1 -i http://<SERVER_IP>:<SERVER_PORT>

# ----------------------------------------------------------------------

# Structs
AVFrame
# Resampling
int source_width = 1920, source_height = 1080;
int target_width = 1920, target_height = 1080;

struct SwsContext* scaler = sws_getContext(
    source_width, source_height, AV_PIX_FMT_YUYV422,
    target_width, target_height, AV_PIX_FMT_YUV422P,
    SWS_BICUBIC, NULL, NULL, NULL
);
AVFrame* scaled_frame = av_frame_alloc();

scaled_frame->format = AV_PIX_FMT_YUV422P;
scaled_frame->width  = target_width; 
scaled_frame->height = target_height;

av_image_alloc(
    scaled_frame->data, scaled_frame->linesize, 
    scaled_frame->width, scaled_frame->height, 
    scaled_frame->format, 16);
sws_scale( scaler,
    (const uint8_t * const*) source_data, source_linesize,
    0, source_height,
    scaled_frame->data, scaled_frame->linesize);
av_frame_free(&scaled_frame);

# Encoding
avcodec_register_all();
AVCodec* codec = avcodec_find_encoder(AV_CODEC_ID_H264);
# ----
AVCodecContext* encoder = avcodec_alloc_context3(codec);

encoder->bit_rate = 10 * 1000 * 10000;
encoder->width = 1920;
encoder->height = 1080;
encoder->time_base = (AVRational) {1,60};
encoder->gop_size = 30;
encoder->max_b_frames = 1;
encoder->pix_fmt = AV_PIX_FMT_YUV422P;

av_opt_set(encoder->av_codec_context->priv_data, "preset", "ultrafast", 0);

avcodec_open2(encoder, codec, NULL);

AVFrame* raw_frame = scaled_frame; 
// with avcodec_send_frame we send raw frames to the encoder
raw_frame->pts = pts++;
avcodec_send_frame(encoder, raw_frame);

av_freep(&raw_frame->data[0]);
av_frame_free(&raw_frame);
# ----
# Muxing
AVFormatContext* muxer = avformat_alloc_context();

muxer->oformat = av_guess_format("matroska", "test.mkv", NULL);

AVStream* video_track = avformat_new_stream(muxer, NULL);
AVStream* audio_track = avformat_new_stream(muxer, NULL);
muxer->oformat->video_codec = AV_CODEC_ID_H264;
muxer->oformat->audio_codec = AV_CODEC_ID_OPUS;

avcodec_parameters_from_context(video_track->codecpar, encoder); 
video_track->codecpar->codec_type = AVMEDIA_TYPE_VIDEO;

video_track->time_base = (AVRational) {1,60};
video_track->avg_frame_rate = (AVRational) {60, 1};
// to add context to the muxer
int avio_buffer_size = 4 * KB;
void* avio_buffer = av_malloc(avio_buffer_size);

AVIOContext* custom_io = avio_alloc_context (
    avio_buffer, avio_buffer_size,
    1,
    (void*) 42,
    NULL, &custom_io_write, NULL);
    
muxer->pb = custom_io;

// prevent reordering
AVDictionary *options = NULL;
av_dict_set(&options, "live", "1", 0);
avformat_write_header(muxer, &options);

// From there its as simple as calling av_write_frame() and freeing your input packets. 
// The muxer then writes the resulting bytestream to the IO-context.
AVPacket encoded_packet; 
AVRational encoder_time_base = (AVRational) {1, 60};

encoded_packet.stream_index = video_track->index;

int64_t scaled_pts = av_rescale_q(encoded_packet.pts, encoder_time_base, video_track->time_base);
encoded_packet.pts = scaled_pts;

int64_t scaled_dts = av_rescale_q(encoded_packet.dts, encoder_time_base, video_track->time_base);
input.packet.dts = scaled_dts;

int ret = av_write_frame(muxer->av_format_context, &encoded_packet);

av_packet_unref(&encoded_packet);
av_packet_free(&encoded_packet);

// At the end of your stream you have to remember to write a trailer to your video stream.
av_write_trailer(muxer);

// You can access the muxer’s bytestream via the buffer-parameter.
// int custom_io_write(void* opaque, uint8_t *buffer, int32_t buffer_size);
