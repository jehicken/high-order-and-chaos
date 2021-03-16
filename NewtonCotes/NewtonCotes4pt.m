function I = NewtonCotes4pt(f, h)
    %% A function for integration with an 4pt Newton-Cotes rule, 4th order
    % Inputs:
    %   f is the function points to be integrated. length(f)%3 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 3) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:3:n-1
        I = I + NewtonCotes4ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes4ptInterval(f, h, i)
    %% A function for implementing an 4pt Newton-Cotes Rule. (Simpson's rule)
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 3 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (3/8)*h*((f(i) + f(i+3)) + 3*(f(i+1)+f(i+2)));
    
end