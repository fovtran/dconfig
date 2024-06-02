"""
Generators - Iterators
All generators are iterators, and an object is an iterator only if it implements
the __next__ and the __iter__ functions in it’s class definition.
A generator can be implemented using a generator expression, such as:

processed_values_gen = (some_function(i) for i in range(30))
which looks like list comprehension but with regular brackets, or a generator function, such as:

def generator_function():
    for i in range(30):
        yield some_function(i)
which is a function that has a yield instead of a return which is what makes it a generator.
Once you have a generator or an iterator a value can be obtained from it by calling the next function on it like so:

processed_values_gen = generator_function()
next(processed_values_gen)

Using generators and iterators we can generate infinite streams of
integers which can be fed to some output like a speaker or a file,
without these features the memory requirements would be very high.

The sine wave repeats with a time period of 2π,
so if we have to generate a 1 Hz signal with a sample rate of 512 Hz we’d
have to create 512 divisions on a number line between 0 and 2π and at
each division we apply the mathematical sine function which gives us an output sample
"""
import numpy as np

srate = 44100
frequency = 444
step_size = (2*np.pi * frequency)/srate
print(f"step size: {step_size}")

# ------------------------
import itertools,math

def get_sin_oscillator(freq, sample_rate):
    increment = (2 * math.pi * freq)/ sample_rate
    return (math.sin(v) for v in itertools.count(start=0, step=increment))

osc = get_sin_oscillator(freq=1, sample_rate=512)
samples = [next(osc) for i in range(512)]
print(osc)
print(samples)

# For example: middle C or C4 has a frequency of 261.625565 Hz
# when tuned to concert pitch, i.e. when A4 has a frequency of 440 Hz.

# controlling the phase
def get_sin_oscillator(freq, amp=1, phase=0, sample_rate=44100):
    phase = (phase / 360) * 2 * math.pi
    increment = (2 * math.pi * freq)/ sample_rate
    return (math.sin(phase + v) * amp for v in itertools.count(start=0, step=increment))

# Abstract oscillator class
"""
The above Abstract Base Class basically lays out the skeleton for an oscillator,
it’s an iterator (cause of the __iter__ and __next__) that with the getters and setters
to change the phase, amplitude and frequency without altering the values
that were set at the point of instantiation, such as when the note is pressed.
"""
from abc import ABC, abstractmethod

class Oscillator(ABC):
    def __init__(self, freq=440, phase=0, amp=1, \
                 sample_rate=44_100, wave_range=(-1, 1)):
        self._freq = freq
        self._amp = amp
        self._phase = phase
        self._sample_rate = sample_rate
        self._wave_range = wave_range

        # Properties that will be changed
        self._f = freq
        self._a = amp
        self._p = phase

    @property
    def init_freq(self):
        return self._freq

    @property
    def init_amp(self):
        return self._amp

    @property
    def init_phase(self):
        return self._phase

    @property
    def freq(self):
        return self._f

    @freq.setter
    def freq(self, value):
        self._f = value
        self._post_freq_set()

    @property
    def amp(self):
        return self._a

    @amp.setter
    def amp(self, value):
        self._a = value
        self._post_amp_set()

    @property
    def phase(self):
        return self._p

    @phase.setter
    def phase(self, value):
        self._p = value
        self._post_phase_set()

    def _post_freq_set(self):
        pass

    def _post_amp_set(self):
        pass

    def _post_phase_set(self):
        pass

    @abstractmethod
    def _initialize_osc(self):
        pass

    @staticmethod
    def squish_val(val, min_val=0, max_val=1):
        return (((val + 1) / 2 ) * (max_val - min_val)) + min_val

    @abstractmethod
    def __next__(self):
        return None

    def __iter__(self):
        self.freq = self._freq
        self.phase = self._phase
        self.amp = self._amp
        self._initialize_osc()
        return self

class SineOscillator(Oscillator):
    def _post_freq_set(self):
        self._step = (2 * math.pi * self._f) / self._sample_rate

    def _post_phase_set(self):
        self._p = (self._p / 360) * 2 * math.pi

    def _initialize_osc(self):
        self._i = 0

    def __next__(self):
        val = math.sin(self._i + self._p)
        self._i = self._i + self._step
        if self._wave_range is not (-1, 1):
            val = self.squish_val(val, *self._wave_range)
        return val * self._a

class SquareOscillator(SineOscillator):
    def __init__(self, freq=440, phase=0, amp=1, \
                 sample_rate=44_100, wave_range=(-1, 1), threshold=0):
        super().__init__(freq, phase, amp, sample_rate, wave_range)
        self.threshold = threshold

    def __next__(self):
        val = math.sin(self._i + self._p)
        self._i = self._i + self._step
        if val < self.threshold:
            val = self._wave_range[0]
        else:
            val = self._wave_range[1]
        return val * self._a

class SawtoothOscillator(Oscillator):
    def _post_freq_set(self):
        self._period = self._sample_rate / self._f
        self._post_phase_set

    def _post_phase_set(self):
        self._p = ((self._p + 90)/ 360) * self._period

    def _initialize_osc(self):
        self._i = 0

    def __next__(self):
        div = (self._i + self._p )/self._period
        val = 2 * (div - math.floor(0.5 + div))
        self._i = self._i + 1
        if self._wave_range is not (-1, 1):
            val = self.squish_val(val, *self._wave_range)
        return val * self._a

class TriangleOscillator(SawtoothOscillator):
    def __next__(self):
        div = (self._i + self._p)/self._period
        val = 2 * (div - math.floor(0.5 + div))
        val = (abs(val) - 0.5) * 2
        self._i = self._i + 1
        if self._wave_range is not (-1, 1):
            val = self.squish_val(val, *self._wave_range)
        return val * self._a

class WaveAdder:
    def __init__(self, *oscillators):
        self.oscillators = oscillators
        self.n = len(oscillators)

    def __iter__(self):
        [iter(osc) for osc in self.oscillators]
        return self

    def __next__(self):
        return sum(next(osc) for osc in self.oscillators) / self.n

import numpy as np
from scipy.io import wavfile

def wave_to_file(wav, wav2=None, fname="temp.wav", amp=0.1, sample_rate=44100):
    wav = np.array(wav)
    wav = np.int16(wav * amp * (2**15 - 1))

    if wav2 is not None:
        wav2 = np.array(wav2)
        wav2 = np.int16(wav2 * amp * (2 ** 15 - 1))
        wav = np.stack([wav, wav2]).T

    wavfile.write(fname, sample_rate, wav)

gen = WaveAdder(
    SineOscillator(freq=440),
    TriangleOscillator(freq=220, amp=0.8),
    SawtoothOscillator(freq=110, amp=0.6),
    SquareOscillator(freq=55, amp=0.4),
)
iter(gen)
wav = [next(gen) for _ in range(44100 * 4)] # 4 Seconds
wave_to_file(wav, fname="prelude_one.wav")
