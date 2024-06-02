import resampy

# Generate a sine wave at 440 Hz for 5 seconds
sr_orig = 44100.0
x = np.sin(2 * np.pi * 440.0 / sr_orig * np.arange(5 * sr_orig))
print(x)
#array([ 0.   ,  0.063, ..., -0.125, -0.063])

# Resample to 22050 with default parameters
resampy.resample(x, sr_orig, 22050)
#array([ 0.011,  0.123, ..., -0.193, -0.103])

# Resample using the fast (low-quality) filter
resampy.resample(x, sr_orig, 22050, filter='kaiser_fast')
#array([ 0.013,  0.121, ..., -0.189, -0.102])

# Resample using a high-quality filter
resampy.resample(x, sr_orig, 22050, filter='kaiser_best')
#array([ 0.011,  0.123, ..., -0.193, -0.103])

# Resample using a Hann-windowed sinc filter
resampy.resample(x, sr_orig, 22050, filter='sinc_window', window=scipy.signal.hann)
#array([ 0.011,  0.123, ..., -0.193, -0.103])

# Generate stereo data
x_right = np.sin(2 * np.pi * 880.0 / sr_orig * np.arange(len(x)))])
x_stereo = np.stack([x, x_right])
print(x_stereo.shape)
# (2, 220500)

# Resample along the time axis (1)
y_stereo = resampy.resample(x, sr_orig, 22050, axis=1)
print(y_stereo.shape)
#(2, 110250)

# --------------------------------
import numpy as np
import scipy.signal
import librosa
import resampy

# Load in some audio
x, sr_orig = librosa.load(librosa.util.example_audio_file(), sr=None, mono=False)

# Resample to 22050Hz using a Hann-windowed sinc-filter
y = resampy.resample(x, sr_orig, sr_new, filter='sinc_window', window=scipy.signal.hann)

# Or a shorter sinc-filter than the default (num_zeros=64)
y = resampy.resample(x, sr_orig, sr_new, filter='sinc_window', num_zeros=32)

# Or use the pre-built high-quality filter
y = resampy.resample(x, sr_orig, sr_new, filter='kaiser_best')

# Or use the pre-built fast filter
y = resampy.resample(x, sr_orig, sr_new, filter='kaiser_fast')

# -----------------------
import numpy as np
import scipy
import resampy
x = np.random.randn(400000)
sr_in, sr_out = 22050, 16000
%timeit resampy.resample(x, sr_in, sr_out, axis=-1)
# 858 ms ± 10 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
%timeit scipy.signal.resample(x, int(x.shape[-1] * sr_out / float(sr_in)), axis=-1)
# 206 ms ± 6.11 ms per loop (mean ± std. dev. of 7 runs, 1 loop each)
