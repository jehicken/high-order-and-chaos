"""
Plot the estimated error versus cpu time
"""

dump=True # set to True to write a png file

import matplotlib
from load_stats import load_dx_stats, u_avg_ref, u2_avg_ref
if dump:
    matplotlib.use('Agg')

import matplotlib.pyplot as plt
from matplotlib.path import Path
import matplotlib.patches as patches
import numpy as np
import math

# set some formating parameters
axis_fs = 10 # axis title font size
axis_lw = 1.0 # line width used for axis box, legend, and major ticks
label_fs = 8 # axis labels' font size

# set figure size in inches, and crete a single set of axes
fig = plt.figure(figsize=(6,2.5), facecolor='w', dpi=300)
ax = fig.add_subplot(111)

num_meshes = 5 # number of mesh sizes considered 
time = np.array([40.0, 400.0, 4000.0])
num_times = time.size # number of time periods considered 
#time_idx = 1 #num_times - 1 # time period to load from [0,1,...,num_times-1]

# The following lists define files and characteristics unique to each plot
data_files = ["statistics_ks_order2.dat", "statistics_ks_order4.dat", 
              "statistics_ks_order6.dat"]
colors = ['lightskyblue', 'cornflowerblue', 'navy']
style = [':o', '--s', '-d']
lw = [2.0, 1.5, 1.0]
line_h = []
ms = [6, 5, 4]

for i, file in enumerate(data_files):
    for time_idx in range(3):
        dx, u_avg, u2_avg, cputime = load_dx_stats(file, num_meshes, num_times, 
                                                   time_idx)
        u_avg_err = np.median(np.abs(u_avg - u_avg_ref)*100/u_avg_ref, axis=0)
        u2_avg_err = np.median(np.abs(u2_avg - u2_avg_ref)*100/u2_avg_ref,
                               axis=0)
        avg_cpu = np.average(cputime, axis=0)
        lh, = ax.plot(avg_cpu, u2_avg_err, style[i], lw=lw[i], color=colors[i], ms=ms[i])
        if time_idx == 0:
            line_h.append(lh)

# format the plot 
ax.set_xscale('log')
ax.set_yscale('log')
ax.axis([1, 1000, 1e-1, 100])
ax.set_position([0.12, 0.15, 0.86, 0.815]) # position relative to figure edges
ax.yaxis.grid(color='gray', linestyle='--', linewidth=0.5)
ax.set_xticklabels([], minor=True)
ax.set_axisbelow(True) # grid lines are plotted below
ax.set_xlabel("CPU Time ($s$)", fontsize=axis_fs, weight='normal', labelpad=0)
ax.xaxis.set_label_coords(0.5, -0.11)
ax.set_ylabel("Percent Error", fontsize=axis_fs, weight='normal', rotation=90)
ax.yaxis.set_label_coords(-0.1, 0.5)

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

leg = ax.legend([line_h[0], line_h[1], line_h[2]],
                ['2nd order', '4th order', '6th order'], loc='lower left',
                fontsize=label_fs,
                facecolor='w', framealpha=1, edgecolor='k')
leg.set_zorder(101)


# indicate the time-integration period for each data set
ax.annotate("", xy=(1.2, 40), xycoords='data',
            xytext=(6, 40), textcoords='data',
            arrowprops=dict(arrowstyle="|-|",))
ax.text(2.7, 40, r"$\tau=40$", ha="center", va="center", size=label_fs,
    bbox=dict(boxstyle="round,pad=0.3", fc="w", ec="k", lw=1))

ax.annotate("", xy=(12, 40), xycoords='data',
            xytext=(60, 40), textcoords='data',
            arrowprops=dict(arrowstyle="|-|",))
ax.text(27, 40, r"$\tau=400$", ha="center", va="center", size=label_fs,
    bbox=dict(boxstyle="round,pad=0.3", fc="w", ec="k", lw=1))

ax.annotate("", xy=(120, 40), xycoords='data',
            xytext=(600, 40), textcoords='data',
            arrowprops=dict(arrowstyle="|-|",))
ax.text(270, 40, r"$\tau=4000$", ha="center", va="center", size=label_fs,
    bbox=dict(boxstyle="round,pad=0.3", fc="w", ec="k", lw=1))


if dump:
    fig.savefig('ks_error_vs_cpu.png', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
else:
    plt.show()
