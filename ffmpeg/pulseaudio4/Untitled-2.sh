

#!/bin/bash

# Rtsp to youtube streaming with ffmpeg

VBR="1000k" # Bitrate of the output video, bandwidth 1000k = 1Mbit/s
QUAL="ultrafast" # Encoding speed
YOUTUBE_URL="rtmp://a.rtmp.youtube.com/live2" # RTMP youtube URL
THREADS="0" # Number of cores, insert 0 for ffmpeg to autoselect, more threads = more FPS

CAMUSER="user"
CAMPASS="password"
CAMIP="192.168.0.2"
CAMPORT="88"
VIDEOCHANNEL="videoSub" # videoMain and VideoSub for Foscam cameras

SOURCE="rtsp://${CAMUSER}:${CAMPASS}@${CAMIP}:${CAMPORT}/${VIDEOCHANNEL}" # Camera source
KEY="xxx-xxxx-xxxx-xxxx" # Youtube account key

# To download fonts
# wget -O /usr/local/share/fonts/open-sans.zip "https://www.fontsquirrel.com/fonts/download/open-sans";unzip open-sans.zip
FONT="/usr/local/share/fonts/OpenSans-Regular.ttf"
FONTSIZE="15"

# Text allingment
x="5"
y="60"

# Other
box="1" # enable box
boxcolor="black@0.5" # box background color with transparency factor
textfile="ffmpeg.txt"
reloadtext="1" # Reload textfile after each frame, usefull for overlaying changing data 
# like weather info. To update the textfile while streaming, you need to use mv command or a crash
# is going to happen when you update the textfile.
# Example:
# wget -q https://something.com/ -O - | grep somevalue > ffmpegraw.txt; mv ffmpegraw.txt ffmpeg.txt
boxborderwidth="5"

# Ffmpeg with drawtext, 
    ffmpeg -loglevel panic \
    -f lavfi -i anullsrc \
    -rtsp_transport tcp \
    -i "$SOURCE" \
    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -g 20 -b:v $VBR \
    -vf "drawtext="fontfile=${FONT}":textfile=${textfile}:x=${x}:y=${y}:reload=${reloadtext}: \
    fontcolor=white:fontsize=${FONTSIZE}:box=${box}:boxborderw=${boxborderwidth}:boxcolor=${boxcolor}" \
    -threads $THREADS -bufsize 512k \
    -f flv "$YOUTUBE_URL/$KEY"

# Copy stream only, don't encode
#ffmpeg \
#    -f lavfi -i anullsrc \
#    -rtsp_transport tcp \
#    -i "$SOURCE" \
#    -vcodec libx264 -pix_fmt yuv420p -preset $QUAL -g 20 -c:v copy -b:v $VBR \
#    -f flv "$YOUTUBE_URL/$KEY"

Overlayed data over webcam stream example:

To run the script in background you need to add nohup otherwise ffmpeg will hang.

nohup bash this_script.sh &

Ffmpeg likes to crash from time to time. Create a script to check for ffmpeg process and restart it if there is no process running.

#!/bin/bash
#
# Description: Checks for existing ffmpeg process and starts one if needed
#
script=/path/to/first_script.sh

if ! pgrep -x "ffmpeg" > /dev/null
then
    /bin/bash $script > /dev/null 2>&1 &
fi

Save script as check_ffmpeg.sh

chmod +x check_ffmpeg.sh

Run the script with crontab every minute.

crontab -e

* * * * * sudo bash /path_to_script/check_ffmpeg.sh

