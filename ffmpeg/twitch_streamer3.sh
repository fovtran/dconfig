#!/bin/bash 
function cleanup()
{
	killall -9 ffmpeg
	kill SIGINT $PID
}
trap cleanup EXIT

FRAMERATE_FINAL="10"
INRES="1440x900" # input resolution
OUTRES="1440" # output resolution horizontal. vertical is calculated. 
FPS=$FRAMERATE_FINAL # target FPS
GOP=20 # i-frame interval, should be double of FPS, 
GOPMIN=10 # min i-frame interval, should be equal to fps, 
THREADS="3" # max 6
BITRATE="1174k" # 1174
QUALITY="veryfast"  # ultrafast superfast veryfast faster fast medium slow slower veryslow placebo
AUDIO_SRATE="44100"
AUDIO_CHANNELS="2" #1 for mono output, 2 for stereo
AUDIO_ERATE="128k" #audio encoding rate
AUDIO_DEV="-f pulse -i plughw:CARD=SB,DEV=0" # -i hw:CARD=0,DEV=0
AUDIOCODEC="libmp3lame"
PULSEAUDIO="$AUDIO_DEV -ac $AUDIO_CHANNELS -b:a $AUDIO_ERATE -ar $AUDIO_SRATE"
# -af aresample=async=1000 drop frames
# -tune zerolatency
# for twitch -x264opts bitrate=$BITRATE:vbv-maxrate=$BITRATE:vbv-bufsize=$BITRATE \
I=":0.0+0,0"
STREAM_KEY="live_456732443_SkVfVzwtN9U43Eo0thB6zYLi5Uxju6" #your twitch stream key goes here
SERVER="bue01" # rio atl sao mia mia05  http://bashtech.net/twitch/ingest.php for list
VIDEOCODEC="libx264"
TARGET="rtmp://$SERVER.contribute.live-video.net/app/$STREAM_KEY"
#TARGET="-listen 2 rtmp://192.168.2.45"
#TARGET="-listen 2 rtmp://127.0.0.1"
#TARGET="-y /dev/null" 	#</dev/null>/dev/null 2>&1
OUTFMT="flv"
HWACCELAPI="-hwaccel vaapi -f x11grab"	# Apis are opencl vdpau vaapi libmfx nvenc drm

function daemon()
{
/usr/bin/ffmpeg $HWACCELAPI -s $INRES -r $FPS -probesize 16M -thread_queue_size 378 \
	-i $I -thread_queue_size 378 $PULSEAUDIO \
	-filter_complex "[1:a]channelsplit=channel_layout=stereo:channels=FR[right]" -map "[right]" \
	-acodec $AUDIOCODEC \
	-vcodec $VIDEOCODEC -g $GOP -keyint_min $GOPMIN \
	-vf "scale=$OUTRES:-1,format=yuv420p" \
	-preset $QUALITY \
	-b:v $BITRATE \
	-bufsize 1024k -threads $THREADS \
	-strict normal \
	-f $OUTFMT $TARGET 
}	# -b:v $BITRATE -minrate $BITRATE -maxrate $BITRATE 
	#-x264opts bitrate=$BITRATE:vbv-maxrate=$BITRATE:vbv-bufsize=$BITRATE 

function poll()
{
# sleep 1
PID=`pidof ffmpeg`
echo $PID
#lsof -p $PID
}

while true; do daemon;poll; done

exit 0
