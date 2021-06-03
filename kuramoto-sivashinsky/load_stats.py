"""module for opening and extracting data from statistics files"""

import numpy as np 

# benchmark values: each value corresponds to one run of 10,000 time units
u_avg_vals = np.array([0.0036085040322204457, 0.017162563361389372, -0.006088325288715798, -0.010631336720701254, 0.007368644678970582, -0.014816141976358967, 0.0029188453204799813, 0.0059640957789224205, 0.011339885974491, 0.005670395778808522])
u2_avg_vals = np.array([1.6188001393490339, 1.6125466976326321, 1.623312488441052, 1.6224184238235249, 1.626842627264861, 1.6137903994866671, 1.6316554298925166, 1.618702561149633, 1.6278317446004285, 1.6237992034233588])

# ensemble of values above
u_avg_ref = np.mean(u_avg_vals) # 0.0022497130939506302
u2_avg_ref = np.mean(u2_avg_vals) # 1.621969971506371   
print('u_avg_ref = ', u_avg_ref)
print('u2_avg_ref = ', u2_avg_ref)

def load_dx_stats(file_name, num_meshes, num_times, time_idx):
    """
    Extract data for different dx values for fixed integration period.

    Opens the file `file_name` that contains the raw KS data.  This file
    should correspond to a run with `num_meshes` different mesh sizes and
    `num_times` distinct integration periods.  This function extracts all
    the data (`dx` values, `u_avg` data, `u2_avg` data, and `cputime` values)
    for the time integration period corresponding to `time_idx`.
    """
    if num_meshes <= 0:
        raise ValueError("num_meshes must be positive!")
    if num_times <=0:
        raise ValueError("num_times must be positive!")
    if time_idx < 0 or time_idx >= num_times:
        raise ValueError("time_idx must be >= 0 and < num_times!")
    data = np.loadtxt(file_name)
    offset = num_meshes*num_times 
    if data.shape[0] != 4*offset:
        raise ValueError("num_meshes and/or num_times inconsistent with "
                         + file_name)
    # the dx values repeat, so just grab the first num_meshes values 
    dx = data[0:num_meshes,0] 
    ptr = offset + time_idx*num_meshes
    u_avg = data[ptr:ptr+num_meshes,:]
    ptr = 2*offset + time_idx*num_meshes
    u2_avg = data[ptr:ptr+num_meshes,:]
    ptr = 3*offset + time_idx*num_meshes
    cputime = data[ptr:ptr+num_meshes,:]
    return dx, u_avg.T, u2_avg.T, cputime.T  

def load_time_stats(file_name, num_meshes, num_times, dx_idx):
    """
    Extract data for different integration periods for fixed dx value.

    Opens the file `file_name` that contains the raw KS data.  This file
    should correspond to a run with `num_meshes` different mesh sizes and
    `num_times` distinct integration periods.  This function extracts all
    the data (`dx` values, `u_avg` data, `u2_avg` data, and `cputime` values)
    for the mesh size corresponding to `dx_idx`.
    """
    if num_meshes <= 0:
        raise ValueError("num_meshes must be positive!")
    if num_times <=0:
        raise ValueError("num_times must be positive!")
    if dx_idx < 0 or dx_idx >= num_meshes:
        raise ValueError("dx_idx must be >= 0 and < num_meshes!")
    data = np.loadtxt(file_name)
    offset = num_meshes*num_times 
    if data.shape[0] != 4*offset:
        raise ValueError("num_meshes and/or num_times inconsistent with "
                         + file_name)
    dx = data[dx_idx, 0]
    ptr = offset
    u_avg = data[ptr+dx_idx:ptr+offset:num_meshes,:]
    ptr = 2*offset 
    u2_avg = data[ptr+dx_idx:ptr+offset:num_meshes,:]
    ptr = 3*offset 
    cputime = data[ptr+dx_idx:ptr+offset:num_meshes,:]
    return dx, u_avg.T, u2_avg.T, cputime.T 

