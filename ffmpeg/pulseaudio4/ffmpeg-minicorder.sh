#!/bin/bash

# --------cut--------minicorder.sh---------------------
# __AUTHOR__="hipo2022"
# __DATE__ = "2022-07-14"
trap "set +x" QUIT EXIT
set -x
stty -echoctl # hide ^C
trap 'mytrap' SIGINT

test -x /bin/date || exit 100
test -x /usr/bin/ffmpeg || exit 100
test -x /usr/bin/sox || exit 100
test -x /usr/bin/sndfile-spectrogram || exit 100
test -x /usr/bin/mogrify || exit 100

TODO="
	review yuv444p for color rages
	etc"
USAGE="minicorder.sh <shoot|playback>"

echo "Starting at $DATE"

function mytrap(){
	echo "SIGINT caught."
	exit 1
}
function die(){
#   echo ${1:=Something terrible wrong happen} - NO it doesn't
	killall -SIGINT ffmpeg
   exit -7
}

DATE=$(/bin/date +"%Y-%m-%d--%H-%M")
VIDFILE="/tmp/record-$DATE.mp4"
PLAYOPTS="$opts-x 1440 -y 900 -autoexit"
# ACCELS: opencl vaapi cuda
# opencl: device creation failed -12, 
# [rawvideo @ 0x564c904c78c0] No device available for decoder: device type cuda needed for codec rawvideo.

ACCEL="vaapi"
# H-Acceleration disks. nv12/yuv420p/nv21
FMT="yuyv422"
OUTFMT="-f flv"
# AAC or LIBMP3LANE
ACODEC="libmp3lame"
THREADS=4
EXTRAOPTS="-hide_banner -fflags nobuffer -fflags discardcorrupt -flags low_delay -avioflags direct"
VCODECEXTRA="-crf 23 -profile:v baseline -level 3.0 -pix_fmt yuv420p"
# Horrible Presets: ultrafast superfast veryfast faster fast medium slow slower veryslow placebo
VCODEC="-vcodec libx264 $VCODECEXTRA -g 20 -keyint_min 10 -b:v 1174k -minrate 1174k -maxrate 1174k -preset medium -movflags faststart"
#TARGET1="-listen 2 rtmp://127.0.0.1"	
#TARGET2="-y /dev/null"
#TARGET3="-rtsp_transport tcp -i rtsp://@192.168.1.27:552//stream1 -acodec rawvideo -vcodec rawvideo -f v4l2 /dev/video0"

# !TODO*: - Define USR1 trapping strategy.
# !WARN : - Find out if cpu overhead largely passes 50% first,
# !TODO : - yuv420p is not simply pix_format but also the yuv420 pallete defined in section 8.1.4,
# !TODO*: - It also stabilizes progressively.
# !TODO : - Takes long to stabilize the yuv420p.
# !TYPO : - Quits at exit.
function cook {
	FS=$2
	echo $FS
	ffplay $PLAYOPTS "$FS"
}
function shooter2 {
	ffmpeg $EXTRAOPTS -hwaccel $ACCEL -f x11grab \
	-s 1440x900 -video_size 1440x900 -r 10 -probesize 2M -thread_queue_size 378 \
	-i :0.0+0,0 -thread_queue_size 5000 \
	-f alsa -i pulse -ac 2 -b:a 128k -ar 48000 -acodec $ACODEC -bufsize 1174k \
	-threads $THREADS \
	-filter:v "format=$FMT" $VCODEC \
	-threads 4 \
	$OUTFMT -y $VIDFILE
}

case "$1" in
	"test")
	Message="All is quiet."
	echo $Message	
	echo $TODO
	;;
	"playback")
	Message="Playing recorded $FILE1."
		echo $Message
		cook $@
	;;
	"shoot")
		Message="Audio record $FILE1 from pulseaudio."
		echo $Message	
		shooter2
		cook $@
		;;
	*)
	Message="command not understood..."
		echo $USAGE
		exit 1
	;;
esac

[ ! -z $ARG ] || die "whatever is not available"

# --------cut--------minicorder.sh---------------------
