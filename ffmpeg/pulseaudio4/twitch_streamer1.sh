#!/bin/bash 
function cleanup()
{
	killall -9 ffmpeg
	kill SIGINT $PID
}
trap cleanup EXIT

cp  /usr/share/X11/xorg.conf.d/20-nouveau-drm.conf ~/
ffmpeg -muxers 2>&1 | tee > /tmp/ffmpeg-muxers.log
cat /tmp/ffmpeg-muxers.log
ffmpeg -demuxers 2>&1 | tee > /tmp/ffmpeg-demuxers.log
cat /tmp/ffmpeg-demuxers.log

# GRUB_CMDLINE_LINUX_DEFAULT="quiet acpi_backlight=vendor drm.rnodes=1 nouveau.pstate=1 nouveau.runpm=1"
# See also
#    Direct Rendering Infrastructure (DRI)
#    Mesa 3D
#    EGL
#    Glamor
#    SNA
# - -Section "Module"
#        Load "bitmap"
#        Load "ddx"
#        Load "ddc"
#        Load "dri2"
#        Load "GLCore"
#        Load "extmod"
#        Load "freetype"
#        Load "int10"
#        Load "record"
#        Load "type1"
#        Load "vbe"
#EndSection
# -- # nano /usr/share/X11/xorg.conf.d/20-nouveau-drm.conf 
# Show input audio Hw devices
# arecord -l

# [11515.553826] nouveau 0000:01:00.0: Direct firmware load for nouveau/nv84_xuc00f failed with error -2
# ffmpeg -loglevel debug -vaapi_device /dev/dri/renderD128 -f x11grab -video_size 1920x1080 -i :0 -vf 'format=nv12,hwupload' -c:v h264_vaapi -profile:v 578 -bf 0 -y out.mkv
# ffmpeg ... -i input.wmv -c:v h264_vaapi -profile:v PROFILE_NUMBER output.mp4
# LIBVA_DRIVER_NAME=nouveau_dri vainfo|grep -i enc|grep 264
# ffmpeg -help encoder=h264_vaapi
# apt install --reinstall libx264-155

# ffmpeg -f alsa -i hw:0,2 rec.wav
# ffmpeg -thread_queue_size 24 -v verbose -hwaccel vdpau -f x11grab -thread_queue_size 24 -s "1440x900" -r 10 -i ":0.0+0,0" -f alsa -thread_queue_size 256 -i hw:0,2 -threads 2 -b:v "1174k" -minrate "1174k"  -vcodec libx264 -preset veryfast -acodec libmp3lame -ab 128k -ac 1 -y output.mkv
# ffmpeg -thread_queue_size 24 -v verbose -hwaccel vdpau -f x11grab -thread_queue_size 24 -s "1440x900" -r 10 -i ":0.0+0,0" -i "http://192.168.2.198/video.cgi?.mjpeg" -err_detect ignore_err -an -filter_complex 'overlay=main_w-overlay_w:main_h-overlay_h:format=yuv444' -f alsa -thread_queue_size 256 -i hw:0,2 -threads 2 -b:v "1174k" -minrate "1174k"  -vcodec libx264 -preset veryfast -acodec libmp3lame -ab 128k -ac 1 -y output.mkv
# ffmpeg -thread_queue_size 24 -v verbose -hwaccel vdpau -f x11grab -thread_queue_size 24 -s "1440x900" -r 10 -i ":0.0+0,0" -i ~/Downloads/DRAGON2.png -f alsa -thread_queue_size 256 -i hw:0,2 -threads 4 -b:v "1174k" -minrate "1174k"  -vcodec libx264 -s "1920x1200" -filter_complex 'overlay=main_w-overlay_w:main_h-overlay_h:format=yuv444' -preset superfast -acodec libmp3lame -ab 160k -ac 1 -y -f null - 
# ffmpeg -thread_queue_size 24 -v verbose -hwaccel vdpau -f x11grab -thread_queue_size 24 -s "1440x900" -r 10 -i ":0.0+0,0" -i ~/Downloads/DRAGON2.png -f alsa -thread_queue_size 256 -i hw:0,2 -threads 4 -b:v "1174k" -minrate "1174k"  -vcodec libx264 -s "1920x1200" -filter_complex "[1:v][0:v]scale2ref=iw:ih[ovr][base];[ovr][base]blend=all_mode='overlay':all_opacity=0.7[v]" -filter_complex 'overlay=main_w-overlay_w:main_h-overlay_h:format=yuv444' -preset superfast -acodec libmp3lame -ab 160k -ac 1 -y -map [v] /tmp/output.mkv
# ffmpeg -thread_queue_size 24 -v verbose -hwaccel vdpau -f x11grab -thread_queue_size 24 -s "1440x900" -r 10 -i ":0.0+0,0" -i ~/Downloads/DRAGON4.png -f alsa -thread_queue_size 256 -i hw:0,2 -threads 4 -b:v "1174k" -minrate "1174k"  -vcodec libx264 -s "1920x1200" -filter_complex "[1:v]format=rgba,geq=r='r(X,Y)':a='0.7*alpha(X,Y)'[zork]; [0:v][zork]overlay" -preset superfast -acodec libmp3lame -ab 160k -ac 1 -y /tmp/output.mkv
#  -filter_complex "[1:v]format=rgba,colorchannelmixer=aa=0.7[fg];[0][fg]overlay" 
# ffmpeg -n -i video.mp4 -i logo.png -filter_complex "[0:v]setsar=sar=1[v];[v][1]blend=all_mode='overlay':all_opacity=0.7" -movflags +faststart tmb/video.mp4
# ffmpeg -i original.mp4 -framerate 60 -pattern_type glob -i images/*.png -filter_complex "[1:v][0:v]scale2ref=iw:ih[ovr][base]; [ovr][base]blend=all_mode='overlay':all_opacity=0.7[v]" -map [v] result.mp4
# ffmpeg -i original.mp4 -framerate 60 -pattern_type glob -i "images/*.png" -filter_complex "[1:v][0:v]scale2ref=iw:ih[ovr][base]; [ovr]colorchannelmixer=aa=0.7[ovrl]; [base][ovrl]overlay[v]" -map [v] result.mp4
# ffmpeg -i video.mp4 -i logo.png -filter_complex "overlay=x=10:y=10" output-video.mp4
# If we want to position the logo on the top right position we need to calculate the new offset.
# overlay=x=main_w-overlay_w-10:y=10

