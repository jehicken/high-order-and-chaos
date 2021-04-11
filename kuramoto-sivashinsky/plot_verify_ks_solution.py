"""Plot the verification benchmark solution at the initial and final times"""

dump=True # set to True to write a png file

import matplotlib
if dump:
    matplotlib.use('Agg')

import matplotlib.pyplot as plt
import numpy as np

# set some formating parameters
axis_fs = 10 # axis title font size
axis_lw = 1.0 # line width used for axis box, legend, and major ticks
label_fs = 8 # axis labels' font size

# set figure size in inches, and crete a single set of axes
fig = plt.figure(figsize=(6,2), facecolor='w', dpi=300)
ax = fig.add_subplot(111)

# get data from file
sol = np.loadtxt("verify_ks_solution.dat")
print("sol.shape = ",sol.shape)
num_nodes = sol.shape[1]
num_steps = sol.shape[0]

# plot the initial condition and final solution
x = np.linspace(0, 128, num_nodes)
ic_h = ax.plot(x, sol[0,:], '-k', lw=1.0, label=r"$u(x,0)=u_0(x)$")
fc_h = ax.plot(x, sol[-1,:], '--r', lw=1.0, label=r"$u(x,\tau)$")

# Tweak the appeareance of the axes
ax.axis([0, 128, -1.5, 4.0])
ax.set_position([0.08, 0.14, 0.91, 0.84]) # position relative to figure edges
ax.set_xlabel("$x$", fontsize=axis_fs, weight='bold', labelpad=0)
ax.xaxis.set_label_coords(0.55, -0.10)
ax.set_ylabel("$u(x,t)$", fontsize=axis_fs, weight='normal', rotation=90)
ax.yaxis.set_label_coords(-0.06, 0.5)

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

ax.legend(loc='upper left', facecolor='w', framealpha=1, edgecolor='k')

if dump:
    fig.savefig('verify_init_final.png', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
else:
    plt.show()