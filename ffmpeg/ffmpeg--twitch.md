# Normal stream
https://dashboard.twitch.tv/u/manux_lab/stream-manager
----
### Simple streaming
ffmpeg -f alsa -ac 2 -i hw:0,0 -f x11grab -framerate 10 -video_size 1440x900 \
  -i :0.0+0,0 -c:v libx264 -preset veryfast -maxrate 1984k -bufsize 3968k \
  -vf "format=yuv420p" -g 60 -c:a aac -b:a 128k -ar 22050 -hide_banner -loglevel panic \
  -f flv rtmp://live.twitch.tv/app/live_456732443_

### Scaling the output
#### If you want the output video frame size to be smaller than the input then you can use the ​scale video filter:
  ffmpeg -f alsa -ac 2 -i hw:0,0 -f x11grab -framerate 10 -video_size 1440x900 \
    -i :0.0+0,0 -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 3000k \
    -vf "scale=800:-1,format=yuv420p" -g 60 -c:a aac -b:a 128k -ar 44100 \
    -f flv rtmp://live.twitch.tv/app/live_456732443_5Ws1eULkJYQOAjMzOClEznVWogHjWs

### Overlay webcam
ffmpeg -f x11grab -video_size 1680x1050 -framerate 30 -i :0.0 \
  -f v4l2 -video_size 320x240 -framerate 10 -i /dev/video0 \
  -f alsa -ac 2 -i hw:0,0 -filter_complex \
  "[0:v]scale=1024:-1,setpts=PTS-STARTPTS[bg]; \
  [1:v]scale=120:-1,setpts=PTS-STARTPTS[fg]; \
  [bg][fg]overlay=W-w-10:10,format=yuv420p[out]"
  -map "[out]" -map 2:a -c:v libx264 -preset veryfast \
  -maxrate 3000k -bufsize 4000k -c:a aac -b:a 160k -ar 44100 \
  -f flv rtmp://live.twitch.tv/app/live_456732443_5Ws1eULkJYQOAjMzOClEznVWogHjWs

### Overlay webcam and logo 
ffmpeg -f x11grab -video_size 1680x1050 -framerate 30 -i :0.0 \
  -f v4l2 -video_size 320x240 -framerate 30 -i /dev/video0 \
  -f alsa -ac 2 -i hw:0,0 -i logo.png -filter_complex \
  "[0:v]scale=1024:-1,setpts=PTS-STARTPTS[bg]; \
  [1:v]scale=120:-1,setpts=PTS-STARTPTS[fg]; \
  [bg][fg]overlay=W-w-10:10[bg2]; \
  [bg2][3:v]overlay=W-w-10:H-h-10,format=yuv420p[out]"
  -map "[out]" -map 2:a -c:v libx264 -preset veryfast \
  -maxrate 3000k -bufsize 4000k -c:a aac -b:a 160k -ar 44100 -b:a 128k \
  -f flv rtmp://live.twitch.tv/app/live_456732443_5Ws1eULkJYQOAjMzOClEznVWogHjWs

### Streaming a file
ffmpeg -re -i input.mkv -c:v libx264 -preset veryfast -maxrate 3000k \
  -bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 \
  -ar 44100 -f flv rtmp://live.twitch.tv/app/<stream key>

### Encoding a file for streaming
#### If your computer is too slow to encode the file on-the-fly you can re-encode it first:
  ffmpeg -i input.mkv -c:v libx264 -preset medium -maxrate 3000k -bufsize 6000k \
    -vf "scale=1280:-1,format=yuv420p" -g 50 -c:a aac -b:a 128k -ac 2 -ar 44100 file.flv

#### Then ​stream copy it to the streaming service:
  ffmpeg -re -i file.flv -c copy -f flv rtmp://live.twitch.tv/app/<stream key>


