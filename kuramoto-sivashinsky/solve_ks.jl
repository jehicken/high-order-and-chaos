# solve the KS function and store data for plotting 
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
num_nodes = 255 #127 #511          # number of (interior) nodes to use 
#num_spin = 5000          # number of steps to use during spin up
#num_steps = 20000        # number of time steps to use during simulation
Lx = convert(tp, 128)    # domain size 
order = 6                # order of accuracy 
Spin = convert(tp, 100) #convert(tp, 1000) # spin-up period 
Time = convert(tp, 400) #convert(tp, 2000) # statistics gathering period for simulation 
dt = 0.01
num_spin = convert(Int, Spin/dt)
num_steps = convert(Int, Time/dt)

# set initial condition and set-up the KSData structure 
dx = Lx/(num_nodes+1)
x = Array{tp}(dx:dx:Lx-dx)
#u = exp.(-((x-64).^2)./512)
u = 2*rand(num_nodes) .- 1
ks = kuramoto_sivashinsky.buildKSData(order, num_nodes, tp)

# solve the problem and get the time averages
println("Starting spin-up portion of simulation")
sol = kuramoto_sivashinsky.solveUsingMidpoint(ks, Spin, num_spin, u)
u = sol[2:end-1,end]
println("Starting statistics gathering simulation")
@elapsed sol = kuramoto_sivashinsky.solveUsingMidpoint(ks, Time, num_steps, u)
u_avg_ref = kuramoto_sivashinsky.calcSolutionAverage(order, sol, ident)
u2_avg_ref = kuramoto_sivashinsky.calcSolutionAverage(order, sol, square)
println("u averaged = ", u_avg_ref)
println("u^2 averaged = ", u2_avg_ref)

# output to file for visualization
file = open("ks_solution.dat", "w")
for n = 1:num_steps+1
    for val in sol[:,n]
        print(file, val, " ")
    end
    println(file)
end
close(file) 

