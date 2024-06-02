using Pkg
Pkg.add("linearalgebra")
Pkg.update("LinearAlgebra")
Pkg.add("WAV")
Pkg.add("Gadfly")
Pkg.add("Statistics")

using LinearAlgebra:log10,log
using Statistics:mean

# dB = 10* log10(x)
dB(x) = 10* log10(x / 10E-12)
# dB (generic function with 1 method)
dB(0)
dB(1)
dB(2)
dB(3)

[dB(n) for n in reverse([10E-15,10E-14,10E-13,10E-12,10E-11,10E-10,10E-9,10E-8,10E-7,10E-6,10E-5,10E-4,10E-3,10E-2,10E-1,0,1,10,100,10E2,10E3,10E4,10E5,10E6,10E7])]

# dB Scales
log(2^2) == 2* log(2)
# true

# == 20* log(p2/p1) # dB
# == 10* log(p2^2/p1^2) # dB
# == 10* log(p2/p1)

# pref = 20 micropascals (20 μPa), or 0.02 mPa. This is very low: it is 2 ten billionths of an atmosphere. 
# 20* log (p2/pref) = 86 dB

# where pref is the sound pressure of the reference level, and p2 that of the sound in question. Divide both sides by 20:
# log (p2/pref) = 4.3
# p2/pref = 104.3

# 4 is the log of 10 thousand, 0.3 is the log of 2, so this sound has a sound pressure 20 thousand times greater than that of the reference level (p2/pref = 20,000) or an intensity 400 million times the reference intensity. 86 dB is a loud sound but not dangerous—provided that exposure is brief.
# What does 0 dB mean? This level occurs when the measured intensity is equal to the reference level. i.e., it is the sound level corresponding to 0.02 mPa. In this case we have

# sound level = 20 log (pmeasured/pref) = 20 log 1 = 0 dB

# You can always calculate dBFS (dB re digital Full Scale) as
xmax = prevfloat(typemax(Float32))
sine(x) = sin(x) * xmax
dBFS(x) = 20* log(x / xmax)
# where 𝑥 is your sample and 𝑥𝑚𝑎𝑥 the clipping point of your AD or DA converter, i.e. 32768 for signed 16-bit integers.

using WAV
f = "/home/nosat/Desktop/REVOX/SIGNALS_BIGFILE/DOLBY/testtones/78-100hz_108dB-sweep.wav"
f = "/opt/VIDEO/testmic2.wav"
y, fs, nbits, opts = WAV.wavread(f)
print(fs, nbits, opts)
markers = wav_cue_read(opts)

chunks = length(y) /(fs/2)
print(chunks)
y = y[:,2]
mytype = Float64
# Test1
NdB(X) = [10* log10(x / 10E-12) for x in X]
#vals = [-(Int64(floor(x))) for x in y / eps(mytype)]
#NdB(vals)

# Test2
val(x) = 10* log10( Int64(floor(x/eps(Float64))) )
# 0.0
0.0 == val(.0000002) # FLoat32
0.0 == val(.0000000000000003) # Float64

# Power Level
# 32.64^2 / 600
#   1.775616

P = 1
P0 = eps(Float32)
Lp = 1/2 * log(P/P0)
Np = log10(P/P0)
B(P) = 10* log10(P/P0) # dB

# Decibels 
# db(X) = [10*log10(sqrt(x)^2) for x in X]
mytype = Float64
conv(x) = Int64(floor(x/eps(mytype)))
dbs(Y) = [10* log10(mean(sqrt(x^2))) for x in Y]

# in volts...
v = mean((xmax/ eps(Float32)) * (5/y))
milivolts = 5000
offset_mv = mean(y* (milivolts/ eps(Float32)))

d = dbs(y)
d= [x for x in d if x!=-Inf]

# Crap
import Gadfly; pl=Gadfly
histplot=pl.plot(
  x=d/1000, pl.Geom.histogram(),
  pl.Guide.xlabel("Latency (us)"),
  pl.Guide.ylabel("Histogram counts"))

out_chunks = wav_cue_write(markers)
wavwrite(x, "/tmp/out.wav", Fs=fs, nbits=16, compression=WAVE_FORMAT_PCM, chunks=out_chunks)
