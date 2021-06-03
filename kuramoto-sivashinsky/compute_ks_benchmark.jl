# This script runs the KS PDE over ensembles to estimate the time-averaged QoI
include("kuramoto-sivashinsky.jl")
using .kuramoto_sivashinsky

# define integrand functions needed for time averages 
function ident(val) 
    return val
end
function square(val)
    return val*val 
end 

# set the parameters
tp = Float64             # floating point type to use 
num_nodes = 1023         # number of (interior) nodes to use 
dt = 0.005
Spin = convert(tp, 1000) # spin-up period 
Time = convert(tp, 1000) # statistics gathering period for simulation 
#num_spin = 200000        # number of steps to use during spin up
#num_steps = 200000       # number of time steps to use during simulation
num_spin = convert(Int, Spin/dt)
num_steps = convert(Int, Time/dt)
Lx = convert(tp, 128)    # domain size 
order = 8                # order of accuracy 
num_samples = 10         # number of ensemble samples to use
num_part = 10            # number of partitions that time is broken into
dx = Lx/(num_nodes+1)
x = Array{tp}(dx:dx:Lx-dx)

# loop over the ensemble ensemble samples
u_avg_vals = zeros(num_samples)
u2_avg_vals = zeros(num_samples)
for n = 1:num_samples 
    # set initial condition and set-up the KSData structure 
    u = 2*rand(num_nodes) .- 1
    ks = kuramoto_sivashinsky.buildKSData(order, num_nodes, tp)

    # spin simulation
    println("Starting spin-up portion of simulation")
    sol = kuramoto_sivashinsky.solveUsingMidpoint(ks, Spin, num_spin, u)

    for p = 1:num_part
        # to avoid running out of memory, we partition the total time 
        u = sol[2:end-1,end]
        #clear!(:sol)
        sol = nothing
        println("Starting statistics gathering simulation #",p)
        cputime = @elapsed begin
            sol = kuramoto_sivashinsky.solveUsingMidpoint(ks, Time, 
                                                          num_steps, u)
        end
        u_avg_vals[n] += kuramoto_sivashinsky.
            calcSolutionAverage(order, sol, ident)
        u2_avg_vals[n] += kuramoto_sivashinsky.
            calcSolutionAverage(order, sol, square)
    end
    u_avg_vals[n] /= num_part
    u2_avg_vals[n] /= num_part

    println("u averaged = ", u_avg_vals[n])
    println("u^2 averaged = ", u2_avg_vals[n])
end

# display ensemble values 
println("ensemble value of average u   = ", sum(u_avg_vals)/num_samples)
println("ensemble value of average u^2 = ", sum(u2_avg_vals)/num_samples)

# write the values to file
file = open("benchmark_ks_data.dat", "w")
for i = 1:num_samples   
    print(file, u_avg_vals[i], " ")
end
println(file)
for i = 1:num_samples 
    print(file, u2_avg_vals[i], " ")
end 
println(file)
close(file)