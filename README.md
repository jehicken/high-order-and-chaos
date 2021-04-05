# Julia code for Paper

(Kevin: We may cite this repo eventually, so let's keep it as neat and tidy as possible)

This repository contains the code necessary to reproduce the results in XXXX.  The directories are as follows:
 
  * `lorenz`: Julia code and plotting scripts for the Lorenz results.
  * `chen`: Julia code and plotting scripts for the Chen system.
  * `kuramoto-sivashinsky`: Julia code and plotting scripts for the KS PDE.
  * `NewtonCotes`: A variety of Newton-Cotes rules for numerical integration
  * `utils`: MATLAB helper functions for importing data, calculating time averages, and gathering statistics

The following sections describe the contents of these directories in more detail.

## `lorenz`

The Lorenz'63 system is originally presented by [Lorenz](https://doi.org/10.1175/1520-0469(1963)020<0130:DNF>2.0.CO;2) and in this study we use the classic parameter choices leading to the chaotic solutions on the Lorenz attractor: rho = 28, sigma = 10, beta = 8/3. 

### lorenz Julia files

The following Julia files are contained in the `lorenz` directory:

  * `lorenz.jl`: includes all code needed to simulate the Lorenz system and recreate results from the paper. It includes the time-average calculation on the reference dataset from [Kehlet and Logg](arXiv:1306.2782), plots used for spin-up period/initial condition determination, code for step size error determination, as well as code for time-marching all solutions at a range of step sizes and exporting the results.

### lorenz MATLAB data analysis and plotting scripts

  * `runner.m`: helper script which imports all data produced by `lorenz.jl`, performs time-averaging on that data using the functions in `utils` and `NewtonCotes`, and gathers all time-average statistics for each combination of solver method, step size, and integration period.
  * `stats_plotter_lorenz.m`: contains all code needed to produce plots of time-average error statistics when step size is held constant and integration period is varied, as well as when integration period is held constant and step size is varied.

## `chen`

The Chen system is first presented by [Chen and Ueta](https://doi.org/10.1142/S0218127499001024), and variations to the system as well as its relation to the Lorenz system are later discussed by [Lu, Chen, and Cheng](https://doi.org/10.1142/S021812740401014X). In this case the system's original form from the first reference is used with the following parameters which create a chaotic attractor: a = 35, b = 3, c = 28.

### chen Julia files

The following Julia files are contained in the `chen` directory:

  * `chen.jl`: includes all code needed to simulate the Chen system and recreate results from the paper. It includes the long-time simulation and time-averaging to calculate a reference time average, plots used for spin-up period/initial condition determination, as well as code for time-marching all solutions at a range of step sizes and exporting the results.

### chen MATLAB data analysis and plotting scripts

  * `runner.m`: helper script which imports all data produced by `chen.jl`, performs time-averaging on that data using the functions in `utils` and `NewtonCotes`, and gathers all time-average statistics for each combination of solver method, step size, and integration period.
  * `stats_plotter_chen.m`: contains all code needed to produce plots of time-average error statistics when step size is held constant and integration period is varied, as well as when integration period is held constant and step size is varied.

## `kuramoto-sivashinsky`

The KS problem is based off the modified system presented by [Blonigan and Wang](https://doi.org/10.1016/j.chaos.2014.03.005).  This choice was made because they provide time- and ensemble-averaged values for the state and squared state that we can compare against for verification.  The modified problem is **not periodic**, and uses homogenous Dirichlet and Neumann boundary conditions.  However, unlike Blonigan and Wang, we do not introduce an constant advection velocity; that is, the parameter `c` in their paper has a value of zero here.

### KS Julia files

The following Julia files are contained in the `kuramoto-sivashinsky` directory:

  * `kuramoto-sivashinsky.jl`: defines the functions and data structures necessary to simulate the KS PDE.
  * `solve_ks.jl`: provides an example of how to set-up and run the KS PDE problem.
  * `verify_spatial_accuracy.jl`: used to verify the spatial accuracy of the discretization, by solving over a short-time horizon and comparing against a solution on fine space and time mesh.
  * `solve_periodic_ks.jl`: an older file that solves the KS PDE on a periodic domain.  Not used in the paper.
  * `compute_ks_benchmark.jl`: script used to get the benchmark value for the QoI using a high-order method, on a fine mesh and with a long integration period.
  * `chaotic_statistics_gather.jl`: the **main** script used to gather results for the KS problem that are plotted in the paper.

The best place to start is `solve_ks.jl`, which illustrates the basic usage of the code in `kuramoto-sivashinsky.jl`.

**Important:** When running the Julia scripts to gather CPU time data, bounds checking should be turned off in Julia.  For example, invoke Julia as follows:

```
julia --check-bounds=no
```

### KS Python plotting scripts

The following plotting scripts are available:

  * `plot_ks_solution.py`: plots the space-time solution using the data file produced at the end of `solve_ks.jl`, for example.  Note this file has some hard-coded values for the file name and may need to be adapted to your situation.
  * `plot_ks_error_verification.py`: used to plot the error versus mesh spacing results from `verify_spatial_accuracy.jl`.  Again, beware of hard-coded file names and values that may need to be changed.
  * `plot_ks_cputime_verification.py`: similar to the above plot script, but plots error versus cpu time in seconds.
  * `plot_statistics_error_vs_dx.py`: creates box plots showing the percent error in the QoI as a function of mesh spacing `dx`.  Use the `time_idx` variable to select the integration period to plot.  Specifically, `time_idx=0` is for `tau=40`, `time_idx=1` is for `tau=400` and `time_idx=2` is for `tau=4000`.
  * `plot_statistics_error_vs_time.py`: similar to the previous script, but plots the percent error box plots versus the integration period.  Use the `dx_idx` variable to select from the five different mesh sizes.
  * `plot_statistics_error_vs_cputime.py`: plots the median percent error from each discretization, mesh, and time-integration period versus CPU time in seconds.

Note that `load_stats.py` is a utility module used by some of the scripts to load data from the text files into NumPy arrays.

## `NewtonCotes`

This directory contains a variety of Newton-Cotes integration rules from [Magalhaes and Magalhaes](https://doi.org/10.3844/jmssp.2010.193.204) with a range of points required and accuracy. Rules capable of integrating different size intervals are necessary due to the range of step sizes examined in this work. For example, time-averaging over a period of 1 requires 101 data points if a step size of 0.01 is used. However with a much larger step size of h = 0.32, time-averaging over a comparable period of 0.96 requires only 4 data points. Since more data is available in the first case, we use a higher-order integration rule. In general we prefer higher-order rules when possible and only resort to lower-order rules when necessary, as in the previous example.

Most of the rules are implemented in MATLAB as that is where the majority of the time-averaging is performed, but the 11pt rule was also implemented in Julia for convenience when finding the long-time average of the Chen system.

## `utils`

This directory contains MATLAB helper scripts used for calculating time-averages and gathering statistics about those time-averages. 

  * `solution_importer.m`: helper function for importing the z-component of solution data files into 1D vectors. See usage within `lorenz\runner.m` and `chen\runner.m`.
  * `method_comparisons_[...].m`: performs time-averaging on data with the corresponding step size for all solution methods, and calculates the error between the computed time-average and true time-average. Additionally provides capability to plot the percent error of each individual time average for each method/step size/integration period combination between (0, 300), although these plots were not used in the final paper. Note that there are two separate files for h = 0.04 because some methods which are stable on the Lorenz system at this step size are not stable on the Chen system.
  *  `stats_matrix_[...].m`: Gathers error statistics about the time-averages computed in the `method_comparisons_[...].m` files and assembles the results into two matrices which contain the same data but are ordered differently for convenience when plotting. Separate matrices used for Chen and Lorenz systems due to differing method stability conditions.



