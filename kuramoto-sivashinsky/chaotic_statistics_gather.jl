# Solve the KS equation over a short period, then check against high-order solution 

include("kuramoto-sivashinsky.jl")
using kuramoto_sivashinsky

# define integrand functions needed for time averages 
function ident(val) 
    return val
end
function square(val)
    return val*val 
end 

# This is not the same as the function in `verify_spatial_accuracy.jl` !!!
# The order below is different
function Print3DArray(file, arr::AbstractArray{Float64,3})
    for k = 1:size(arr,3)   
        for j = 1:size(arr,2)
            for i = 1:size(arr,1)
                print(file, arr[i,j,k], " ")
            end
            println(file)
        end
    end
end

# set some parameters
tp = Float64             # floating point type to use 
Lx = convert(tp, 128)    # domain size 
spin = convert(tp, 1000) # spin-up period 
num_samples = 10         # number of ensemble samples to use

# set the discretization parameters
dt = 0.01
base_time = 40.0
base_steps = convert(Int, base_time/dt)
time_fac = 10
order = [2, 4, 6]
num_nodes = Array{Int}(128:32:256) -1
num_spin = convert(Int, spin/dt)

println("Information")
println("\tdt = ",dt)
println("\tbase_time = ",base_time)
println("\tbase_steps = ",base_steps)
println("\ttime_fac  = ",time_fac)
println()

# loop over the orders of accuracy 
for p = 1:size(order,1)
    println("Gathering statistics for order ",order[p])
    # each order gets its own file 

    dx = zeros(Float64, (num_samples*time_fac^2, size(num_nodes,1), 3) )
    u_avg = zeros(dx)
    u2_avg = zeros(dx)
    cputime = zeros(dx)
    time = base_time*time_fac^2
    num_steps = base_steps*time_fac^2

    for n = 1:size(num_nodes,1)
        println("\tUsing number of nodes = ",num_nodes[n])
        # set initial condition and set-up the KSData structure 
        dx[:,n,:] = Lx/(num_nodes[n]+1)
        ks = kuramoto_sivashinsky.buildKSData(order[p], num_nodes[n], tp)

        for s = 1:num_samples
            println("\tRunning long-time sample ",s)
            # run spin up simulation 
            u = 2*rand(num_nodes[n]) - 1
            sol = kuramoto_sivashinsky.solveUsingMidpoint(ks, spin, num_spin, u)
            u = sol[2:end-1,end]

            # solve for the statistics using longest simulation time 
            print("\t") # this is so the elapsed time is indented 
            tic()
            sol = kuramoto_sivashinsky.
                    solveUsingMidpoint(ks, time, num_steps, u)
            cpu_long = toc()
            if any(isnan, sol)
                error("KS failed to solve due to instability.")
            end

            # We partition the long-time simulation into smaller periods for
            # statistics gathering.  For example, if the long-time is 4000 units
            # then we have 1 sample for 4000, 10 samples for 400 units, and 100
            # samples for 40 units.
            # The statistics for the medium and long periods are duplicated to 
            # simplify the file I/O (NumPy loadtxt is easier), so this needs to 
            # be accounted for by dividing by the same number of total samples,
            # which is num_samples*time_fac^2
            ptr = (s-1)*time_fac^2 + 1
            for s1 = 1:time_fac 
                for s2 = 1:time_fac 
                    # get statistics for the shortest period 
                    ibeg = base_steps*((s1-1)*time_fac + s2 - 1) + 1
                    iend = base_steps*((s1-1)*time_fac + s2) + 1
                    u_avg[ptr,n,1] = kuramoto_sivashinsky.
                        calcSolutionAverage(order[p], sol[:,ibeg:iend], ident)
                    u2_avg[ptr,n,1] = kuramoto_sivashinsky.
                        calcSolutionAverage(order[p], sol[:,ibeg:iend], square)
                    cputime[ptr,n,1] = cpu_long/(time_fac^2)
                    # get statistics for the medium period 
                    ibeg = base_steps*(s1-1)*time_fac + 1
                    iend = base_steps*s1*time_fac + 1
                    u_avg[ptr,n,2] = kuramoto_sivashinsky.
                        calcSolutionAverage(order[p], sol[:,ibeg:iend], ident)
                    u2_avg[ptr,n,2] = kuramoto_sivashinsky.
                        calcSolutionAverage(order[p], sol[:,ibeg:iend], square)
                    cputime[ptr,n,2] = cpu_long/time_fac
                    # get statistics for the longest period 
                    u_avg[ptr,n,3] = kuramoto_sivashinsky.
                        calcSolutionAverage(order[p], sol, ident)
                    u2_avg[ptr,n,3] = kuramoto_sivashinsky.
                        calcSolutionAverage(order[p], sol, square)
                    cputime[ptr,n,3] = cpu_long
                    
                    ptr += 1
                end 
            end
        end
    end

    # write the data
    data = open("raw_statistics_ks_order$(order[p]).dat", "w")
    Print3DArray(data, dx)
    Print3DArray(data, u_avg)
    Print3DArray(data, u2_avg)
    Print3DArray(data, cputime)
    close(data)
end 




