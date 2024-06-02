from __future__ import unicode_literals
import subprocess
import sys
import os

STREAM_KEY="live_456732443_cXIM2JsQ80UkQFL4GwCLdFnsQ7wayM" #your twitch stream key goes here
SERVER="rio" # rio atl sao mia mia05  http://bashtech.net/twitch/ingest.php for list

FRAMERATE_FINAL="10"
INRES="1440x900" # input resolution
OUTRES="1440" # output resolution horizontal. vertical is calculated. 
FPS=FRAMERATE_FINAL # target FPS
GOP="96" # i-frame interval, should be double of FPS, 
GOPMIN=20 # min i-frame interval, should be equal to fps, 
I=":0.0+0,0"
VIDEOCODEC="libx264"

THREADS="3" # max 6
CBR="1174k" # 1174
QUALITY="veryfast"  # ultrafast superfast veryfast faster fast medium slow slower veryslow placebo

AUDIO_SRATE="22050"
AUDIO_CHANNELS="1" #1 for mono output, 2 for stereo
AUDIO_ERATE="96k" #audio encoding rate
#AUDIO_DEV="-f alsa -i pulse"
AUDIOCODEC="libmp3lame"
PULSEAUDIO="$AUDIO_DEV -ac $AUDIO_CHANNELS -b:a $AUDIO_ERATE -ar $AUDIO_SRATE"

TARGET="rtmp://$SERVER.contribute.live-video.net/app/" + STREAM_KEY
#TARGET="-listen 2 rtmp://192.168.2.45"
#TARGET="-y /dev/null"
OUTFMT="flv"
# Apis are opencl vdpau vaapi libmfx nvenc drm
HWACCELAPI="-hwaccel vaapi -f x11grab"

def parser():
    file_path = os.path.abspath(os.path.dirname(__file__))
    dest = os.path.join(file_path, 'downloadlist.txt')
    f = open(dest,'r')
    text = f.readlines()
    for t in text:
        yield t

prog = '/usr/bin/ffmpeg'
grabbing = HWACCELAPI + ' -s ' + INRES + ' -r ' + FPS 
graboptions = '-probesize 16M -thread_queue_size 8 '
audiosettings =  ' -i ' + I +' ' +PULSEAUDIO 
vcodec = ' -vcodec ' + VIDEOCODEC + ' -g ' + GOP  + ' -keyint_min ' + GOPMIN 
vcodec =  ' -b:v ' + CBR + ' -minrate ' + CBR 
vcodec = ' -maxrate ' +CBR + ' -vf ' + "scale=" + OUTRES+":-1,format=yuv420p" 
acodec = ' -preset ' +QUALITY + ' -acodec ' +AUDIOCODEC 
options = ' -bufsize ' +CBR + ' -threads ' +THREADS + ' -strict normal ' 
target = ' -f ' +OUTFMT +' ' +TARGET
	#</dev/null>/dev/null 2>&1

def expand():
    expand = prog + grabbing + audiosettings + vcodec + acodec + options + target
    r = subprocess.call(expand.split(), shell=True)

for ytube in parser():
    print("Downloading "+ ytube)
