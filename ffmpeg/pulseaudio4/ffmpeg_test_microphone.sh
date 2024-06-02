#!/bin/bash
OPTS1="-re -v verbose -hide_banner"
OPTS2="-thread_queue_size 2048 -ar 48000 -f alsa -ac 2 -i default -sample_rate 48000 -b:a 196k -bufsize 1M"
OPTS3="-strict experimental -y -t 5 -tune zerolatency -movflags +faststart"

echo "Waiting for record start"
sleep 1
# -acodec pcm_s24le
ffmpeg $OPTS1 $OPTS2 $OPTS3 /opt/VIDEO/testmic_noise.mp3 &
sleep 6 && killall -9 ffmpeg
ffmpeg -i /opt/VIDEO/testmic_noise.mp3 -lavfi showspectrumpic=s=1440x900:mode=separate -y testmic_noise.png

echo "Sleeping"
sleep 5

ffmpeg $OPTS1 $OPTS2 $OPTS3 /opt/VIDEO/testmic_clean.mp3 &
sleep 6 && killall -9 ffmpeg
ffmpeg -i /opt/VIDEO/testmic_clean.mp3 -lavfi showspectrumpic=s=1440x900:mode=separate -y testmic_clean.png

ristretto testmic_noise.png &
ristretto testmic_clean.png &

ffmpeg $OPTS1 $OPTS2 -acodec pcm_s32le -f wav - | ffplay -f wav -vf 'showspectrumpic=s=1400x840:mode=combined:scale=5:win_func=blackman:color=intensity:legend=1:gain=20:start=0:stop=400' -x 1400 -y 840 -
ffmpeg $OPTS1 $OPTS2  -f wav -sn -dn -vn - | ffplay -x 1400 -y 840 -

ffmpeg -y -listen 1 -timeout 10 -f flv -i rtmp://127.0.0.1:5000/mystream/test -vcodec copy -f flv - | ffplay -x 1400 -y 840 -
ffmpeg -i /opt/VIDEO/testsrc_ntsc.mkv -f lavfi -vcodec libx264 -crf 17 -pix_fmt yuv420p -f flv rtmp://127.0.0.1:5000/mystream/test
ffmpeg -re -f lavfi -i testsrc=duration=25000:size=192x108:rate=25 -f lavfi -vcodec libx264 -crf 17 -pix_fmt yuv420p -f flv rtmp://127.0.0.1:5000/mystream/test

# setta il sistema a PAL
v4l2-ctl --set-standard=pal
#setta l'ingresso del device 0 al video composito
v4l2-ctl -d /dev/video0 -i 1
# setta la dimensione del frame
v4l2-ctl --set-fmt-video=width=640,height=480

ffmpeg -i "rtmp://localhost/oflaDemo/33/hlsopt6 live=1" -y -c:v libx264 \
 -b:v 1000k -r 24 -vprofile baseline -preset medium -x264opts level=41 \
 -threads 4 -s 480x360 -map 0:v -c:a libfaac -b:a 160000 -ac 1 -hls_time 3 \
 -hls_list_size 2 -hls_wrap 10 -start_number 1 hlsopt6.m3u8
 
 ffmpeg -fflags +genpts+igndts -i 'video.vob' -c copy 'video.mp4'

 ffmpeg -ss 00:02:45.000 -noaccurate_seek -hwaccel vaapi -hwaccel_output_format vaapi -vaapi_device /dev/dri/renderD128 -i file:"/films/The Prestige (2006)/The Prestige (2006) - Bluray-2160p.x265.AAC.[EN+AR+Chinese+HR+CS+DA+NL+FI+FR+DE+EL+HE+HU+IT+KO+Norwegian.Bokmal+PL+PT+RO+RU+ES+SV+TH+TR].mkv" -map_metadata -1 -map_chapters -1 -threads 0 -map 0:0 -map 0:1 -map -0:s -codec:v:0 h264_vaapi -b:v 41513036 -maxrate 41513036 -bufsize 83026072 -force_key_frames:0 "expr:gte(t,165+n_forced*3)" -vf "format=nv12|vaapi,hwupload" -copyts -vsync -1 -codec:a:0 copy -f hls -max_delay 5000000 -avoid_negative_ts disabled -start_at_zero -hls_time 3 -individual_header_trailer 0 -hls_segment_type mpegts -start_number 55 -hls_segment_filename "/transcode/transcodes/2df4d91ff7ff775462c6486e384cead6%d.ts" -hls_playlist_type vod -hls_list_size 0 -y "/transcode/transcodes/2df4d91ff7ff775462c6486e384cead6.m3u8"
 

