using DifferentialEquations, GeometricIntegratorsDiffEq, ParameterizedFunctions, Plots, LinearAlgebra, DelimitedFiles, LaTeXStrings


## 3.1 Determining A Benchmark Value for the Infinite-Time average

include("..\\NewtonCotes\\NewtonCotes11pt.jl")

# Define the Chen system and parameters
chen = @ode_def begin
 dx = a * (y - x)
 dy = (c - a) * x - x * z + c * y
 dz = x * y - b * z
end a b c

p = [35.0, 3.0, 28.0]

probChenTrue = ODEProblem(chen, [1, 1, 1], (0, 1000), p)
solChenTrue = solve(probChenTrue, alg=GIGLRK(4), dt=0.0005)

# Must transfer z component of solution to single vector for integration
z = Array{Float64}(undef, length(solChen.u))
for i = 1:length(solChen.u)
    if solChenTrue.t[i] >= 5
        z[i] = solChenTrue.u[i][3]
    end
end

# Integrate and then average over t ∈ [5, 1000]
Z_true_Chen = NewtonCotes.NewtonCotes11pt(z, 0.0005)/(1000-5)

## 3.2 Initial Condition Determination

prob = ODEProblem(chen, [1, 1, 1], (0, 5), p)
sol = solve(prob, alg=GIGLRK(4), dt=0.001)
plot(sol, vars = (1, 2, 3), label=L"u_0 = [1, 1, 1]", linecolor=:blue)

# Observe the long, sweeping curve at the start, which travels up to around z = 60
# with a large initial radius before spiraling inwards and downwards.

# Simulate again with two sets of initial conditions over a long period of time.
prob2 = ODEProblem(chen, [1, 1, 1], (0, 500), p)
sol2 = solve(prob2, alg=GIGLRK(4), dt=0.001)
prob3 = ODEProblem(chen, [-1, 0, 0], (0, 500), p)
sol3 = solve(prob3, alg=GIGLRK(4), dt=0.001)
plot(sol2, vars = (2, 3), label=L"u_0 = [1, 1, 1]", linecolor=:blue)
plot!(sol3, vars = (2, 3), label=L"u_0 = [-1, 0, 0]", linecolor=:orange)

# Examining the above plots demonstrates that, similar to the Lorenz system, there is a
# spin-up period after which no similar behavior is noticed over a very long time.
# In this case the solution trajectory at t = 5 from the 8th order GLRK method with
# timestep h = 0.001 is taken to be outside the spinup period and on the attractor,
# so the coordinates at that point will comprise the new initial conditions.

u0Chen = sol.u[end] # = [10.747927627254173, 12.40061941590775,21.207306876020063]

## 3.3 Step Size Determination

# The same step sizes as determined for the Lorenz system are used.
# No extra computation needed here.
# However note that attempts to simulate with some larger step sizes revealed that
# for the Chen system, GLRK and RK4 are only stable for step sizes up to 0.04,
# and Heun's method is only stable up to 0.02.

## 3.4 Time-March Testing
# NOTE: At time of initial investigation, the programmer was more experienced with MATLAB
# than Julia. Thus a good portion of the statistical analysis code was written in MATLAB, and
# the workflow for gathering statistics looks like this:
#    1. Run simulations in Julia
#    2. Export simulation results to .txt file
#    3. Import results from .txt file into MATLAB
#    4. Perform statistical analysis and plotting within MATLAB
#
# The code may, in the future, be updated to use Julia entirely. However, the code below shows
# steps 1 and 2 of the above workflow; while step 3 is performed by importer.m, and step 4
# is performed by runner.m and stats_plotter.m
#

probChen = ODEProblem(chen, u0Chen, (0, 300), p)

h = [0.04, 0.02, 0.01, 0.005, 0.0025]
for i = h
    # GLRK stable for all step sizes
    solGLRK = solve(probChen, alg=GIGLRK(4), dt=i)
    writedlm("chen\\Simulated Solutions\\GLRK(4)_u_"*string(i)*".txt", solGLRK.u)

    # Explicit RK4 stable for all step sizes
    solRK4 = solve(probChen, alg=GIERK4(), dt=i)
    writedlm("chen\\Simulated Solutions\\RK4_u_"*string(i)*".txt", solRK4.u)

    # Heun's method stable for h < 0.04
    if i < 0.04
        solHeun = solve(probChen, alg=GIHeun(), dt=i)
        writedlm("chen\\Simulated Solutions\\Heun_u_"*string(i)*".txt", solHeun.u)
    end
end
