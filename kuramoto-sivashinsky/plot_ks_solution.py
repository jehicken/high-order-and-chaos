"""Plot contour plots of the KS solution"""

import matplotlib.pyplot as plt
import numpy as np
from matplotlib import cm

dump = False
import matplotlib
if dump:
    matplotlib.use('Agg')

# set figure size in inches, and crete a single set of axes
fig = plt.figure(figsize=(3,6), facecolor='w', dpi=300)
ax = fig.add_subplot(111) #, projection='polar')

# get data from file
sol = np.loadtxt("ks_solution.dat")
#sol = np.loadtxt("verify_ks_solution.dat")
print("sol.shape = ",sol.shape)
num_nodes = sol.shape[1]
num_steps = sol.shape[0]

# define the time and space ranges
x = np.linspace(0, 128, num_nodes)
t = np.linspace(0, 500, num_steps)
X, T = np.meshgrid(x, t)

ch = ax.contourf(X, T, sol, 20, cmap=plt.cm.gray) #bone)

# Tweak the appeareance of the axes
ax.axis([0, 128, 0, 500])
ax.set_position([0.1, 0.05, 0.8, 0.9]) # position relative to figure edges
ax.grid(False)
ax.axis("off")
ax.get_xaxis().set_visible(False)
ax.get_yaxis().set_visible(False)

if dump:
    fig.savefig('ks.png', facecolor=fig.get_facecolor(), dpi=300, edgecolor='none')
else:
    plt.show()