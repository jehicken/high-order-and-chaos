"""Plot contour plots of the KS solution"""

import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm

dump = True
import matplotlib
if dump:
    matplotlib.use('Agg')

# set some formating parameters
axis_fs = 10 # axis title font size
axis_lw = 1.0 # line width used for axis box, legend, and major ticks
label_fs = 8 # axis labels' font size

# set figure size in inches, and crete a single set of axes
fig = plt.figure(figsize=(6,3), facecolor='w', dpi=300)
ax = fig.add_subplot(111) #, projection='polar')

# get data from file
sol = np.loadtxt("ks_solution.dat")
#sol = np.loadtxt("ks_benchmark_sample_sol.dat")
#sol = np.loadtxt("verify_ks_solution.dat")
print("sol.shape = ",sol.shape)
num_nodes = sol.shape[1]
num_steps = sol.shape[0]

# define the time and space ranges
x = np.linspace(0, 128, num_nodes)
t = np.linspace(0, 400, num_steps)
X, T = np.meshgrid(x, t)

ch = ax.contourf(T, X, sol, 20, cmap=plt.cm.inferno) #bone)

# Tweak the appeareance of the axes
ax.axis([0, 400, 0, 128])
ax.set_position([0.12, 0.21, 0.86, 0.78]) # position relative to figure edges
ax.set_xlabel("$t$", fontsize=axis_fs, weight='bold', labelpad=0)
ax.xaxis.set_label_coords(0.5, -0.15)
ax.set_ylabel("$x$", fontsize=axis_fs, weight='normal', rotation=0)
ax.yaxis.set_label_coords(-0.12, 0.5)

# ticks on bottom and left only
ax.xaxis.tick_bottom() # use ticks on bottom only
ax.yaxis.tick_left()
for line in ax.xaxis.get_ticklines():
    line.set_markersize(-6) # length of the tick
    line.set_markeredgewidth(axis_lw) # thickness of the tick
for line in ax.yaxis.get_ticklines():
    line.set_markersize(-6) # length of the tick
    line.set_markeredgewidth(axis_lw) # thickness of the tick
for label in ax.xaxis.get_ticklabels():
    label.set_fontsize(label_fs)
for label in ax.yaxis.get_ticklabels():
    label.set_fontsize(label_fs)
for tick in ax.get_xaxis().get_major_ticks():
    tick.set_pad(4.)
for tick in ax.get_yaxis().get_major_ticks():
    tick.set_pad(4.)

# We change the fontsize of minor ticks label
ax.tick_params(axis='both', which='major', labelsize=label_fs)
ax.tick_params(axis='both', which='minor', labelsize=label_fs)

if dump:
    fig.savefig('ks_sample_sol.png', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
else:
    plt.show()