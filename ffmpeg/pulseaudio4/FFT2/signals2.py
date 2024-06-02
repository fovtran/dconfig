"""
The frequency f is the inverse of the Period;
if a signal has a Period of 1 s, its frequency is 1 Hz,
and if the period is 10 s, the frequency is 0.1 Hz.
The period, wavelength and frequency are related to each other via formula (1):
f = \frac{1}{P} = \frac{s}{\lambda}
f = 1/P = s/lambda
where s is the speed of sound.
"""
from scipy.constants import speed_of_sound

P = 100 # period
f = 1/P

s = speed_of_sound
_lambda = 1E5
f = s/_lambda
print(f)
