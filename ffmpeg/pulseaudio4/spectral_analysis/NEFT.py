import matplotlib.pyplot as plt
import numpy as np

plt.rcParams["figure.figsize"] = [7.50, 3.50]
plt.rcParams["figure.autolayout"] = True

dt = 0.0005
t = np.arange(0.0, 20.0, dt)

s1 = np.sin(2 * np.pi * 100 * t)
s2 = 2 * np.sin(2 * np.pi * 400 * t)
s2[t <= 10] = s2[12 <= t] = 0

nse = 0.06 * np.random.random(size=len(t))
x = s1 + s2 + nse
NFFT = 4096
Fs = int(1.0 / dt)

fig, (ax1, ax2) = plt.subplots(nrows=2)
ax1.plot(t, x)
ax1.grid(axis="x", ls="dotted", lw=2, color="red")
ax1.margins(x=0)

Pxx, freqs, bins, im = ax2.specgram(x, NFFT=NFFT, Fs=Fs, noverlap=900)
ax2.grid(axis="x", ls="dotted", lw=2, color="red")
plt.show()
