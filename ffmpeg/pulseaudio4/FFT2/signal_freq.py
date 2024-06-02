from scipy import signal
b = signal.firwin(80, 0.5, window=('kaiser', 8))
w, h = signal.freqz(b)

b = np.sin(np.linspace(-np.pi,np.pi,16))

w, h = signal.freqz(b)

np.degrees(w)

w = np.fft.fft(b)

f = np.logspace(1, 3); w = 2 * np.pi * f;w
r = np.linspace(-np.pi, np.pi); w = np.sin(2 * r) * 440;w;plt.plot(w);plt.show()
cycles=1; amplitude=1; f0= 440; f = 1 / f0; r = np.linspace(-np.pi, np.pi, f0*cycles); w = r*cycles; print(w); p(amplitude * np.sin(w))
cycles=1; amplitude=5; f0= 440; f = 1 / f0; r = np.linspace(-np.pi, np.pi, f0*cycles); w = r*cycles; print(w); w1= (amplitude/2 * np.sin(w));p(w1); w2= np.fft.fft(w1); plt.plot(w2[::44].imag);plt.show()
cycles=1; amplitude=5; f0= 440; f = 1 / f0; r = np.linspace(-np.pi, np.pi, f0*cycles); w = r*cycles; print(w); w1= (amplitude/2 * np.sin(w));p(w1); w2,h= signal.freqz(w1); plt.plot(w2[::1]);plt.show()
cycles=1; amplitude=1; f0= 440; f = 1 / f0; r = np.linspace(-np.pi, np.pi, f0*cycles); w = r*cycles; print(w); w1= (amplitude/2 * np.sin(w));p(w1); w2= np.fft.rfft(w); plt.plot(w2[::1].imag);plt.show()
cycles=1; amplitude=1; f0= 440; f = 1 / f0; r = np.linspace(-np.pi, np.pi, f0*cycles); w = r*cycles;w1= (amplitude/2 * np.sin(w)); w2= np.fft.fft(w); plt.plot(w2[::1].imag);plt.show()

def p(x):
    plt.plot(x)
    plt.show()
#-------------------
f = 440  # Frequency
f_s = 10000  # Sampling rate
t = np.linspace(0, 2, 2 * f_s, endpoint=False)
x1 = np.sin(f * 2 * np.pi * t)

f = 100  # Frequency
f_s = 10000  # Sampling rate
t = np.linspace(0, 2, 2 * f_s, endpoint=False)
x2 = np.sin(f * 2 * np.pi * t)

x=x1+x2

from scipy import fftpack
X = fftpack.fft(x)
freqs = fftpack.fftfreq(len(x)) * f_s
fig, ax = plt.subplots()
ax.stem(freqs, np.abs(X), use_line_collection=True)
ax.set_xlabel('Frequency in Hertz [Hz]')
ax.set_ylabel('Frequency Domain (Spectrum) Magnitude')
ax.set_xlim(0, f_s / 2)
ax.set_ylim(-5, f_s)
plt.show()
# ---------------
import numpy as np
from scipy import fftpack

f = 440  # Frequency
f_s = 10000  # Sampling rate
t = np.linspace(0, 2, 2 * f_s, endpoint=False)
x1 = np.sin(f * 2 * np.pi * t)

f = 100  # Frequency
f_s = 10000  # Sampling rate
t = np.linspace(0, 2, 2 * f_s, endpoint=False)
x2 = np.sin(f * 2 * np.pi * t)

x=x1*1.5 + x2*0.1

X = fftpack.fft(x)
X = np.fft.fft(x)
freqs = fftpack.fftfreq(len(x)) * f_s
[(x,y/f_s) for x,y in zip(freqs,np.abs(X)) if np.abs(y)>10]  # y needs to be amplitude normalized
[print("freq: {:06.3f} mag: {:06.3f}".format(x,y/f_s)) for x,y in zip(freqs,np.abs(X)) if np.abs(y)>10 and x>0.01]

#-------------------------------
from scipy import signal
sys = signal.TransferFunction([3], [1,1])
f = logspace(1, 5, f_s)
w, mag, phase = signal.bode(sys,X)
#plt.plot(mag[::2])
plt.semilogx( f, mag[::2]);
plt.show()

#---------------------

from pylab import *
from scipy import signal

system = signal.lti([1], [1/(4000*pi),1])
f = logspace(1, 5)
w = 2 * pi * f

w, mag, phase = signal.bode(system,w)

semilogx( f, mag);
