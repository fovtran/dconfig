import subprocess
import sys
import os

# Creation flags
DETACHED_PROCESS = 0x00000008
CREATE_NO_WINDOW = 0x08000000
CREATE_NEW_PROCESS_GROUP = 0x00000200

cmd = 'ffmpeg.exe -f dshow -i video=screen-capture-recorder -vcodec libx264 -qp 0 -crf 0 -vf scale=1280x720 -preset ultrafast -an -y out.mp4'
r = subprocess.call(cmd.split(), shell=True) #creationflags=
