module kuramoto_sivashinsky

"""
    B = bernoulli(n)

Return the `n`th Bernoulli number.
"""
function bernoulli(n)
    B = Array{Rational{BigInt}}(n + 1)
    for m = 0:n
        B[m+1] = 1 // (m+1)
        for j = m:-1:1
            B[j] = j*(B[j] - B[j+1])
        end
    end
    return B[1]
end

"""
    quad = buildQuadrature(order [, T=Float64])

Return a Gregory-type quadrture rule for uniformly spaced data. 
"""
function buildQuadrature(order::Int, T::Type=Float64)
    if order <= 2
        quad = [1//2]
    elseif order <= 4 
        quad = [17//48; 59//48; 43//48; 49//48]
    elseif order <= 6 
        quad = [13649//43200; 12013//8640; 2711//4320; 5359//4320; 7877//8640;
                43801//43200]
    else
        quad = [1498139//5080320; 1107307//725760; 20761//80640;
                1304999//725760; 299527//725760; 103097//80640;
                670091//725760; 5127739//5080320]
    end
    return convert(Array{T,1}, quad)
end

"""
Data structure for finite-difference operators on uniformly spaced points
"""
struct FiniteDiff{T}
    """Defines the nodes in the stencil; node 0 is rel. location of operator"""
    stencil::Array{Int,1}
    """Actual finite-difference coefficients"""
    coeffs::Array{T,1}
end

"""
    fd = buildFiniteDifference(deriv, order [, T=Float64, h=1.0])

Returns a finite difference operator struct for a derivative of order `deriv` 
and order of accuracy of `order`. The optional argument `T` controls the 
precision used, and `h` sets the (uniform) mesh spacing.
"""
function buildFiniteDifference(deriv::Int, order::Int, T::Type=Float64;
                               h=convert(T,1) )
    num_pts = deriv + order - 1
    if iseven(num_pts) num_pts += 1 end 
    stencil = Array{Int}(-div(num_pts-1,2):div(num_pts-1,2))
    V = zeros(T, num_pts, num_pts)
    for i = 1:num_pts
        V[i,:] = stencil.^(i-1)
    end
    b = zeros(T, num_pts)
    b[deriv+1] = factorial(deriv)
    c = V\b
    c /= (h^deriv)
    return FiniteDiff{T}(stencil, c)
end

"""
    interp = buildInterp(order [, T=Float64])

Returns a centered interpolation operator of order `order` that does **not** 
use data at the central node.
"""
function buildInterp(order::Int, T::Type=Float64)
    num_pts = order
    if isodd(num_pts) num_pts += 1 end
    stencil = Array{Int}([-div(num_pts,2):-1;1:div(num_pts,2)])
    V = zeros(T, num_pts, num_pts)
    for i = 1:num_pts
        V[i,:] = stencil.^(i-1)
    end
    b = zeros(T, num_pts)
    b[1] = 1.0
    c = V\b
    return FiniteDiff{T}(stencil, c)
end

"""
    num_ghost, num_bndry, ghost_op = buildGhostOp(order [, T=Float64])

Constructs a matrix operator `ghost_op` that, when applied to `num_bndry` nodes 
at the boundary, produces `order` accurate `num_ghost` values.  **Note**, this 
operator is designed to enforce a zero function value and zero derivative value
at the boundary, as per the Blonigan and Wang paper.

The ghost operator is constructed by solving a linearly constrained minimum 
norm problem for the ghost node values.
"""
function buildGhostOp(order::Int, T::Type=Float64)
    # first, build the constraint Jacobian that enforces u=0 and du/dx = 0
    # A*u_ghost - B*u_true = c 
    fd = buildFiniteDifference(1, order, T)
    #interp = buildInterp(order, T)
    num_nodes = length(fd.stencil)
    num_ghost = div(num_nodes-1,2) + 1 # this includes node at boundary
    num_bndry = num_nodes - num_ghost 
    A = zeros(T, 2, num_ghost)
    A[1,end] = 1.0 # last node is the node on the boundary
    #A[1,1:end-1] = interp.coeffs[1:num_ghost-1]
    A[2,:] = fd.coeffs[1:num_ghost]
    B = zeros(T, 2, num_bndry)
    #B[1,:] = interp.coeffs[num_ghost:end]
    B[2,:] = fd.coeffs[num_ghost+1:end]
    return num_ghost, num_bndry, -A.'*( (A*A.') \ B )
    
    if false
        # This version uses a TVD-type regularization
        # first, build the constraint Jacobian that enforces u=0 and du/dx = 0
        # A*u_ghost = B*u_true + c 
        fd = buildFiniteDifference(1, order, T)
        #interp = buildInterp(order, T)
        num_nodes = length(fd.stencil)
        num_ghost = div(num_nodes-1,2) + 1 # this includes node at boundary
        num_bndry = num_nodes - num_ghost 
        A = zeros(T, 2, num_ghost)
        A[1,end] = 1.0 # last node 
        #A[1,1:end-1] = interp.coeffs[1:num_ghost-1]
        A[2,:] = fd.coeffs[1:num_ghost]
        B = zeros(T, 2, num_bndry)
        #B[1,:] = interp.coeffs[num_ghost:end]
        B[2,:] = fd.coeffs[num_ghost+1:end]

        D = zeros(T, num_ghost, num_ghost)
        D += diagm(2*ones(T,num_ghost))
        D -= diagm(ones(T, num_ghost-1), 1)
        D -= diagm(ones(T, num_ghost-1), -1)
        K = [D A.'; A zeros(T, 2, 2)]
        G = -inv(K)[1:num_ghost,end-1:end]*B 
        return num_ghost, num_bndry, G
    end
end

"""
Data for KS function evaluation to avoid reallocation
"""
struct KSData{T}
    """Number of internal nodes (nodes we are solving for)"""
    num_nodes::Int 
    """Number of ghost nodes at each end; include x=0 and x=L"""
    num_ghost::Int
    """Number of internal nodes used to determine ghost values"""
    num_bndry::Int
    """Stores the boundary first-derivative operator"""
    bndry_op::Array{T,2}
    """Stores the linear operatrors"""
    linear_op::SparseMatrixCSC{T,Int}
    """finite difference operator for the first-derivative"""
    fd::FiniteDiff{T}
end
 
"""
    ks = buildKSDataPeriodic(order, num_nodes [, T=Float64])

Returns a KSData structure that can be used to solve the Kuramoto-Sivashinsky 
equations on _periodic domains_, while avoiding reallocation of arrays.
"""
function buildKSDataPeriodic(order::Int, num_nodes::Int, T::Type=Float64)
    # domain length used in Blonigan and Wang paper, but here periodic 
    Lx = convert(T, 128)
    h = Lx/num_nodes
    # generate the matrix used for the linear operators
    A = zeros(T, num_nodes, num_nodes)
    # second, add the Laplacian contributions
    fd = buildFiniteDifference(2, order, T)
    fac = 1/(h*h)
    for i = 1:num_nodes
        A[i, mod.(fd.stencil + i - 1, num_nodes) + 1] -= fd.coeffs*fac 
    end
    # finally, add the BiLaplacian terms 
    fd = buildFiniteDifference(4, order, T)
    fac *= fac
    for i = 1:num_nodes
        A[i, mod.(fd.stencil + i - 1, num_nodes) + 1] -= fd.coeffs*fac 
    end
    Asparse = sparse(A)
    # finally, get the first-derivative operator for nonlinear terms 
    fd = kuramoto_sivashinsky.buildFiniteDifference(1, order, T, h=h)
    return KSData{T}(num_nodes, 0, 0, zeros(0,0), Asparse, fd)
end

"""
    getKSFuncPeriodic!(ks, t, u, du)

A function that returns the perodic spatial discretization of the
Kuramoto-Sivashinsky PDE for use in a time marching method.
"""
function getKSFuncPeriodic!(ks::KSData{Tks}, t, u::AbstractArray{T,1},
                            du::AbstractArray{T,1}) where {Tks, T}
    # apply the linear operators
    du[:] = ks.linear_op*u
    # add the nonlinear terms; this uses a skew-symmetric split-form
    third = convert(T, 1//3)
    for i = 1:ks.num_nodes
        for k = 1:size(ks.fd.stencil,1)
            j = mod(ks.fd.stencil[k]+i-1, ks.num_nodes) + 1
            du[i] -= third*u[i]*ks.fd.coeffs[k]*u[j]
            du[i] -= third*ks.fd.coeffs[k]*u[j]*u[j]
        end
        # This version uses central differencing for the nonlinear term
        #du[i] -= u[i]*dot(ks.fd.coeffs, 
        #                  u[mod.(ks.fd.stencil+i-1,ks.num_nodes)+1])
    end
    return nothing
end

"""
    getKSJacPeriodic!(ks, t, u, Jac)

A function that returns the Jacobian of the perodic spatial discretization of
the Kuramoto-Sivashinsky PDE for use in a time marching method.
"""
function getKSJacPeriodic!(ks::KSData{T}, t, u::AbstractArray{T,1}, 
                           Jac::SparseMatrixCSC{T,Int}) where {T}
    Jac[:,:] = sparse(ks.linear_op)
    third = convert(T, 1//3)
    for i = 1:ks.num_nodes 
        for k = 1:size(ks.fd.stencil,1)
            j = mod(ks.fd.stencil[k]+i-1, ks.num_nodes) + 1
            #du[i] -= fac*u[i]*ks.fd.coeffs[k]*u[j]
            Jac[i,i] -= third*ks.fd.coeffs[k]*u[j]
            Jac[i,j] -= third*u[i]*ks.fd.coeffs[k] 
            #du[i] -= fac*ks.fd.coeffs[k]*u[j]*u[j]
            Jac[i,j] -= 2*third*ks.fd.coeffs[k]*u[j]
        end
        # This version uses central differencing for the nonlinear term
        #Jac[i,i] -= dot(ks.fd.coeffs, 
        #                u[mod.(ks.fd.stencil+i-1,ks.num_nodes)+1])
        #Jac[i,mod.(ks.fd.stencil+i-1,ks.num_nodes)+1] -= u[i]*ks.fd.coeffs 
    end
end

"""
    ks = buildKSData(order, num_nodes [, T=Float64])

Returns a KSData structure that can be used to solve the Kuramoto-Sivashinsky 
equations while avoiding reallocation of arrays.  This version imposes
homogeneous Dirichlet and Neumann conditions at the ends of the spatial domain.
"""
function buildKSData(order::Int, num_nodes::Int, T::Type=Float64)
    # domain length used in Blonigan and Wang paper
    Lx = convert(T, 128)
    h = Lx/(num_nodes+1)
    # get the ghost node operator, call it Bg
    num_ghost, num_bndry, Bg = buildGhostOp(order, T)
    # println("Bg = ", Bg)

    # generate the matrix used for the linear operators
    A = zeros(T, num_nodes, num_nodes)
    # first, add the Laplacian contributions
    fd = buildFiniteDifference(2, order, T)
    fac = 1/(h*h)
    for i = 1:num_nodes
        idx = [k for k = 1:size(fd.stencil,1) 
               if fd.stencil[k] + i >= 1 && fd.stencil[k] + i <= num_nodes]
        A[i, fd.stencil[idx] + i] -= fd.coeffs[idx]*fac 
    end

    # eliminate ghost node contributions for Laplacian
    Ag = zeros(T, num_bndry, num_ghost)
    for i = 1:num_bndry
        idx = [k for k = 1:size(fd.stencil,1) if fd.stencil[k] + i < 1]
        Ag[i, fd.stencil[idx] + num_ghost + i] -= fd.coeffs[idx]*fac
    end
    # println("Ag (Laplacian) = ", Ag)
    G = Ag*Bg 
    A[1:num_bndry,1:num_bndry] += G 
    A[end:-1:end-num_bndry+1,end:-1:end-num_bndry+1] += G 

    # next, add the BiLaplacian terms 
    fd = buildFiniteDifference(4, order, T)
    fac = 1/(h*h*h*h)
    for i = 1:num_nodes
        idx = [k for k = 1:size(fd.stencil,1) 
               if fd.stencil[k] + i >= 1 && fd.stencil[k] + i <= num_nodes]
        A[i, fd.stencil[idx] + i] -= fd.coeffs[idx]*fac 
    end

    # eliminate ghost node contributions for BiLaplacian
    fill!(Ag, zero(T))
    for i = 1:num_bndry
        idx = [k for k = 1:size(fd.stencil,1) if fd.stencil[k] + i < 1]
        Ag[i, fd.stencil[idx] + num_ghost + i] -= fd.coeffs[idx]*fac
    end
    # println("Ag (BiLaplacian) = ", Ag)
    G = Ag*Bg
    A[1:num_bndry,1:num_bndry] += G 
    A[end:-1:end-num_bndry+1,end:-1:end-num_bndry+1] += G

    # println("A[1,1:5] = ",A[1,1:5])
    # println("A[end,end-4:end] = ",A[end,end-4:end])

    Asparse = sparse(A)

    # finally, get the first-derivative operator for nonlinear terms 
    fd = kuramoto_sivashinsky.buildFiniteDifference(1, order, T, h=h)
    # Get the first-derivative operator at the boundary
    fill!(Ag, zero(T))
    G = zeros(T, num_bndry, div(size(fd.stencil,1)+1,2) + num_bndry - 1 )
    for i = 1:num_bndry
        idx = [k for k = 1:size(fd.stencil,1) if fd.stencil[k] + i < 1]
        Ag[i, fd.stencil[idx] + num_ghost + i] += fd.coeffs[idx]
        idx = [k for k = 1:size(fd.stencil,1) if fd.stencil[k] + i >= 1]
        G[i, fd.stencil[idx] + i] += fd.coeffs[idx]
    end
    # println("Ag (first-derivative) = ", Ag)
    # println("G before = ",G)
    G[:,1:num_bndry] += Ag*Bg 
    # println("G after = ",G)

    return KSData{T}(num_nodes, num_ghost, num_bndry, G, Asparse, fd)
end

"""
    getKSFunc!(ks, t, u, du)

A function that returns the spatial discretization of the
Kuramoto-Sivashinsky PDE for use in a time marching method.  Homogeneous BCs 
for u and dudx are used at both ends of the domain.
"""
function getKSFunc!(ks::KSData{Tks}, t, u::AbstractArray{T,1},
                    du::AbstractArray{T,1}) where {Tks, T}
    # apply the linear operators
    du[:] = ks.linear_op*u
    # add the nonlinear terms to interior nodes 
    fac = convert(T, 1//3)
    for i = ks.num_bndry + 1:ks.num_nodes - ks.num_bndry 
        for k = 1:size(ks.fd.stencil,1)
            j = mod(ks.fd.stencil[k]+i-1, ks.num_nodes) + 1
            du[i] -= fac*u[i]*ks.fd.coeffs[k]*u[j]
            du[i] -= fac*ks.fd.coeffs[k]*u[j]*u[j]
        end
        #du[i] -= u[i]*dot(ks.fd.coeffs, 
        #                  u[mod.(ks.fd.stencil+i-1,ks.num_nodes)+1])
    end
    # add the nonlinear terms to the boundary nodes 
    for i = 1:size(ks.bndry_op,1)
        for k = 1:size(ks.bndry_op,2)
            du[i] -= fac*u[i]*ks.bndry_op[i,k]*u[k]
            du[i] -= fac*ks.bndry_op[i,k]*u[k]*u[k]
            du[end-i+1] += fac*u[end-i+1]*ks.bndry_op[i,k]*u[end-k+1]
            du[end-i+1] += fac*ks.bndry_op[i,k]*u[end-k+1]*u[end-k+1]
        end
    end
    return nothing
end

"""
    getKSJac!(ks, t, u, Jac)

A function that returns the Jacobian of the spatial discretization of
the Kuramoto-Sivashinsky PDE for use in a time marching method. Homogeneous BCs
for u and dudx are used at both ends of the domain.
"""
function getKSJac!(ks::KSData{T}, t, u::AbstractArray{T,1}, 
                   Jac::SparseMatrixCSC{T,Int}) where {T}
    # Jacobian contribution due to linear terms 
    Jac[:,:] = sparse(ks.linear_op)
    #Jac[:,:] = deepcopy(ks.linear_op)
    # Jacobian due to nonlinear terms on interior 
    fac = convert(T, 1//3)
    for i = ks.num_bndry+1:ks.num_nodes - ks.num_bndry 
        for k = 1:size(ks.fd.stencil,1)
            j = mod(ks.fd.stencil[k]+i-1, ks.num_nodes) + 1
            # du[i] -= fac*u[i]*ks.fd.coeffs[k]*u[j]
            Jac[i,i] -= fac*ks.fd.coeffs[k]*u[j]
            Jac[i,j] -= fac*u[i]*ks.fd.coeffs[k] 
            # du[i] -= fac*ks.fd.coeffs[k]*u[j]*u[j]
            Jac[i,j] -= 2*fac*ks.fd.coeffs[k]*u[j]
        end
        # This version uses central differencing for the nonlinear term
        #Jac[i,i] -= dot(ks.fd.coeffs, 
        #                u[mod.(ks.fd.stencil+i-1,ks.num_nodes)+1])
        #Jac[i,mod.(ks.fd.stencil+i-1,ks.num_nodes)+1] -= u[i]*ks.fd.coeffs 
    end
    # Jacobian due to nonlinear terms on boundary 
    for i = 1:size(ks.bndry_op,1)
        for k = 1:size(ks.bndry_op,2)
            # du[i] -= fac*u[i]*ks.bndry_op[i,k]*u[k]
            Jac[i,i] -= fac*ks.bndry_op[i,k]*u[k]
            Jac[i,k] -= fac*u[i]*ks.bndry_op[i,k]
            # du[i] -= fac*ks.bndry_op[i,k]*u[k]*u[k]
            Jac[i,k] -= 2*fac*ks.bndry_op[i,k]*u[k]
            # du[end-i+1] += fac*u[end-i+1]*ks.bndry_op[i,k]*u[end-k+1]
            Jac[end-i+1,end-i+1] += fac*ks.bndry_op[i,k]*u[end-k+1]
            Jac[end-i+1,end-k+1] += fac*u[end-i+1]*ks.bndry_op[i,k]
            # du[end-i+1] += fac*ks.bndry_op[i,k]*u[end-k+1]*u[end-k+1]
            Jac[end-i+1,end-k+1] += 2*fac*ks.bndry_op[i,k]*u[end-k+1]

            # This version uses central differencing for the nonlinear term
            #du[i] -= u[i]*ks.bndry_op[i,k]*u[k]
            #  Jac[i,i] -= ks.bndry_op[i,k]*u[k]
            #  Jac[i,k] -= u[i]*ks.bndry_op[i,k]
            #du[end-i+1] -= u[end-i+1]*ks.bndry_op[i,k]*u[end-k+1]
            #  Jac[end-i+1,end-i+1] += ks.bndry_op[i,k]*u[end-k+1]
            #  Jac[end-i+1,end-k+1] += u[end-i+1]*ks.bndry_op[i,k]
        end
    end
end

"""
    Jac = getJacobian(u, ks)

This function uses the complex-step method to get the Jacobian; used for
verification of getKSJac!.  **Do not use** in simulations, due to cost.
"""
function getJacobian(u::AbstractArray{T,1}, ks::KSData{T}) where{T}
    fd_c = FiniteDiff{Complex128}(ks.fd.stencil, ks.fd.coeffs)
    ks_c = KSData{Complex128}(ks.num_nodes, ks.num_ghost, ks.num_bndry, 
                              ks.bndry_op, ks.linear_op, fd_c)
    Jac = zeros(size(u,1),size(u,1))
    u_c = complex.(u, 0.0)
    du_c = zeros(u_c)
    ceps = 1e-60
    for i = 1:ks.num_nodes
        u_c[i] += complex(0.0, ceps)
        getKSFunc!(ks_c, 0.0, u_c, du_c)
        Jac[:,i] = imag.(du_c)/ceps
        u_c[i] -= complex(0.0, ceps)
    end
    return Jac 
end

"""
    sol = solveUsingMidpoint(ks, Time, num_stpes, u)

Solve the KS problem on the nonperiodic domain using the midpoint rule.  The 
problem is run from t=0 to t=`Time` using `num_steps` steps.  The initial
condition is `u`.  Returns `sol`, the solution over all space and temporal 
nodes; `sol[i,n]` stores the `i`th space node at time step `n`.  Note that 
`sol` stores the boundary nodes, whereas `u` does not.
"""
function solveUsingMidpoint(ks::KSData{T}, Time::T, num_steps::Int,
                            u::Array{T,1}) where {T}
    num_nodes = size(u,1)
    # storage for solution over all time steps
    dt = Time/num_steps
    sol = zeros(num_nodes+2, num_steps+1)
    sol[2:end-1,1] = u
    
    t = convert(T, 0.0)
    Jac = zeros(ks.linear_op)
    A = zeros(ks.linear_op)
    u_mid = zeros(u)
    u_old = zeros(u)
    r = zeros(u)
    newt_tol = 1e-10 # We will need to ensure this is sufficiently small
    max_newt_iter = 50
    for n = 1:num_steps
        #println("Iteration ",n,": time ",t)
        # Newton iterations
        u_old = u
        norm0 = one(T)
        for k = 1:max_newt_iter
            u_mid = 0.5*u + 0.5*u_old
            kuramoto_sivashinsky.getKSFunc!(ks, t, u_mid, r)
            r = u - u_old - dt*r
            #println("\tNewton iter ",k,": res norm = ",norm(r))
            if k == 1 
                norm0 = norm(r)
            else 
                if norm(r) < newt_tol*norm0 
                    break
                end
            end 
            kuramoto_sivashinsky.getKSJac!(ks, t, u_mid, Jac)
            Jac *= 0.5*dt 
            Jac -= speye(T, num_nodes)
            du = Jac\r
            u += du
        end
        t += dt
        sol[2:end-1,n+1] = u
    end 
    return sol
end

"""
    avg = calcSolutionAverage(order, sol, func)

Returns the space and time average of `func(sol[:,:])` using an `order` order
accurate diagonal norm scheme.
"""
function calcSolutionAverage(order::Int, sol::Array{T,2},
                             func::Function) where {T}
    avg = zero(T)
    quad = buildQuadrature(order, T)
    num_bndry = size(quad,1)
    for n = 1:size(sol,2)
        wt = one(T) 
        if n <= num_bndry
            wt *= quad[n]
        elseif n >= size(sol,2) - num_bndry + 1
            wt *= quad[size(sol,2)-n+1]
        end      
        for i = 1:size(sol,1)
            if i <= num_bndry
                avg += func(sol[i,n]*wt*quad[i])
            elseif i >= size(sol,2) - num_bndry + 1
                avg += func(sol[i,n]*wt*quad[size(sol,2)-i+1])
            else 
                avg += func(sol[i,n])*wt
            end
        end 
    end 
    avg /= (size(sol,1)-1)*(size(sol,2)-1)
    return avg 
end


# function factorBandedSparse(A::SparseMatrixCSC{T,Int64}) where {T} 

#     fac = one(T)
#     # loop over the elementary matrix operations 
#     for k = 1:A.m-1
#         # update column k of the lower triangular matrix
#         # This assumes the rows are sorted, which Julia matrices should be 
#         for ptr = A.colptr[k]:A.colptr[k+1]-1
#             if rowval[ptr] > k
#                 continue
#             elseif rowval[ptr] == k
#                 fac = one(T)/A.nzval[ptr]
#             else
#                 A.nzval[ptr] *= fac
#             end
#         end
#         # apply the elementary matrix to the lower block matrix 
#         for j = k+1:A.n 
#             if A.rowval[A.colptr[j]] > k 
#                 break # there are no further nonzeros in row k beyond col j
#             end
#             for ptr = A.colptr[j]:A.colptr[j+1]-1
#                 i = A.rowval[ptr] 
#                 if i <= k continue end             
#                 A.nzval[ptr] -= A[i,k]*A[k,j] # this is not efficient 
#             end
#         end
#     end
# end 

end # module