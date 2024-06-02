ffmpeg -hide_banner -i .\output.avi -pix_fmt rgb24 -r 4 -s 320x200 output2.gif

pactl list | grep -A2 'Source #' | grep 'Name: ' | cut -d" " -f2
 To do this, open "~/.asoundrc" in whichever editor you prefer and add the following lines at the bottom:

pcm.pulse_monitor {
      type pulse
      device alsa_output.pci-0000_00_14.2.analog-stereo.monitor
}
ctl.pulse_monitor {
      type pulse
      device alsa_output.pci-0000_00_14.2.analog-stereo.monitor
}

-f alsa -ac 2 -i pulse_mic \
-f alsa -ac 2 -i pulse_monitor \

-filter_complex amix=inputs=2:duration=first
-g 30 -keyint_min 15

-bsf:a aac_adtstoasc \
-c:a aac              \
-c:v libx264
-i overlay.png  \
-filter_complex "[0:v][1:v]overlay=x=0:y=0,zmq=bind_address=tcp\\\://127.0.0.1\\\:1236" \
-af "azmq=bind_address=tcp\\\://127.0.0.1\\\:1235,volume=1" \

ffmpeg -i input.mp4 -i image.png \
-filter_complex "[0:v][1:v] overlay=W-w:H-h:enable='between(t,0,20)'" \
-pix_fmt yuv420p -c:a copy output.mp4
- And I can remove (control) the overlay by sending a message through ZeroMQ:
Parsed_overlay_0 x 1280
