parec -d steam.monitor | oggenc -b 192 -o steam.ogg --raw -

parec --format=s16le -d record-n-play.monitor | \
  lame -r --quiet -q 3 --lowpass 17 --abr 192 - "temp.mp3" \
   > /dev/null &1>/dev/null
$ killall -q parec lame

parec --monitor-stream  $(pacmd list-sink-inputs|tac|perl -E'undef$/;$_=<>;/RUNNING.*?index: (\d+)\n/s;say $1') --format=s16le --channels=2 --file-format=aiff newrecording.aiff

SLAVE_FOR_PLAYBACK=alsa_output.pci-0000_2f_00.4.iec958-stereo
VOLCTRL_SINK_NAME=rec-mon-vol
RECMON_SINK_NAME=rec-n-play

pacmd load-module module-combine-sink sink_name=$VOLCTRL_SINK_NAME slaves=$SLAVE_FOR_PLAYBACK sink_properties=device.description="Recording-Monitor-Volume" 
pacmd load-module module-combine-sink sink_name=$RECMON_SINK_NAME  slaves=$VOLCTRL_SINK_NAME sink_properties=device.description="Record-and-Monitor"

gst-launch-1.0 filesrc location="/root/notify.mp3" ! decodebin ! audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! wavenc ! filesink location=/tmp/snapfifo


# Windows (receiver) side:
.\ffplay.exe -nodisp -ac 2 -acodec pcm_u8 -ar 48000 -analyzeduration 0 -probesize 32 -f u8 -i udp://0.0.0.0:18181?listen=1

# Linux (transmitter) side:
pactl load-module module-null-sink sink_name=remote
ffmpeg -f pulse -i "remote.monitor" -ac 2 -acodec pcm_u8 -ar 48000 -f u8 "udp://RECEIVER:18181"
pavucontrol # Change the default output to the Null sink or move single applications to this "output" device.



16bit uncompressed stream
Windows (receiver) side:

.\ffplay -nodisp -ac 2 -acodec pcm_s16le -ar 48000 -analyzeduration 0 -probesize 32 -f s16le -i udp://0.0.0.0:18181?listen=1

Linux (transmitter) side:

pactl load-module module-null-sink sink_name=remote
ffmpeg -f pulse -i "remote.monitor" -ac 2 -acodec pcm_s16le -ar 48000 -f s16le "udp://<RECEIVER'S IP ADDRESS>:18181"

ffmpeg -fflags nobuffer -flags low_delay -f pulse -i "remote.monitor" -ac 2 -acodec pcm_s16le -ar 48000 -f s16le "udp://<RECEIVER'S IP ADDRESS>:18181"

youtube-dl "http://www.youtube.com/watch?v=0Bmhjf0rKe8"
avconv -i 0Bmhjf0rKe8.flv -vn -c:a libvorbis -b:a 64k 0Bmhjf0rKe8.ogg
avconv -i 0Bmhjf0rKe8.flv -c:v copy -bsf:v h264_mp4toannexb -an 0Bmhjf0rKe8.h264
avconv -i 0Bmhjf0rKe8.h264 -i 0Bmhjf0rKe8.ogg -c copy 0Bmhjf0rKe8.mkv
mplayer 0Bmhjf0rKe8.mkv
avconv -i 0Bmhjf0rKe8.flv -i 0Bmhjf0rKe8.ogg -c copy -map 0:0 -map 1:0 0Bmhjf0rKe8.mp4
mplayer 0Bmhjf0rKe8.mp4

    pcm.snapcast {
        type rate
        slave {
            pcm writeSnapFifo # Direct to the plugin which will write to a file
            format S16_LE
            rate 48000
        }
    }

    pcm.writeSnapFifo {
        type file
        slave.pcm null
        file "/tmp/snapfifo"
        format "raw"
    }

gmediarender --gstout-audiopipe 'audioresample ! audio/x-raw, rate=44100, format=S16LE ! filesink location=/tmp/fifo'

mplayer visual.fifo -demuxer rawvideo -rawvideo fps=25:w=640:h:480 -audiofile file.mp3
mplayer /run/user/1000/pulse/fifo_output -demuxer rawvideo
