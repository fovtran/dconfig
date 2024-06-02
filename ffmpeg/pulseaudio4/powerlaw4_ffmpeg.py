# ffmpeg /
# /xbin/bin/fd --glob '*.wav' ~/Desktop/
import subprocess
from pathlib import Path
import os.path
from numpy import array

DEBUG=True
"""
ffmpeg -f alsa -i default /tmp/testmic_noise.mp3
ffmpeg -i /opt/VIDEO/testmic_noise.mp3 -lavfi showspectrumpic=s=1440x900:mode=separate testmic_noise.png
ffmpeg -f alsa -i default /tmp/testmic_clean.mp3

ffmpeg -i /opt/VIDEO/testmic_clean.mp3 -lavfi showspectrumpic=s=1440x900:mode=separate testmic_clean.png
ffmpeg -i input -map 0 -c:v libx264 -c:a aac -maxrate 1000k -bufsize 2000k -g 50 -f tee "[f=flv:onfail=ignore]rtmp://facebook|[f=flv:onfail=ignore]rtmp://youtube|[f=segment:strftime=1:segment_time=60]local_%F_%H-%M-%S.mkv"

sox /opt/VIDEO/testmic2.mp3 -n spectrogram -p 2 -S 5 -y 900 -o testmic_clean.png
ffmpeg -i /opt/VIDEO/testmic3.mp3 -lavfi showspectrumpic=s=1440x900:mode=separate testmic8.png
"""
cmd1 = lambda fname1,fname2: ['/usr/bin/ffmpeg', '-y', '-hide_banner', '-i',fname1, '-lavfi', 'showspectrumpic=s=1440x900:mode=separate', fname2]
cmd2 = lambda fname1,fname2: ['/usr/bin/sox',fname1, '--multi-threaded', '-n', 'spectrogram', '-p', "2",'-S',"5", '-y', "900", '-o', fname2]
cmd3 = lambda fname1,fname2: ['/usr/bin/stat',fname1]
cmd4 = lambda fmt, home: ['/xbin/bin/fd','--glob',fmt, home]

def worker1(out,err):
	listout = []
	for e in array(out.split(b'\n')):
		p = Path(str(e))
		if p.is_file: 
			output = Path.joinpath(p.parent, str(p.name).replace('.wav', '.png'))
			fullin = e
			print(f"-> {fullin}")
			fmt2 = os.path.join(target, output.name).encode('utf8') # f"{target}/{output}")
			if len(p.name) >0:
				# cleanup Path code
				listout.append((fullin, fmt2.replace(b"'",b'')))

	return array(listout)

def worker2(out,err):
	if err is not None:
		print(err)
	else:
		print(out)

def batchcall(cmd=None):
	print(cmd)
	p = subprocess.Popen(cmd, stdout=subprocess.PIPE)
	out, err = p.communicate()
	return (out,err)

def scanwav(home='', target='', fmt='*.wav'):	
	print("selected: {fmt} at {home}") # key = f" \"{fmt}\" "
	cmd = cmd4(fmt,home)
	out,err = batchcall(cmd=cmd)
	xarray = worker1(out,err)
	return xarray


home = "/home/nosat/Desktop"
target = '/tmp'
S = scanwav(home=home, target=target)
# print(S)

for x,y in S:
	out,err = batchcall(cmd= cmd1(x, y))
	worker2(out,err)
