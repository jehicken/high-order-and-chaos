# Julia code for Paper

(Kevin: We may cite this repo eventually, so let's keep it as neat and tidy as possible)

This repository contains the code necessary to reproduce the results in XXXX.  The directories are as follows:
 
  * `lorenz`: Julia code and plotting scripts for the Lorenz results.
  * `chen`: Julia code and plotting scripts for the Chen system.
  * `kuramoto-sivashinsky`: Julia code and plotting scripts for the KS PDE.

The following sections describe the contents of these directories in more detail.

## `lorenz`

(To be added)

## `chen`

(To be added)

## `kuramoto-sivashinsky`

The KS problem is based off the modified system presented by [Blonigan and Wang](https://doi.org/10.1016/j.chaos.2014.03.005).  This choice was made because they provide time- and ensemble-averaged values for the state and squared state that we can compare against for verification.  The modified problem is **not periodic**, and uses homogenous Dirichlet and Neumann boundary conditions.  However, unlike Blonigan and Wang, we do not introduce an constant advection velocity; that is, the parameter `c` in their paper has a value of zero here.

### KS Julia files

The following Julia files contained in the `kuramoto-sivashinsky` directory:

  * `kuramoto-sivashinsky.jl`: defines the functions and data structures necessary to simulate the KS PDE.
  * `solve_ks.jl`: provides an example of how to set-up and run the KS PDE problem.
  * `verify_spatial_accuracy.jl`: used to verify the spatial accuracy of the discretization, by solving over a short-time horizon and comparing against a solution on fine space and time mesh.
  * `solve_periodic_ks.jl`: an older file that solves the KS PDE on a periodic domain.  Note used in the paper.

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






