# Encoding for streaming sites

# Guide
This guide assumes that you will be using the libx264 encoder, 
which currently offers the best possible quality at fast encoding speeds. 
Other encoders may be more efficient, but slower, e.g. libx265. 
Also, H.264 video provides better compatibility with client devices. 
For more info, please read the H.264 Encoding Guide.

Note: You may have to tweak the commands and settings listed below, e.g. 
by customizing the -crf, -preset, -maxrate, -bufsize, and -g options. 
Make sure you understand what they mean, and visually inspect your output.

----
-crf

Consider this to be as close as you can get to a "constant quality" mode. Range is 0-51: 0 is lossless, 18 is often considered to be roughly "visually lossless", 23 is the default, and 51 is the worst. Generally you want to use the highest value that still provides an acceptable quality. If you do not know what to choose then 23-28 will probably be acceptable for streaming.
-preset

This provides the compression to encoding speed ratio. Use the slowest preset you can: ultrafast,superfast, veryfast, faster, fast, medium, slow, slower, veryslow, placebo. Try -preset veryfast if you are unsure of what to choose, then watch the console output or the video to see if the encoder is keeping up with your desired output frame rate: if it is not then use a faster preset and/or reduce your -video_size.
-maxrate

Anytime you are encoding video with bandwidth as a limiting factor you should be using VBV (Video Buffer Verifier) with the -maxrate and -bufsize options:
    Assuming your upload rate is 1024kbit/s (1 megabit/s), and assuming you can reliably utilize 80% of that = 820 kbit/s. Audio will consume 128 kbit/s (64k/channel for stereo, but you can of course use a different audio bitrate) leaving ~692 kbit/s for video: this is your -maxrate value. 
    If you have a sane upload rate, or do not know what to choose then a -maxrate value of up to 3000k-4000k will probably be fine if your upload rate can handle it (depending on your input complexity and -video_size). Refer to your streaming service for any limitations that may apply. 
    Note that the claimed data rate pay your ISP for may not actually be what you get. You can use a site like ​speedtest.net to test. 

----
-bufsize

-bufsize sets the buffer size, and can be 1-2 seconds for most gaming screencasts, and up to 5 seconds for more static content. If you use -maxrate 960k then use a -bufsize of 960k-1920k. You will have to experiment to see what looks best for your content. Refer to your streaming service for the recommended buffer size (it may be shown in seconds or bits).
-g

Use a 2 second GOP (Group of Pictures), so simply multiply your output frame rate * 2. 
For example, if your input is -framerate 30, then use -g 60.
Streaming your desktop
Without scaling the output

If you want the output video frame size to be the same as the input:

$ ffmpeg -f alsa -ac 2 -i hw:0,0 -f x11grab -framerate 30 -video_size 1280x720 \
-i :0.0+0,0 -c:v libx264 -preset veryfast -maxrate 1984k -bufsize 3968k \
-vf "format=yuv420p" -g 60 -c:a aac -b:a 128k -ar 44100 \
-f flv rtmp://live.twitch.tv/app/<stream key>

Scaling the output

If you want the output video frame size to be smaller than the input then you can use the ​scale video filter:

$ ffmpeg -f alsa -ac 2 -i hw:0,0 -f x11grab -framerate 30 -video_size 1680x1050 \
-i :0.0+0,0 -c:v libx264 -preset veryfast -maxrate 3000k -bufsize 3000k \
-vf "scale=1280:-1,format=yuv420p" -g 60 -c:a aac -b:a 128k -ar 44100 \
-f flv rtmp://live.twitch.tv/app/<stream key>

The -1 in the scale filter example will automatically calculate the correct value to preserve the height. In this case the output will have a frame size of 1280x800.
With webcam overlay

This will place your webcam overlay in the top right:

$ ffmpeg -f x11grab -video_size 1680x1050 -framerate 30 -i :0.0 \
-f v4l2 -video_size 320x240 -framerate 30 -i /dev/video0 \
-f alsa -ac 2 -i hw:0,0 -filter_complex \
"[0:v]scale=1024:-1,setpts=PTS-STARTPTS[bg]; \
 [1:v]scale=120:-1,setpts=PTS-STARTPTS[fg]; \
 [bg][fg]overlay=W-w-10:10,format=yuv420p[out]"
