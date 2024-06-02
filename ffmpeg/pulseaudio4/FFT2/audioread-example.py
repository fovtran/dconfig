import audioread
import sys

filename=sys.argv[0]

def do_something(tr):
    return tr[:0]

with audioread.audio_open(filename) as f:
    print(f.channels, f.samplerate, f.duration)
    for buf in f:
        do_something(buf)

