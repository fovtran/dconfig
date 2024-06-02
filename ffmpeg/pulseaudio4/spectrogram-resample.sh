FILE=%1
# sndfile-generate-chirp -from 200 -to 6000 -amp 1.0 -quad 48000 3 ./DOLBY/dac-chirp.wav
# sndfile-spectrogram ./DOLBY/dac-test.wav 1024 1024 spectrogram1.png 

sndfile-generate-chirp -from 200 -to 6000 -amp 1.0 -quad 48000 3 ${FILE}.wav
sndfile-spectrogram ./DOLBY/dac-test.wav 1024 1024 spectrogram-$FILE.png 

systemctl --user stop pulseaudio.service
jackd --realtime -d alsa -I audioadapter -r 48000 -C -P -D -m --hwmon --hwmeter

# que  no puedo estar con una lata de birra cerrada en la parada de bondi ahora?
# The files I uploaded are simply text descriptions of harmonics, lack phase information
# and don’t use any of the wavetables directly. The format looks like below:

AMS 1
Generate MultiCycleFM
BaseFreq 261.625549
RootKey 60
SampleRate 44100
Channels 1
BitsPerSample 32
Volume Auto
Sine 1 0.73
Sine 2 0.38
Sine 3 0.30
Sine 4 0.32
Sine 5 0.51
Sine 6 1.00
Sine 7 0.23
Sine 8 0.09

squarewave = 1 sin(w) + 1/3 sin(3w) + 1/5 sin(5w) + …