-map "[out]" -map 2:a -c:v libx264 -preset veryfast \
-maxrate 3000k -bufsize 4000k -c:a aac -b:a 160k -ar 44100 \
-f flv rtmp://live.twitch.tv/app/<stream key>

    You can see additional details your webcam with something like: ffmpeg -f v4l2 -list_formats all -i /dev/video0 or with v4l2-ctl --list-formats-ext. See the documentation on the ​video4linux2 (v4l2) input device for more info. 

    Your webcam may natively support whatever frame size you want to overlay onto the main video, so scaling the webcam video as shown in this example can be omitted (just set the appropriate v4l2 -video_size and remove the scale=120:-1,). 

With webcam overlay and logo

This will place your webcam overlay in the top right, and a logo in the bottom left:

$ ffmpeg -f x11grab -video_size 1680x1050 -framerate 30 -i :0.0 \
-f v4l2 -video_size 320x240 -framerate 30 -i /dev/video0 \
-f alsa -ac 2 -i hw:0,0 -i logo.png -filter_complex \
"[0:v]scale=1024:-1,setpts=PTS-STARTPTS[bg]; \
 [1:v]scale=120:-1,setpts=PTS-STARTPTS[fg]; \
 [bg][fg]overlay=W-w-10:10[bg2]; \
 [bg2][3:v]overlay=W-w-10:H-h-10,format=yuv420p[out]"
-map "[out]" -map 2:a -c:v libx264 -preset veryfast \
-maxrate 3000k -bufsize 4000k -c:a aac -b:a 160k -ar 44100 -b:a 128k \
-f flv rtmp://live.twitch.tv/app/<stream key>

Streaming a file

$ ffmpeg -re -i input.mkv -c:v libx264 -preset veryfast -maxrate 3000k \
-bufsize 6000k -pix_fmt yuv420p -g 50 -c:a aac -b:a 160k -ac 2 \
-ar 44100 -f flv rtmp://live.twitch.tv/app/<stream key>

Encoding a file for streaming

If your computer is too slow to encode the file on-the-fly like the example above then you can re-encode it first:

$ ffmpeg -i input.mkv -c:v libx264 -preset medium -maxrate 3000k -bufsize 6000k \
-vf "scale=1280:-1,format=yuv420p" -g 50 -c:a aac -b:a 128k -ac 2 -ar 44100 file.flv

Then ​stream copy it to the streaming service:

$ ffmpeg -re -i file.flv -c copy -f flv rtmp://live.twitch.tv/app/<stream key>

Outputting to multiple streaming services & local file

You can use the tee muxer to efficiently stream to multiple sites and save a local copy if desired. Using tee will allow you to encode only once and send the same data to multiple outputs. Using the onfail option will allow the other streams to continue if one fails.

$ ffmpeg -i input -map 0 -c:v libx264 -c:a aac -maxrate 1000k -bufsize 2000k -g 50 -f tee \
"[f=flv:onfail=ignore]rtmp://facebook|[f=flv:onfail=ignore]rtmp://youtube|local_file.mkv"

Some encoders may need different options depending on the output format; the auto-detection of this can not work with the tee muxer, so they need to be explicitly specified. The main example is the global_header flag.

$ ffmpeg -i input -map 0 -flags +global_header -c:v libx264 -c:a aac -maxrate 1000k -bufsize 2000k -g 50 -f tee \
"[f=flv:onfail=ignore]rtmp://facebook|[f=flv:onfail=ignore]rtmp://youtube|local_file.mkv"

Notes

    Linux users can use xwininfo | grep geometry to select the target window and get placement coordinates. For example, an output of -geometry 800x600+284+175 would result in using -video_size 800x600 -i :0.0+284,175. You can also use it to automatically enter the input screen size: -video_size $(xwininfo -root | awk '/-geo/{print $2}'). 

    The ​pulse input device (requires --enable-libpulse) can be an alternative to the ​ALSA input device, as in: -f pulse -i default. 

    Windows users can use the ​Windows DirectShow (dshow) input device. Also see: How to grab the desktop (screen) with FFmpeg. 

Getting help

Always use a recent ffmpeg. See the compilation guides for more information. 
