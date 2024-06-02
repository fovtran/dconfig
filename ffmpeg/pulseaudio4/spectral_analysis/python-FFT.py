from scipy.fftpack import fft
"""
Since our signal is sampled at a rate f_s of 100 Hz,
the FFT will return the frequency spectrum up to a
frequency of f_s / 2 = 50 Hz.
The higher your sampling rate is, the higher the maximum frequency is FFT can calculate.
"""
"""
In the get_fft_values function above,
the scipy.fftpack.fft function returns a vector of complex valued frequencies.
Since they are complex valued, they will contain a real and an imaginary part.
The real part of the complex value corresponds with the magnitude,
and the imaginary part with the phase of the signal.
Since we are only interested in the magnitude of the amplitudes,
we use np.abs() to take the real part of the frequency spectrum.
"""
"""
The FFT of an input signal of N points, will return an vector of N points.
The first half of this vector (N/2 points) contain the useful values
of the frequency spectrum from 0 Hz up to the Nyquist frequency of f_s / 2.
The second half contains the complex conjugate and can be
disregarded since it does not provide any useful information
"""
import matplotlib.pyplot as plt
import numpy as np
from scipy.io.wavfile import read
from numpy import sqrt, log10, mean

f = "/home/nosat/Desktop/REVOX/SIGNALS_BIGFILE/DOLBY/testtones/78-100hz_108dB-sweep.wav"
samprate, wavdata = read(f)

composite_y_value = wavdata

def get_fft_values(y_values, T, N, f_s):
    f_values = np.linspace(0.0, 1.0/(2.0*T), N//2)
    fft_values_ = fft(y_values)
    fft_values = 2.0/N * np.abs(fft_values_[0:N//2])
    return f_values, fft_values

t_n = 50
N = 1000
T = t_n / N
f_s = 1/T

f_values, fft_values = get_fft_values(composite_y_value, T, N, f_s)

plt.plot(f_values, fft_values, linestyle='-', color='blue')
plt.xlabel('Frequency [Hz]', fontsize=8)
plt.ylabel('Amplitude', fontsize=8)
plt.title("Frequency domain of the signal", fontsize=8)
plt.show()
