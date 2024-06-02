"""
Calculating the auto-correlation in Python
The auto-correlation function calculates the correlation of a signal with a time-delayed version of itself.
The idea behind it is that if a signal contain a pattern which repeats itself after
a time-period of \tau seconds, there will be a high correlation between
the signal and a \tau sec delayed version of the signal.

Unfortunately there is no standard function to calculate the auto-correlation of a function in SciPy.
But we can make one ourselves using the correlate() function of numpy.
Our function returns the correlation value, as a function of the time-delay \tau.
Naturally, this time-delay can not be more than the full length of the signal (which is in our case 2.56 sec).
"""
"""
Figure 5. The autocorrelation of our composite function.

Converting the values of the auto-correlation peaks from the time-domain to the frequency domain should result in the same peaks as the ones calculated by the FFT. The frequency of a signal thus can be found with the auto-correlation as well as with the FFT.
However, because it is more precise, the FFT is almost always used for frequency detection.

Fun fact: the auto-correlation and the PSD are Fourier Transform pairs, i.e. the PSD can be calculated by taking the FFT of the auto-correlation function, and the auto-correlation can be calculated by taking the Inverse Fourier Transform of the PSD function.
"""
import matplotlib.pyplot as plt
import numpy as np

def autocorr(x):
    result = np.correlate(x, x, mode='full')
    return result[len(result)//2:]

def get_autocorr_values(y_values, T, N, f_s):
    autocorr_values = autocorr(y_values)
    x_values = np.array([T * jj for jj in range(0, N)])
    return x_values, autocorr_values

t_n = 10
N = 1000
T = t_n / N
f_s = 1/T

t_values, autocorr_values = get_autocorr_values(composite_y_value, T, N, f_s)

plt.plot(t_values, autocorr_values, linestyle='-', color='blue')
plt.xlabel('time delay [s]')
plt.ylabel('Autocorrelation amplitude')
plt.show()
