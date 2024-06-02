import soundfile as sf

data, samplerate = sf.read('existing_file.wav')
sf.write('new_file.flac', data, samplerate)

# Block Processing
# Sound files can also be read in short, optionally overlapping blocks with soundfile.blocks(). 
# For example, this calculates the signal level for each block of a long file:
import numpy as np
import soundfile as sf

rms = [np.sqrt(np.mean(block**2)) for block in
       sf.blocks('myfile.wav', blocksize=1024, overlap=512)]


import soundfile as sf

with sf.SoundFile('myfile.wav', 'r+') as f:
   while f.tell() < f.frames:
       pos = f.tell()
       data = f.read(1024)
       f.seek(pos)
       f.write(data*2)

data, samplerate = sf.read('myfile.raw', channels=1, samplerate=44100, subtype='FLOAT')

# Virtual IO
# If you have an open file-like object, Pysoundfile can open it just like regular files:
import soundfile as sf
with open('filename.flac', 'rb') as f:
    data, samplerate = sf.read(f)

# Here is an example using an HTTP request:
import io
import soundfile as sf
from urllib.request import urlopen

url = "http://tinyurl.com/shepard-risset"
data, samplerate = sf.read(io.BytesIO(urlopen(url).read()))
