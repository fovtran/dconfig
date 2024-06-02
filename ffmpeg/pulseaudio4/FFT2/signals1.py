"""
Basics of  Signals
1.1 Signals vs Time-Series
You might often have come across the words time-series and signals describing
datasets and it might not be clear what the exact difference between them is.

In a time-series dataset the to-be-predicted value (y) is a function of time (y = y(t)).
Such a function can describe anything,  from the value of bitcoin or a specific stock over time,
to fish population over time. A signal is a more general version of this where
the dependent variable y does not have to a function of time;
it can be a function of spatial coordinates (y = y(x, y)),
distance from the source ( y = y(r) ), etc etc.
"""
import numpy as np

fn_y = lambda t: np.sqrt(t)
fn_x = lambda t: np.exp(t)
fn_z = lambda t: np.log10(t)
fn_w = lambda t: np.pow(t)

t = np.linspace(0,1,50)

y = fn_y(t)
x = fn_x(t)
z = fn_z(t)
w = fn_z(t)
print(y,x,z,w)

import matplotlib.pyplot as plt
plt.plot(y, '-o', label='sqrt(t)')
plt.plot(x, '-o', label='exp(t)')
plt.plot(z, '-o', label='log10(t)')
plt.plot(w, '-o', label='pow(t)')
#ax.axis('equal')
plt.legend(bbox_to_anchor =(0.75, 1.15), ncol = 2)
plt.show()
