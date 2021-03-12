# solve the KS function and store data for plotting 

include("kuramoto-sivashinsky.jl")
using kuramoto_sivashinsky

# set the parameters
tp = Float64            # floating point type to use 
num_nodes = 127         # number of (interior) nodes to use 
num_steps = 5000        # number of time steps to use 
Lx = convert(tp, 128)   # domain size 
order = 16              # order of accuracy 
Time = convert(tp, 500) # time period for simulation 

# set initial condition and set-up the KSData structure 
dx = Lx/num_nodes
x = Array{tp}(0.0:dx:Lx-dx)
u = exp.(-((x-64).^2)./512)
ks = kuramoto_sivashinsky.buildKSDataPeriodic(order, num_nodes, tp)

# storage for solution over all time steps; for plotting 
dt = Time/num_steps  
num_steps = round(Int, Time/dt, RoundUp)
sol = zeros(num_nodes+1, num_steps+1)
sol[1:end-1,1] = u
sol[end,1] = u[1]

# solve using midpoint; don't do this in practice!!!
t = convert(tp, 0.0)
Jac = zeros(ks.linear_op)
A = zeros(ks.linear_op)
u_mid = zeros(u)
u_old = zeros(u)
r = zeros(u)
newt_tol = 1e-10 # We will need to ensure this is sufficiently small
max_newt_iter = 50
for n = 1:num_steps
    println("Iteration ",n,": time ",t)

    # Newton iterations
    u_old = u 
    for k = 1:max_newt_iter 
        u_mid = 0.5*(u + u_old)
        kuramoto_sivashinsky.getKSFuncPeriodic!(ks, t, u_mid, r)
        r = u - u_old - dt*r
        println("\tNewton iter ",k,": res norm = ",norm(r))
        if norm(r) < newt_tol break end
        kuramoto_sivashinsky.getKSJacPeriodic!(ks, t, u_mid, Jac)
        Jac *= 0.5*dt 
        Jac -= speye(num_nodes)
        du = Jac\r 
        u += du
    end

    t += dt
    sol[1:end-1,n+1] = u
    sol[end,n+1] = u[1]
end
    
# functionals; here I use only trapezoidal for the temporal integration
u_avg = zero(tp)
u2_avg = zero(tp)
for n = 1:num_steps+1
    wt = dx*dt 
    if n == 1 || n == num_steps+1 wt *= 0.5 end
    for val in sol[1:end-1,n]
        u_avg += val*wt
        u2_avg += val*val*wt 
    end 
end
u_avg /= (Time*Lx)
u2_avg /= (Time*Lx)
println("u averaged = ", u_avg)
println("u^2 averaged = ", u2_avg)

# output to file for plotting
file = open("ks_solution.dat", "w")
for n = 1:num_steps+1
    for val in sol[:,n]
        print(file, val, " ")
    end
    println(file)
end
close(file) 