# amixer -c 0 -D default cget numid=23  # input 1 source
# amixer -c 0 -D default cget numid=24  # input 2 source
# amixer -c 0 -D default cget numid=26  # capture switch
# amixer -c 0 -D default cget numid=28  # capture switch
# amixer -c 0 -D default cget numid=43  # rear mic jack
# amixer -c 0 -D default cget numid=45  # line jack
# amixer -c 0 -D default cget numid=47  # line out front jack
# amixer -c 0 -D default cget numid=48  # line out surround jack
# amixer -c 0 -D default cget numid=51  # front headphone jack
# amixer -c 0 -D default cget numid=54  # playback channel map
# amixer -c 0 -D default cget numid=55  # capture channel map
# amixer -c 0 -D default cget numid=56  # playback channel map dev 1
# amixer -c 0 -D default cget numid=57  # capture channel map dev 1
# amixer -c 0 -D default cget numid=58  # capture channel map dev 2
# pacmd list-sources
# pacmd set-sink-port 0 "analog-output-lineout"
# pacmd set-source-port 1 "analog-input-linein"
# pacmd set-source-port 1 "analog-input-rear-mic"
# alsactl store 0
# pacmd update-sink-proplist 0 channelmap="front-left,front-right,rear-left,rear-right"
# echo "" > /tmp/alsasound  # enables loopbag in pulseaudio -> restart
# pacmd set-default-sink 1 # for headphones
# pacmd set-default-sink 2 # for speakers

#TARGET="rtmp://$SERVER.contribute.live-video.net/app/$STREAM_KEY"
#TARGET="-listen 2 rtmp://192.168.2.45"
TARGET="-y /dev/null"
OUTFMT="-f flv"
#I=":0.0+0,0"

# Hardware acceleration methods: vdpau vaapi drm
# Apis are opencl vdpau vaapi libmfx nvenc drm kmsgrab
# using cpu capabilities: MMX2 SSE2Fast LZCNT
# $$ ffmpeg -devices
# $$ ffmpeg -bsfs
# $$ ffmpeg -hwaccels

#HWACCELAPI="-hwaccel vdpau"
#HWACCELAPI="-hwaccel vdpau -f x11grab -f yuv4mpegpipe -f rawvideo"
#HWACCELAPI="-hwaccel vdpau -f x11grab -f yuv4mpegpipe -f rawvideo"
#HWACCELAPI="-hwaccel vdpau -f x11grab -f yuv4mpegpipe -f rawvideo"
HWACCELAPI="-hwaccel vdpau -hwaccel_output_format vaapi -f x11grab -f fbdev -hwaccel drm -i :0"
VAAPI="-init_hw_device vaapi=/dev/dri/renderD129 -i vcd"
VFILTER1="scale=$OUTRES:-1,format=yuv420p"
VFILTER2="null"

# ffmpeg -hide_banner -init_hw_device vaapi=decdev:/dev/dri/renderD129 -init_hw_device vaapi=encdev:/dev/dri/renderD129 -hwaccel vaapi -hwaccel_device decdev -hwaccel_output_format vaapi -vf 'hwdownload,format=nv12' -c:v h264_vaapi -b:v 5M /tmp/output.mp4

function daemon()
{
/usr/bin/ffmpeg -hide_banner $VAAPI $HWACCELAPI -s $INRES -r $FPS -threads 4 -probesize 64M -thread_queue_size 64 -i $I $PULSEAUDIO \
	$OUTFMT $TARGET 	2>&1
}