-af loudnorm -af volnorm=1 -af volumedetect -af silenceremove=0:2000:-10dB
-af silencedetect=n=-10dB:d=1 -af "silenceremove=start_periods=1:stop_periods=-1:start_threshold=-10dB:stop_threshold=-10dB:start_silence=2:stop_silence=2"
-vf  "setpts=0.25*PTS"
-af "equalizer=f=1000:width_type=h:width=900:g=-10"
-af "bandreject=f=1200:width_type=h:width=900:g=-10"
-af "highpass=f=200, lowpass=f=3000"
-af "highpass=200,lowpass=3000,afftdn"
-af anlmdn=s=7:p=0.002:r=0.002:m=15
-f lavfi -i anullsrc -c:v copy

# CONCAT
ffmpeg -i start.mkv -i body.mkv -i rear.mkv -filter_complex \
  "[0:v] [0:a] [1:v] [1:a] [2:v] [2:a]
  concat=n=3:v=1:a=1 [v] [a]" \
  -map "[v]" -map "[a]" output.mkv
$ ffmpeg -i "concat:clay.mpeg\|sculpt.mpeg\|mold.mpeg" -c copy output.mkv
$ ffmpeg -i opening.mkv -i episode.mkv -i ending.mkv -filter_complex \
 '[0:0] [0:1] [0:2] [1:0] [1:1] [1:2] [2:0] [2:1] [2:2]
  concat=n=3:v=1:a=2 [v] [a1] [a2]' \
 -map '[v]' -map '[a1]' -map '[a2]' output.mkv

ffmpeg -y -nostdin -i output.wav -filter_complex "[0:0]FILTER PARAMETER" -map_metadata 0 -map_metadata:s:a:0 0:s:a:0 -map_chapters 0 -map [norm0] -c:a pcm_s16le -ar 1500 -c:s copy out2.wav   
ffmpeg -h filter=showspectrumpic
ffplay -vf histogram fullrange_y.mp4
ffplay -color_range 2 -vf histogram=mode=waveform:waveform_mode=column:waveform_mirror=1
ffplay -color_range 2 -vf format=pix_fmts=yuvj420p,histogram=mode=waveform:waveform_mode=column:waveform_mirror=1 fullrange_y.mp4
ffmpeg -i fullrange_y.mp4 -vf histogram=mode=waveform:waveform_mode=column:waveform_mirror=1 -c:v
ffmpeg -f dshow -i video=screen-capture-recorder -pix_fmt yuv420p -f mpegts - | ffplay -analyzeduration 10 -f mpegts -
-af "volumedetect" -vn -sn -dn

ffplay -f lavfi \
         "amovie=in.mp4,asplit=3[sv][eb][av]; \
          [sv]showvolume=b=4:f=0:ds=log:c=VOLUME:w=400:h=200[sv-v]; \
          [eb]ebur128=video=1:size=800x800:meter=18[eb-v][out1]; \
          [eb-v]scale=400x400[eb-v]; \
          [av]avectorscope=s=400x480:zoom=1.3:rc=2:gc=200:bc=10:rf=1:gf=8:bf=7[av-v]; \
          [sv-v][eb-v][av-v]vstack=3[1c]; \
          movie=in.mp4,scale=-1:1080[v]; \
          [1c][v]hstack=2[out0]"

# VAAPI
ffmpeg ... -i input.wmv -c:v h264_vaapi -profile:v PROFILE_NUMBER output.mp4
ffmpeg -vf format=nv12|vaapi,hwupload,setsar=sar=1,scale_vaapi=w=1920:h=784 
ffmpeg -v 100 -y -vaapi_device :0.0 -hwaccel vaapi -hwaccel_output_format vaapi -i /opt/VIDEO/testsrc_ntsc.mkv -vcodec h264_vaapi a.mkv
ffmpeg -v 100 -y -vaapi_device :0.0 -hwaccel vaapi -hwaccel_output_format vaapi -i /opt/VIDEO/testsrc_ntsc.mkv -vcodec h264_vaapi -vf format=vaapi,hwupload,setsar=sar=1,scale_vaapi=w=1920:h=784 -vsync 2 -bf 0 -vb 8000000 -f ssegment -segment_format mpegts -segment_list_type m3u8 -segment_time 5 -segment_time_delta 0.000 -segment_start_number 00000 -individual_header_trailer 0 -avoid_negative_ts 0 -break_non_keyframes 1 -max_muxing_queue_size 1024 -map 0:0 a.mkv
LIBVA_DRIVER_NAME=nouveau vainfo|grep -i enc|grep 264
export DRM_DRIVER=nouveau_dri; export LIBVA_DRIVER_NAME=nouveau; export VDPAU_DRIVER=vdpau; vainfo
ffmpeg -help encoder=h264_vaapi
