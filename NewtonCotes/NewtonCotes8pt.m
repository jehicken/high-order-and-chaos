function I = NewtonCotes8pt(f, h)
    %% A function for integration with an 8pt Newton-Cotes rule, 8th order
    % Inputs:
    %   f is the function points to be integrated. length(f)%7 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 7) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:7:n-1
        I = I + NewtonCotes8ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes8ptInterval(f, h, i)
    %% A function for implementing an 8pt Newton-Cotes Rule.
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 7 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (7/17280)*h*(751*(f(i) + f(i+7)) + 3577*(f(i+1)+f(i+6)) + 1323*(f(i+2)+f(i+5)) + 2989*(f(i+3) + f(i+4)));
    
end