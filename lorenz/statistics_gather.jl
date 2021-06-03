# Solves the Lorenz problem over different periods, and writes time average
module LorenzMod

using DelimitedFiles, DifferentialEquations, GeometricIntegratorsDiffEq

include("gregory.jl")
using .Gregory 

function calcZAverage(sol, ibeg::Int, iend::Int, 
    num_steps::Int, order::Int)::Float64
    @assert( iend - ibeg == num_steps)
    #data = zeros(num_steps+1)
    #for i = 1:num_steps+1
    #    data[i] = u[ibeg+i-1][3]
    #end
    numbnd = order-1
    if 2*numbnd > num_steps 
        numbnd = div(num_steps, 2)
        order = numbnd + 1
        println("WARNING: had to adopt order ", order, " quadrature.")
    end
    val = integrate(sol[3,ibeg:iend], numbnd, order, h = 1/num_steps)
    return val 
end

"""
Print3DArray(file, data)

Print a 3D array to file using column-major ordering.
"""
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

# define the Lorenz problem
function lorenz!(du,u,p,t)
    du[1] = 10.0*(u[2]-u[1])
    du[2] = u[1]*(28.0-u[3]) - u[2]
    du[3] = u[1]*u[2] - (8/3)*u[3]
end

"""
gatherStatsLorenz()

Runs the Lorenz problem with different discretization orders, steps sizes and 
integration periods, and writes results to file.
"""
function gatherStatsLorenz()
    
    u0 = [-5.276131687990789; -8.274832825254473; 16.36301350713599]
    time = 1000.0
    probLorenz = ODEProblem(lorenz!, u0, (0, time))
    
    time_fac = 10
    #num_steps = [6250; 12500; 25000; 50000; 100000]
    base_time = time/time_fac^3
    base_steps = [10; 20; 40; 80; 160]
    order = [2, 4, 8]
    #file_prefix = ["Heun_u_", "RK4_u_", "GLRK(4)_u_"]
    method = [Heun(), RK4(), Vern8() ]
    
    # loop over the different order methods  
    for p = 1:size(order,1)
        println("Gathering statistics for order ",order[p])
        # each method gets its own file
        
        dt = zeros(Float64, (time_fac^3, size(base_steps,1), 3) )
        z_avg = zeros(size(dt))
        cputime = zeros(size(dt))
        
        println("Initial compile...")
        cpu_full = @elapsed sol = solve(probLorenz, method[p],
                                        dt=base_time/base_steps[1],
                                        adaptive=false)

        for n = 1:size(base_steps,1)
            dt[:,n,:] .= base_time/base_steps[n]
            println("\tSolve using num steps = ",time_fac^3*base_steps[n])
            cpu_full = @elapsed sol = solve(probLorenz, method[p],
                                            dt=base_time/base_steps[n],
                                            adaptive=false)
            #if any(isnan, sol)
            if sol.retcode != :Success 
                println("\t\tLorenz failed to solve due to instability.")
                continue
            end
            
            # We partition the simulation into smaller periods for statistics
            # gathering.  For example, if the simulation time is 1000 units
            # then we have 10 samples for 100, 100 samples for 10 units, and
            # 1000 samples for 1 unit.
            # The statistics for the medium and long periods are duplicated to 
            # simplify the file I/O (NumPy loadtxt is easier)
            ptr = 1
            for s1 = 1:time_fac 
                ibeg = base_steps[n]*(s1-1)*time_fac*time_fac + 1
                iend = base_steps[n]*s1*time_fac*time_fac + 1
                z_avg_long = calcZAverage(sol, ibeg, iend,
                                          time_fac^2*base_steps[n],
                order[p])
                for s2 = 1:time_fac
                    ibeg = base_steps[n]*((s1-1)*time_fac + s2 - 1)*time_fac + 1
                    iend = base_steps[n]*((s1-1)*time_fac + s2)*time_fac + 1
                    z_avg_med = calcZAverage(sol, ibeg, iend,
                    time_fac*base_steps[n], order[p])
                    for s3 = 1:time_fac
                        # get statistics for the shortest period
                        ibeg = base_steps[n]*(
                        ( (s1-1)*time_fac + s2-1)*time_fac + s3 - 1) + 1
                        iend = base_steps[n]*(
                        ( (s1-1)*time_fac + s2-1)*time_fac + s3) + 1
                        z_avg[ptr,n,1] = calcZAverage(sol, ibeg, iend,
                        base_steps[n], order[p])
                        cputime[ptr,n,1] = cpu_full/(time_fac^3)
                        
                        # get statistics for the medium period
                        ibeg = base_steps[n]*((s1-1)*time_fac+s2-1)*time_fac + 1
                        iend = base_steps[n]*((s1-1)*time_fac + s2)*time_fac + 1
                        z_avg[ptr,n,2] = z_avg_med
                        cputime[ptr,n,2] = cpu_full/(time_fac^2)
                        
                        # get statistics for the long period
                        z_avg[ptr,n,3] = z_avg_long
                        cputime[ptr,n,3] = cpu_full/time_fac
                        
                        ptr += 1
                    end 
                end
            end
        end
        
        # write the data
        data = open("raw_statistics_lorenz_order$(order[p]).dat", "w")
        Print3DArray(data, dt)
        Print3DArray(data, z_avg)
        Print3DArray(data, cputime)
        close(data)
    end
end
    
end # LorenzMod