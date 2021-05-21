"""module for opening and extracting data from Lorenz files"""

import numpy as np 

# benchmark value for avg z from Kehlet and Logg
z_avg_ref = 23.48468206951560755245057102025885979019964736765101924707073717557587258424199920886343339296252912951352491012574579728837492837908146796544143984717970678004311135572490748065191862686863343643256426105086074910125752532750449061231599561663829395691169702709602537689153890023399543833773688068719317285034023205710501713870759360345043011808489315996709079430022133849451570275830309192590323130272650067634773054825306185773

def load_dt_stats(file_name, num_step_sizes, num_times, time_idx):
    """
    Extract data for different dt values for fixed integration period.

    Opens the file `file_name` that contains the raw Lorenz data.  This file
    should correspond to a run with `num_step_sizes` different dt values and
    `num_times` distinct integration periods.  This function extracts all
    the data (`dt` values, `z_avg` data, and `cputime` values) for the time
    integration period corresponding to `time_idx`.
    """
    if num_step_sizes <= 0:
        raise ValueError("num_step_sizes must be positive!")
    if num_times <=0:
        raise ValueError("num_times must be positive!")
    if time_idx < 0 or time_idx >= num_times:
        raise ValueError("time_idx must be >= 0 and < num_times!")
    data = np.loadtxt(file_name)
    offset = num_step_sizes*num_times 
    if data.shape[0] != 3*offset:
        raise ValueError("num_step_sizes and/or num_times inconsistent with "
                         + file_name)
    # the dt values repeat, so just grab the first num_step_sizes values 
    dt = data[0:num_step_sizes,0]
    ptr = offset + time_idx*num_step_sizes
    z_avg = data[ptr:ptr+num_step_sizes,:]
    ptr = 2*offset + time_idx*num_step_sizes
    cputime = data[ptr:ptr+num_step_sizes,:]
    return dt, z_avg.T, cputime.T

def load_time_stats(file_name, num_step_sizes, num_times, dt_idx):
    """
    Extract data for different integration periods for fixed dt value.

    Opens the file `file_name` that contains the raw Lorenz data.  This file
    should correspond to a run with `num_step_sizes` different dt values and
    `num_times` distinct integration periods.  This function extracts all the
    data (`dt` values, `z_avg` data, and `cputime` values) for the dt step size
    corresponding to `dt_idx`.
    """
    if num_step_sizes <= 0:
        raise ValueError("num_step_sizes must be positive!")
    if num_times <=0:
        raise ValueError("num_times must be positive!")
    if dt_idx < 0 or dt_idx >= num_step_sizes:
        raise ValueError("dt_idx must be >= 0 and < num_step_sizes!")
    data = np.loadtxt(file_name)
    offset = num_step_sizes*num_times 
    if data.shape[0] != 3*offset:
        raise ValueError("num_step_sizes and/or num_times inconsistent with "
                         + file_name)
    dt = data[dt_idx, 0]
    ptr = offset
    z_avg = data[ptr+dt_idx:ptr+offset:num_step_sizes,:]
    ptr = 2*offset
    cputime = data[ptr+dt_idx:ptr+offset:num_step_sizes,:]
    return dt, z_avg.T, cputime.T 