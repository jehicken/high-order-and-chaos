"""
Plot the error versus mesh size for the KS verification problem 
"""

order = [2, 4, 6] #, 8]

dump=False # set to True to write a png file
dt_idx = 2 # 0 = coarsest time step, 2 = finest time step

import matplotlib
if dump:
    matplotlib.use('Agg')

import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches
import numpy as np
import math

# set some formating parameters
axis_fs = 14 # axis title font size
axis_lw = 1.0 # line width used for axis box, legend, and major ticks
label_fs = 10 # axis labels' font size

# create rate triangle for plotting
def plotRate(p, loc, dx, ax):
    vert = [ (loc[0], loc[1]), (loc[0]+dx,loc[1]), \
             (loc[0]+dx, loc[1]*pow((loc[0]+dx)/loc[0],p)),
             (loc[0], loc[1]), ]
    codes = [Path.MOVETO, Path.LINETO, Path.LINETO, Path.CLOSEPOLY, ]
    path = Path(vert, codes)
    patch = patches.PathPatch(path, facecolor='w', lw=1.0, zorder=2)
    ax.add_patch(patch)
    x_text = np.exp(0.5*np.log(loc[0]) + 0.5*np.log(loc[0]+dx))
    y_text = 0.8*loc[1]
    ax.text(x_text, y_text, "{:3.2f}:1".format(p), fontsize=label_fs, weight='normal', \
            ha='center',va='top', bbox=dict(facecolor='w',edgecolor='w',zorder=1, alpha=0.0), \
            zorder=1)

# set figure size in inches, and crete a single set of axes
fig = plt.figure(figsize=(3,4), facecolor='w', dpi=300)
ax = fig.add_subplot(111)

data_file = open('./verify_accuracy_ks.dat', 'r')
#data_file = open('./accuracy_ks.dat', 'r')
data = np.loadtxt(data_file)
offset = 8 # 8 meshes for verify_accuracy_ks.dat
ptr = 0
dx = data[0:offset*3,:]
ptr += offset*3
dt = data[ptr:ptr+offset*3,:]
ptr += offset*3
err_avg = data[ptr:ptr+offset*3,:]
ptr += offset*3
err_sqavg = data[ptr:ptr+offset*3,:]
ptr += offset*3
cputime = data[ptr:ptr+offset*3,:]

print("dx = ",dx)
print("dt = ",dt)

colors = ['lightskyblue', 'cornflowerblue', 'navy']
style = [':o', '--s', '-d']
lw = [2.0, 1.5, 1.0]
ms = [6, 5, 4]
line_h = []

for d in range(len(order)):
    error = err_sqavg[d*offset:(d+1)*offset,dt_idx] # error for smallest time step
    deltax = dx[d*offset:(d+1)*offset,-1]
    rate = np.log(error[-1]/error[-2])/np.log(deltax[-1]/deltax[-2])
    print("maxdeg ",order[d]," rate is ",rate)
    plotRate(p=rate, loc=[deltax[-1], 0.7*error[-1]], dx=0.1, ax=ax)
    h, = ax.plot(deltax[:], error[:], style[d], lw=lw[d], color=colors[d],
                 ms=ms[d])
    line_h.append(h)

# Tweak the appearance of the axes
ax.axis([0.2, 3.0, 1e-6, 1.])  # axes ranges
ax.set_position([0.26, 0.12, 0.735, 0.855]) # position relative to figure edges
#ax.set_position([0.21, 0.12, 0.785, 0.855]) # position relative to figure edges
ax.set_xlabel("$\Delta x$", fontsize=axis_fs, weight='bold', labelpad=0)
ax.xaxis.set_label_coords(0.4, -0.08)
#ax.xaxis.set_label_coords(0.65, -0.09)
#ax.set_ylabel("$L^2$ Error", fontsize=axis_fs, weight='normal', rotation=90)
ax.set_ylabel("Functional Error", fontsize=axis_fs, weight='normal', rotation=90)
ax.yaxis.set_label_coords(-0.23, 0.5)
#ax.yaxis.set_label_coords(-0.18, 0.5)

ax.set_yscale('log')
ax.set_xscale('log') #, subsx=[])
for axis in ['top','bottom','left','right']:
  ax.spines[axis].set_linewidth(axis_lw)

ax.set_xticklabels([], minor=True)
#plt.minorticks_labels_off()

ax.grid(which='major', axis='y', linestyle=':')
ax.set_axisbelow(True) # grid lines are plotted below

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
    tick.set_pad(8.)
    #tick.label1 = tick._get_text1()
for tick in ax.get_yaxis().get_major_ticks():
    tick.set_pad(8.)
    #tick.label1 = tick._get_text1()

# We change the fontsize of minor ticks label
ax.tick_params(axis='both', which='major', labelsize=label_fs)
ax.tick_params(axis='both', which='minor', labelsize=label_fs)
#ax.axhline(linewidth=axis_lw)
#ax.axvline(linewidth=axis_lw)

leglabels = []
for d in order:
    if d == 2:
        leglabels.append(str(d)+"nd order")
    else:
        leglabels.append(str(d)+"th order")
leg = ax.legend(line_h, leglabels,
                loc="lower right", numpoints=1, borderpad=0.5, \
                handlelength=1)
rect = leg.get_frame()
rect.set_linewidth(axis_lw)
for t in leg.get_texts():
    t.set_fontsize(label_fs)

if dump:
    #fig.savefig('accuracy.eps', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
    fig.savefig('ks_verification.png', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
else:
    plt.show()
