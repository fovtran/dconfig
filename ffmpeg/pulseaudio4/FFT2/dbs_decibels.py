## I don't know of any command-line tools to do this, but writing a python script with this functionality is fairly simple using scipy libraries.
# We can use scipy.io.wavfile to do the file IO, and then calculate the dB values ourselves (note that these won't necessarily be standard dB values, as those will depend on your speakers and volume settings).
# First we get the file:
from scipy.io.wavfile import read
from numpy import sqrt, log10, mean
samprate, wavdata = read('file.wav')

# We then split the file into chunks, where the number of chunks depends on how finely you want to measure the volume:
import numpy as np
chunks = np.array_split(wavdata, numchunks)

# Finally, we compute the volume of each chunk:
dbs = [20*log10( sqrt(mean(chunk**2)) ) for chunk in chunks]

# where dbs is now a list of dB values (again, not necessarily the true SPL sound levels) for each chunk of your file.
# You can also easily split up the data in a different way, using overlapping chunks, etc.

from scipy.io.wavfile import read
samprate, wavdata = read('intro.wav')
import numpy as np
import math
import statistics 
# basically taking a reading every half a second - the size of the data 
# divided by the sample rate gives us 1 second chunks so I chop 
# sample rate in half for half second chunks
chunks = np.array_split(wavdata, wavdata.size/(samprate/2))
dbs = [20*math.log10( math.sqrt(statistics.mean(chunk**2)) ) for chunk in chunks]
print(dbs)
