"""
Plot the estimated error versus the mesh size
"""

dump=False # set to True to write a png file
legend=False # include the legend on the plot

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
axis_fs = 14 # axis title font size
axis_lw = 1.0 # line width used for axis box, legend, and major ticks
label_fs = 10 # axis labels' font size

# set figure size in inches, and crete a single set of axes
fig = plt.figure(figsize=(3,4), facecolor='w', dpi=300)
ax = fig.add_subplot(111)

num_meshes = 5 # number of mesh sizes considered 
time = np.array([40.0, 400.0, 4000.0])
num_times = time.size # number of time periods considered 
time_idx = 2 #num_times - 1 # time period to load from [0,1,...,num_times-1]

# The following lists define files and characteristics unique to each plot
data_files = ["statistics_ks_order2.dat", "statistics_ks_order4.dat", 
              "statistics_ks_order6.dat"]
colors = ['lightskyblue', 'cornflowerblue', 'navy']
lw = [1.5, 1.5, 1.5]
width_fac = [0.10, 0.05, 0.025]
box_h = []

for i, file in enumerate(data_files):
    dx, u_avg, u2_avg, cputime = load_dx_stats(file, num_meshes, num_times, 
                                               time_idx)
    u_avg_error = np.abs(u_avg - u_avg_ref)*100/u_avg_ref
    u2_avg_error = np.abs(u2_avg - u2_avg_ref)*100/u2_avg_ref
    bh = ax.boxplot(u2_avg_error, positions=dx, widths=width_fac[i]*dx,
               whis=[0,100], patch_artist=True, zorder=i+10, notch=True,
               medianprops=dict(color=colors[i], linewidth=lw[i]),
               capprops=dict(color=colors[i]),
               whiskerprops=dict(color=colors[i]), 
               boxprops=dict(color=colors[i], facecolor='w', linewidth=lw[i]))
    box_h.append(bh)

# format the plot 
ax.set_xscale('log')
ax.set_yscale('log')
ax.axis([0.45, 1.1, 1e-3, 100])
ax.set_position([0.26, 0.12, 0.735, 0.855]) # position relative to figure edges
ax.yaxis.grid(color='gray', linestyle='--', linewidth=0.5)
plt.xticks(ticks=[0.5, 1.0], labels=[0.5, 1.0])
ax.set_xticklabels([], minor=True)
ax.set_axisbelow(True) # grid lines are plotted below
ax.set_xlabel("$\Delta x$", fontsize=axis_fs, weight='bold', labelpad=0)
ax.xaxis.set_label_coords(0.65, -0.08)
#ax.set_ylabel("$L^2$ Error", fontsize=axis_fs, weight='normal', rotation=90)
ax.set_ylabel("Percent Error", fontsize=axis_fs, weight='normal', rotation=90)
ax.yaxis.set_label_coords(-0.20, 0.5)

if legend:
    ax.legend([box_h[0]["boxes"][0], box_h[1]["boxes"][0], 
               box_h[2]["boxes"][0]],
               ['2nd order', '4th order', '6th order'], loc='lower right',
               facecolor='w', framealpha=1, edgecolor='k')

if dump:
    fig.savefig('ks_error_vs_dx.png', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
else:
    plt.show()
