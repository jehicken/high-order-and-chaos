function I = NewtonCotes13pt(f, h)
    %% A function for integration with an 13pt Newton-Cotes rule
    % Note: there seem to be some errors with this rule used on the large
    % step size data. It is not being used for now.
    % Inputs:
    %   f is the function points to be integrated. length(f)%12 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 12) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:12:n-1
        I = I + NewtonCotes13ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes13ptInterval(f, h, i)
    %% A function for implementing an 13pt Newton-Cotes Rule.
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 12 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (1/5255250)*h*(1364651*(f(i) + f(i+12)) + 9903168*(f(i+1)+f(i+11)) - 7587864*(f(i+2)+f(i+10)) + 35725120*(f(i+3)+f(i+9)) - 51491295*(f(i+4) + f(i+8)) + 87516288*(f(i+5) + f(i+7)) - 87797136*f(i+6));
    
end