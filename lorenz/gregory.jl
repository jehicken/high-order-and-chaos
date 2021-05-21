"Computes Gregory-type quadrature rules."
module Gregory

export integrate 

"""
    B = calcBernoulli(n)

Return the `n`th Bernoulli number.  Follows the convention that `n=1` 
Bernoulli number is equal to -1/2.
"""
function calcBernoulli(n)
    A = Vector{Rational{BigInt}}(undef, n + 1)
    for m = 0:n
        A[m + 1] = 1 // (m + 1)
        for j = m:-1:1
            A[j] = j * (A[j] - A[j + 1])
        end
    end
    if n == 1
        return -A[1]
    else
        return A[1]
    end
end

"""
    w = calcBoundaryWeights(numbnd, order)

Compute the boundary weights for a Gregory rule of order `order` that using 
`numbnd` boundary points.
"""
function calcBoundaryWeights(numbnd::Int, order::Int)
    @assert( numbnd >= order-1,
             "number of boundary nodes must be larger than order-1")
    # Form the linear system to solve
    A = zeros(Rational{BigInt}, order-1, numbnd)
    b = zeros(Rational{BigInt}, order-1)
    for j = 1:order-1
        for i = 1:numbnd 
            A[j,i] = j*(numbnd - (i-1))^(j-1)
        end
        b[j] = numbnd^j - ((-1)^j)*calcBernoulli(j)
    end
    w = A\b 
    return w
end

"""
    val = integrate(data, numbnd, order[, h=1.0])

Integrate uniformly spaced `data` using a Gregory quadrature rule of order 
`order` with `numbnd` boundary points.  The mesh spacing is defined by `h`.
"""
function integrate(data::Array{T,1}, numbnd::Int, order::Int;
                   h::T=one(T)) where {T<:Number}
    @assert( size(data,1) >= 2*numbnd,
             "number of data points must be larger than 2*numbnd")
    w = calcBoundaryWeights(numbnd, order)
    integral = zero(T)
    for i = 1:numbnd 
        integral += w[i]*(data[i] + data[end-i+1])
    end
    for i = numbnd+1:size(data,1)-numbnd
        integral += data[i]
    end 
    return integral*h
end

end # module Gregory