import numpy as np
"""
Conversion: Voltage V to Level, dB, dBu, dBV,
and power level dBm with impedance value

The RMS value of a set of values is the square root of the 
arithmetic mean (average) of the squares of the original values.

The index u at decibel (dB) means unloaded source, V (volt). Some say: The "u" in dBu
implies also that the load impedance is unspecified, or unterminated and is likely to be high.
The index m at dB (decibel) means 1 milliwatt (power) as reference value for 0 dB.

What is dBu? That has nothing to do with power.
A logarithmic voltage ratio with a reference voltage of V0= 0.7746 volt ≡ 0 dBu
 
What is dBV?
A logarithmic voltage ratio with a reference voltage of V0 = 1.0000 volt ≡ 0 dBV
The max. domestic recording level of −10 dBV means 0.3162 volts, that is −7.78 dBu

Level L  in dB = 20 * log 	(V / V_0) 
Voltage V = V_0 * 10 **(L in dB / 20)
"""
# Voltage Levels
Lu = 0.0dBu  # Reference 0.775V
Lv = 0.0dBV  # Reference 1V
# Power level
L = 0.0 dBm # 1mw at 600 ohms.

"""
 What is dBm? That has nothing to do with voltage.
A logarithmic ratio with a reference power of P0 = 1.000 milliwatt ≡ 0 dBm.
"""
Levell  Lp = 10*log10 ( P / P_0 ) # dBm
Power P = P_0 * 10**(Lp / 10)     # Watts

"""
dBm indicates that the reference power is P0 = 1 milliwatt = 0.001 watt ≡ 0 dBm 

Telephone lines need an input impedance and
an output impedance of 600 ohms for
impedance matching (power matching).
"""
# Reference voltage at 600 ohms – 1 mW according to 0 dBm
V = sqrt(P*R)  = sqrt( 0.001W * 600ohm ) = 0.7746V  = 774.6mV
# Reference voltage at 50 Ohm – 1 mW according to 0 dBm
V = sqrt(P*R)  = sqrt( 0.001W * 50ohm ) = 0.2236V  = 223.6mV

"""
dBu is a voltage standard where "zero" (as in zero dB on your meters) is considered to be
0.775 volts and +4 dBu is therefore 1.23 volts. dBm is a power measurement (the "m" stands
for milliwatts), where +4 also happens to be 1.23 volts if the load impedance is 600 ohms.
In many cases (and this is "old school" audio) a 600 ohm load can be assumed, however,
in modern day interconnects input impedances are usually much higher, which kind of renders
the dBm standard useless. This is one reason why most gear is rated in dBu, or in dBV
(another voltage standard).

Impedance matching Z2 = Z1 for telephone (phone) lines
Transformer matched 600 ohm phone transmission line
"""
Z2=Z1 == 50ohm=600ohm
damping DF = Zin / Zout == Z1/Z2
Voltage damping = 	delta_L

"""
Definition of dBm
 
dBm is defined as power ratio in decibel (dB) referenced to one milliwatt (mW). It is an
abbreviation for dB with respect to 1 mW and the "m" in dBm stands for milliwatt.

dBm is different from dB. dBm represents absolute power, whereas in audio engineering the
decibel is usually a voltage ratio of two values and is used then to represent gain or attenuation
of an audio amplifier, or an audio damping pad.
"""
