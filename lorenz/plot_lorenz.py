import numpy as np
import scipy.io as spio
import matplotlib.pyplot as plt

T = spio.loadmat('LorenzTimeAvgs.mat', squeeze_me=True)

# Code for plot of h = 0.0025

ax = plt.axes()
ax.set_yscale('log')
ax.set_xscale('log')

data = [abs(T['Z_Heuns1_00025']),abs(T['Z_Heuns10_00025']),abs(T['Z_Heuns50_00025'])]
box1 = plt.boxplot(data, positions=[1,10,50], widths=[0.2, 2.2, 12], patch_artist=True)
plt.setp(box1["boxes"], color=(0.5,0.9,1))
plt.setp(box1["boxes"], facecolor=(1,1,1))
plt.setp(box1["fliers"], markeredgecolor=(0.5,0.9,1))
for item in ['whiskers', 'fliers', 'medians', 'caps']:
    plt.setp(box1[item], color=(0.5,0.9,1))

data = [abs(T['Z_RK4s1_00025']),abs(T['Z_RK4s10_00025']),abs(T['Z_RK4s50_00025'])]
box2 = plt.boxplot(data, positions=[1,10,50], widths=[0.15, 1.8, 9], patch_artist=True)
plt.setp(box2["boxes"], color=(0,0.6,0.8))
plt.setp(box2["boxes"], facecolor=(1,1,1))
plt.setp(box2["fliers"], markeredgecolor=(0,0.6,0.8))
for item in ['whiskers', 'fliers', 'medians', 'caps']:
    plt.setp(box2[item], color=(0,0.6,0.8))

data = [abs(T['Z_GLRK4s1_00025']),abs(T['Z_GLRK4s10_00025']),abs(T['Z_GLRK4s50_00025'])]
box3 = plt.boxplot(data, positions=[1,10,50], widths=[0.1, 1.2, 5.5], patch_artist=True)
plt.setp(box3["boxes"], color=(0,0,0.4))
plt.setp(box3["boxes"], facecolor=(1,1,1))
plt.setp(box3["fliers"], markeredgecolor=(0,0,0.4))
for item in ['whiskers', 'fliers', 'medians', 'caps']:
    plt.setp(box3[item], color=(0,0,0.4))

ax.legend([box1["boxes"][0], box2["boxes"][0], box3["boxes"][0]],["Heun's","RK4","GLRK4"])
plt.grid(True,axis='y')
plt.xlim(0.5,100)
plt.xlabel("Time-Average Period")
plt.ylabel("Percent Error")
plt.title("Time-Average Error, h = 0.0025")

plt.show()

