using DifferentialEquations, GeometricIntegratorsDiffEq, ParameterizedFunctions, Plots, LinearAlgebra, DelimitedFiles, LaTeXStrings


## 3.1 Determining A Benchmark Value for the Infinite-Time average

include("..\\NewtonCotes\\NewtonCotes11pt.jl")

# Set BigFloat precision. This gives about 425 digits, enough to capture all the precision from Kehlet & Logg
setprecision(1400)

# Extract the z-variable of the reference solution trajectory
# This proved troublesome for accomadating the BigFloat type.
# There may be a cleaner way to do this.
u_ref = readdlm("lorenz\\Kehlet&Logg_solution_u.txt", ' ', String, '\n')
z_ref = Array{BigFloat,1}(undef, size(test)[1])

for i = 1:size(u_ref)[1]
    z_ref[i] = parse(BigFloat, u_ref[i,3])
end

# Integrate and then average over t ∈ [20, 1000]
# Kehlet & Logg's data is provided at time intervals of 0.1
Z_true_Lorenz = NewtonCotes.NewtonCotes11pt(z_ref[201:10001], 0.1)/(1000-20)

## 3.2 Initial Condition Determination

# define the Lorenz system and parameters
lorenz = @ode_def begin
 dx = σ * (y - x)
 dy = x * (ρ - z) - y
 dz = x * y - β*z
end σ ρ β

p = [10.0,28.0,8/3]

# Plots from Fig. 1

probLorenz10a = ODEProblem(lorenz, [1, 0, 0], (0, 10), p)
probLorenz10b = ODEProblem(lorenz, [-1, -1, -1], (0, 10), p)
probLorenz50a = ODEProblem(lorenz, [1, 0, 0], (0, 50), p)
probLorenz50b = ODEProblem(lorenz, [-1, -1, -1], (0, 50), p)

solLorenz10a = solve(probLorenz10a, alg=GIGLRK(4), dt=0.001)
solLorenz10b = solve(probLorenz10b, alg=GIGLRK(4), dt=0.001)
solLorenz50a = solve(probLorenz10a, alg=GIGLRK(4), dt=0.001)
solLorenz50b = solve(probLorenz10b, alg=GIGLRK(4), dt=0.001)

# Figure 1a
plot(solLorenz10a, vars = (1, 2, 3), label=L"u_0 = [1, 0, 0]", linecolor=:blue)
plot!(solLorenz10b, vars = (1, 2, 3), label=L"u_0 = [-1, -1, -1]", linecolor=:orange)

# Figure 1b
plot(solLorenz50a, vars = (1, 2, 3), label=L"u_0 = [1, 0, 0]", linecolor=:blue)
plot!(solLorenz50b, vars = (1, 2, 3), label=L"u_0 = [-1, -1, -1]", linecolor=:orange)

# Figure 2 and new initial condition coordinates
probLorenz22 = ODEProblem(lorenz, [-1, -1, -1], (0, 22), p)
solLorenz22 = solve(probLorenz22, alg=GIGLRK(4), dt=0.001)
plot(solLorenz22, vars = (1, 2, 3), label=L"u_0 = [-1, -1, -1]", linecolor=:orange)

u0Lorenz = solLorenz22.u[end] # = [-5.276131687990789, -8.274832825254473, 16.36301350713599]

## 3.3 Step Size Determination

errors = [0.04 0;
          0.02 0;
          0.01 0;
          0.005 0;
          0.004 0]

probLorenzStep = ODEProblem(lorenz, u0Lorenz, (0, 1), p)

for i=1:size(errors)[1]
    local h = errors[i,1]
    sol1 = solve(probLorenzStep, alg=GIHeun(), dt=h)
    sol2 = solve(probLorenzStep, alg=GIGLRK(4), dt=h)
    errors[i,2] = abs(norm(sol1.u[end] - sol2.u[end])/norm(sol2.u[end]))*100
end

# The errors matrix now shows Table 1

## 3.4 Time-March Testing
# NOTE: At time of initial investigation, the programmer was more experienced with MATLAB
# than Julia. Thus a good portion of the statistical analysis code was written in MATLAB, and
# the workflow for gathering statistics looks like this:
#    1. Run simulations in Julia
#    2. Export simulation results to .txt file
#    3. Import results from .txt file into MATLAB
#    4. Perform statistical analysis within MATLAB
#
# The code may, in the future, be updated to use Julia entirely. However, the code below shows
# steps 1 and 2 of the above workflow; while step 3 is performed by importer.m, and step 4
# is performed by ____.m
#

probLorenz = ODEProblem(lorenz, u0Lorenz, (0, 300), p)

h = [0.32, 0.16, 0.08, 0.04, 0.02, 0.01, 0.005, 0.0025]
for i = h
    # GLRK stable for all step sizes
    solGLRK = solve(probLorenz, alg=GIGLRK(4), dt=i)
    writedlm("Method Solutions\\GLRK(4)_u_"*string(i)*".txt", solGLRK.u)

    # Explicit RK4 stable for h < 0.32
    if i < 0.32
        solRK4 = solve(probLorenz, alg=GIERK4(), dt=i)
        writedlm("Method Solutions\\RK4_u_"*string(i)*".txt", solRK4.u)
    end

    # Heun's method stable for h < 0.08
    if i < 0.08
        solHeun = solve(probLorenz, alg=GIHeun(), dt=i)
        writedlm("Method Solutions\\Heun_u_"*string(i)*".txt", solHeun.u)
    end
end
