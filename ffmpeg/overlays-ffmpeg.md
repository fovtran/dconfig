https://ffmpeg.org/ffmpeg-filters.html#overlay-1

How to Add a Transparent Overlay on a Video using FFmpeg

Overlaying an image on top of a video
ffmpeg -i video.mp4 -i overlay.png -filter_complex [0][1]overlay=x=0:y=0 output.mp4

To place the overlay in the bottom-left corner:

ffmpeg -i video.mp4 -i overlay.png -filter_complex [0][1]overlay=x=0:y=(main_h-overlay_h) output.mp4

To place the overlay in the bottom-right corner:

ffmpeg -i video.mp4 -i overlay.png -filter_complex [0][1]overlay=x=(main_w-overlay_w):y=(main_h-overlay_h) output.mp4

To place the overlay in the top-left corner:

ffmpeg -i video.mp4 -i overlay.png -filter_complex [0][1]overlay=x=0:y=0 output.mp4

To place the overlay in the top-right corner:

ffmpeg -i video.mp4 -i overlay.png -filter_complex [0][1]overlay=x=(main_w-overlay_w):y=0 output.mp4

To place the overlay in the center:

ffmpeg -i video.mp4 -i overlay.png -filter_complex [0][1]overlay=x=(main_w-overlay_w)/2:y=(main_h-overlay_h)/2 output.mp4


Padding
ffmpeg -i video.mp4 -i overlay.png -filter_complex [0][1]overlay=x=(main_w-overlay_w-100):y=100 output.mp4
Overlaying a sequence of images
ffmpeg -i video.mp4 -i overlay1.png -i overlay2.png -i overlay3.png -filter_complex [0][1]overlay=enable='between(t,0,4)':x=0:y=0[out];[out][2]overlay=enable='between(t,4,8)':x=0:y=0[out];[out][3]overlay=enable='between(t,8,12)':x=0:y=0 output.mp4

Overlaying a GIF or video
ffmpeg -i video.mp4 -stream_loop -1 -i overlay.gif -filter_complex [0][1]overlay=x=0:y=0:shortest=1 output.mp4
