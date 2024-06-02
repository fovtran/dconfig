#!/usr/bin/env python3
"""Show a text-mode spectrogram using live microphone data."""
import argparse
import math
import numpy as np
import sounddevice as sd
np.set_printoptions(linewidth=220, precision=1, suppress=False, edgeitems=20)

gain = 500000.
gradient = []
count = 50
columns = 17
high =1600 #hertz
low=320 # hertz
device = 0


try:
    samplerate = sd.query_devices(device, 'input')['default_samplerate']
    format = sd.query_devices(device, 'input')
    print(format.keys(), samplerate)

    delta_f = (high - low) / (columns - 1)
    fftsize = math.ceil(samplerate / delta_f)
    low_bin = math.floor(low / delta_f)

    def callback(indata, frames, time, status):
        if status:
            text = ' ' + str(status) + ' '
            print('\x1b[34;40m', text.center(columns, '#'), '\x1b[0m', sep='')
        if any(indata):
            magnitude = np.abs(np.fft.rfft(indata[:, 0], n=fftsize))
            magnitude *= gain / fftsize
            #line = (int(np.clip(x, 0, 1) * (len(gradient) - 1)) for x in magnitude[low_bin:low_bin + columns])
            line = np.array(magnitude[low_bin:low_bin + columns])
            if line.max()>600:
                print('\x1b[33;40m', line[np.where(line>600)], '\x1b[0m', sep='')
            else:
                print(line[np.where(line>250)])
            #print(magnitude)
        else:
            print('no input')

    with sd.InputStream(device=device, channels=1, callback=callback, blocksize=int(samplerate * count / 1000), samplerate=samplerate):
        while True:
            response = input()
            if response in ('', 'q', 'Q'):
                break
            for ch in response:
                if ch == '+':
                    gain *= 2
                elif ch == '-':
                    gain /= 2
                else:                    
                    break
except KeyboardInterrupt:
    exit('Exit by user')
except Exception as e:
    exit('Interrupted by user')