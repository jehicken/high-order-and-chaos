function I = NewtonCotes6pt(f, h)
    %% A function for integration with an 6pt Newton-Cotes rule, 6th order
    % Inputs:
    %   f is the function points to be integrated. length(f)%5 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 5) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:5:n-1
        I = I + NewtonCotes6ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes6ptInterval(f, h, i)
    %% A function for implementing a 6pt Newton-Cotes Rule.
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 5 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (5/288)*h*(19*(f(i) + f(i+5)) + 75*(f(i+1)+f(i+4)) + 50*(f(i+2)+f(i+3)));
    
end