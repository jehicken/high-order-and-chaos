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

function Print3DArray(file, arr::AbstractArray{Float64,3})
    for i = 1:size(arr,1)
        for j = 1:size(arr,2)
            for k = 1:size(arr,3)   
                print(file, arr[i,j,k], " ")
            end
            println(file)
        end
    end
end

# set the parameters
tp = Float64            # floating point type to use 
#num_nodes = 255         # number of (interior) nodes to use 
#num_steps = 5000        # number of time steps to use 
Lx = convert(tp, 128)   # domain size 
#order = 2               # order of accuracy 
Time = convert(tp, 5) # time period for simulation 

#-------------------------------------------------------------------------------
# first, obtain the high-order benchmark solution 
num_nodes = 511 #2047
order = 8
num_steps = 20000

# set initial condition and set-up the KSData structure 
dx = Lx/(num_nodes+1)
x = Array{tp}(dx:dx:Lx-dx)
#u = sin.(8*pi*x/128).^2
u = exp.(x/128).*sin.(16*pi*x/128).^2
#u = exp.(-((x-64).^2)./512)
ks = kuramoto_sivashinsky.buildKSData(order, num_nodes, tp)

# solve the problem and get the time averages 
sol = kuramoto_sivashinsky.solveUsingMidpoint(ks, Time, num_steps, u)
u_avg_ref = kuramoto_sivashinsky.calcSolutionAverage(order, sol, ident)
u2_avg_ref = kuramoto_sivashinsky.calcSolutionAverage(order, sol, square)
println("u averaged = ", u_avg_ref)
println("u^2 averaged = ", u2_avg_ref)

# output to file for plotting
file = open("verify_ks_solution.dat", "w")
for n = 1:num_steps+1
    for val in sol[:,n]
        print(file, val, " ")
    end
    println(file)
end
close(file) 

order = [2, 4, 6]  # [2, 4, 8, 16]
num_nodes = Array{Int}(64:16:256) - 1 #    [63, 127, 255, 511]
num_steps = [250, 500, 750]

dx = zeros(Float64, (size(order,1), size(num_nodes,1), size(num_steps,1)))
dt = zeros(dx)
err_avg = zeros(dx)
err_sqavg = zeros(dx)
cputime = zeros(dx)

for k = 1:size(num_steps,1)
    for n = 1:size(num_nodes,1)
        for p = 1:size(order,1)
             # set initial condition and set-up the KSData structure 
            dx[p,n,k] = Lx/(num_nodes[n]+1)
            dt[p,n,k] = Time/num_steps[k]
            x = Array{tp}(dx[p,n,k]:dx[p,n,k]:Lx-dx[p,n,k])
            #u = sin.(8*pi*x/128).^2
            u = exp.(x/128).*sin.(16*pi*x/128).^2
            ks = kuramoto_sivashinsky.buildKSData(order[p], num_nodes[n], tp)
            # solve the problem and get the time averages 
            tic()
            sol = kuramoto_sivashinsky.solveUsingMidpoint(ks, Time,
                                                          num_steps[k], u)
            cputime[p,n,k] = toc()
            u_avg = kuramoto_sivashinsky.calcSolutionAverage(order[p], sol,
                                                             ident)
            u2_avg = kuramoto_sivashinsky.calcSolutionAverage(order[p], sol,
                                                              square)
            err_avg[p,n,k] = abs(u_avg - u_avg_ref)/abs(u_avg_ref)
            err_sqavg[p,n,k] = abs(u2_avg - u2_avg_ref)/abs(u2_avg_ref)
        end
    end 
end 

# write the data
data = open("accuracy_ks.dat", "w")
Print3DArray(data, dx)
Print3DArray(data, dt)
Print3DArray(data, err_avg)
Print3DArray(data, err_sqavg)
Print3DArray(data, cputime)
close(data)


