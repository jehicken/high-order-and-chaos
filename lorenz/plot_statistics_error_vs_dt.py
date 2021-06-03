"""
Plot the estimated z_avg error versus the step size for the Lorenz problem
"""

dump=True # set to True to write a png file
legend=False # include the legend on the plot

import matplotlib
from load_lorenz_stats import load_dt_stats, z_avg_ref
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

step_sizes = np.array([0.1, 0.05, 0.025, 0.0125, 0.00625])
num_step_sizes = step_sizes.size # number of dt step sizes considered 
time = np.array([1.0, 10.0, 100.0])
num_times = time.size # number of time periods considered 
time_idx = 0 # time period to load from [0,1,...,num_times-1]

# The following lists define files and characteristics unique to each plot
data_files = ["statistics_lorenz_order2.dat", "statistics_lorenz_order4.dat", 
              "statistics_lorenz_order8.dat"]
colors = ['lightskyblue', 'cornflowerblue', 'navy']
lw = [1.5, 1.5, 1.5]
width_fac = [0.40, 0.2, 0.1]
box_h = []

for i, file in enumerate(data_files):
    dt, z_avg, cputime = load_dt_stats(file, num_step_sizes, num_times, 
                                       time_idx)
    if i == 0:
        # the 2-order method is unstable on the coarsest mesh, so delete
        dt = np.delete(dt, 0)
        z_avg = z_avg[:,1:]
        cputime = cputime[:,1:]
    z_avg_error = np.abs(z_avg - z_avg_ref)*100/z_avg_ref 
    bh = ax.boxplot(z_avg_error, positions=dt, widths=width_fac[i]*dt,
               whis=[0,100], patch_artist=True, zorder=i+10, notch=True,
               medianprops=dict(color=colors[i], linewidth=lw[i]),
               capprops=dict(color=colors[i]),
               whiskerprops=dict(color=colors[i]), 
               boxprops=dict(color=colors[i], facecolor='w', linewidth=lw[i]))
    for j in range(z_avg.shape[1]):
        if i == 0:
            print("order ",2**(i+1),": step ",step_sizes[j+1],": mean error = ",
                  np.mean(z_avg_error[:,j]))
            print("order ",2**(i+1),": step ",step_sizes[j+1],": std. error = ",
                  np.std(z_avg_error[:,j]))
        else: 
            print("order ",2**(i+1),": step ",step_sizes[j],": mean error = ",
                  np.mean(z_avg_error[:,j]))
            print("order ",2**(i+1),": step ",step_sizes[j],": std. error = ",
                  np.std(z_avg_error[:,j]))
    box_h.append(bh)

# format the plot 
ax.set_xscale('log')
ax.set_yscale('log')
ax.axis([4e-3, 1.5e-1, 8e-4, 100])
ax.set_position([0.26, 0.2, 0.735, 0.775]) # position relative to figure edges
ax.yaxis.grid(color='gray', linestyle='--', linewidth=0.5)
#plt.xticks(ticks=[0.5, 1.0], labels=[0.5, 1.0])
plt.xticks(ticks=[0.00625, 0.0125, 0.025, 0.05, 0.1],
           labels=[0.00625, 0.0125, 0.025, 0.05, 0.1], rotation=45)
ax.tick_params(axis='x', pad=0)
#plt.xticks(ticks=[], minor=True)
ax.set_xticks([], minor=True)
ax.set_axisbelow(True) # grid lines are plotted below
ax.set_xlabel("$\Delta t$", fontsize=axis_fs, weight='bold', labelpad=0)
ax.xaxis.set_label_coords(0.55, -0.19)
#ax.set_ylabel("$L^2$ Error", fontsize=axis_fs, weight='normal', rotation=90)
ax.set_ylabel("Percent Error", fontsize=axis_fs, weight='normal', rotation=90)
ax.yaxis.set_label_coords(-0.20, 0.5)

if legend:
    ax.legend([box_h[0]["boxes"][0], box_h[1]["boxes"][0], 
               box_h[2]["boxes"][0]],
               ['2nd order', '4th order', '8th order'], loc='upper left',
               facecolor='w', framealpha=1, edgecolor='k')

if dump:
    fig.savefig('lorenz_error_vs_dt.png', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
else:
    plt.show()