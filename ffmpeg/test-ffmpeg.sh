#!/bin/bash

INRES="1440x900" # input resolution
OUTRES="1440x900" # output resolution
FPS="30" # target FPS
GOP="60" # i-frame interval, should be double of FPS, 
GOPMIN="30" # min i-frame interval, should be equal to fps, 
THREADS="2" # max 6
CBR="1000k" # constant bitrate (should be between 1000k - 3000k)
QUALITY="ultrafast"  # one of the many FFMPEG preset
AUDIO_RATE="44100"
STREAM_KEY="$1" # use the terminal command Streaming streamkeyhere to stream your video to twitch or justin
SERVER="live-fra" # twitch server in frankfurt, see https://stream.twitch.tv/ingests/ for list
TARGET="/tmp/test.flv"
ALSA_DEV="a_output.pci-0000_00_14.2.analog-surround-71.9.monitor"
ALSA_DEV="plughw:CARD=SB,DEV=0"
ALSA_DEV="0"
#ALSA_DEV="hw:CARD=SB,DEV=0"
ATYPE="pulse"
AF_SIZE="1430x400"
AFILTER1="[0:a]showfreqs=s=${AF_SIZE}:mode=line:win_func=flattop:minamp=1e-10:data=magnitude:averaging=1:ascale=log:fscale=log,format=yuv420p[vid]"
AFILTER2="[0:a]avectorscope=s=${AF_SIZE},format=yuv420p[vid]"
# showwaves: avectorscope, showcqt,showfreqs,showspectrum, ahistogram, aphasemeter, 

# modprobe snd-aloop pcm_substreams=1, add
# .asoundrc
# pcm.!default { type plug slave.pcm "hw:Loopback,0,0" }

# ffmpeg -f alsa -ac 2 -ar 44100 -i hw:Loopback,1,0 out.wav it
# A="$(pacmd list-sources | grep -PB 1 "analog.*monitor>" | head -n 1 | perl -pe 's/.* //g')"
# ffmpeg -video_size 1280x1024 -framerate 25 -f x11grab -i :0.0 -f pulse -vcodec mpeg2video -thread_queue_size 512 -ac 2 -t 02:00:00 -i "$A"

#ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f pulse -i 0 -f flv -ac 2 -ar $AUDIO_RATE \
#  -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
#  -s $OUTRES -preset $QUALITY -tune film -acodec aac -threads $THREADS -strict normal \
#  -bufsize $CBR "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"

#ffmpeg -i music.mp3 -loop 1 -i image.jpg -filter_complex \
#"[0:a]showfreqs=mode=line:ascale=log:fscale=log:s=1280x518[sf]; \
# [0:a]showwaves=s=1280x202:mode=p2p[sw]; \
# [sf][sw]vstack[fg]; \
# [1:v]scale=1280:-1,crop=iw:720[bg]; \
# [bg][fg]overlay=shortest=1:format=auto,format=yuv420p,drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf:fontcolor=white:x=10:y=10:text='\"Rated80s Prophets Prey\" by Comics On Film'[out]" \
#-map "[out]" -map 0:a -c:v libx264 -preset fast -crf 18 -c:a libopus output.mkv

#pactl list short sources
#arecord --list-devices
#ffmpeg -hide_banner -devices
#ffmpeg -hide_banner -sources
# ffmpeg -sources pulse,server=192.168.0.4
# ffmpeg -sinks pulse,server=192.168.0.4
# ffplay <(capture /dev/stdout | ffmpeg -i -) 2> /dev/null
# ffmpeg -i input.avi <options> -f matroska - | ffplay -
ffmpeg -hide_banner -f $ATYPE -i $ALSA_DEV -ar $AUDIO_RATE\
  -af "pan=stereo|c0=c1+c0" -map "0:a" \
  -filter_complex $AFILTER1 -map "[vid]" \
  -f matroska pipe:1 | ffplay -i - 
  

#-codec:v libx264 -crf 18 -preset fast -codec:a aac -strict -2 -b:a 192k output.mp4
# ffplay -f lavfi "amovie=input.flac, asplit [a][out1]; [a] ahistogram [out0]"

# start ffplay -listen 1 -timeout 10000 -f flv rtmp://127.0.0.1:5000/mystream/test
# ping 127.0.0.1 -n 6 > nul
# start ffmpeg -y -re -f lavfi -i testsrc=duration=25000:size=192x108:rate=25 -f lavfi -i sine=frequency=500 -af "azmq,volume@my=volume=1" -vcodec libx264 -tune zerolatency -crf 17 -pix_fmt yuv420p -f flv rtmp://127.0.0.1:5000/mystream/test
# echo volume@my volume 0 | zmqsend

#ffmpeg -hide_banner -f x11grab -s "$INRES" -r "$FPS" -i :0.0 -f $ATYPE -i $ALSA_DEV -f flv -ac 2 -ar $AUDIO_RATE \
#  -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p\
#  -s $OUTRES -preset $QUALITY -tune film -acodec aac -threads $THREADS -strict normal \
#  -bufsize $CBR $TARGET
