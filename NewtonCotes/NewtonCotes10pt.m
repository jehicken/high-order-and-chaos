function I = NewtonCotes10pt(f, h)
    %% A function for integration with an 10pt Newton-Cotes rule, 10th order
    % Inputs:
    %   f is the function points to be integrated. length(f)%9 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 9) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:9:n-1
        I = I + NewtonCotes10ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes10ptInterval(f, h, i)
    %% A function for implementing an 10pt Newton-Cotes Rule.
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 9 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (9/89600)*h*(2857*(f(i) + f(i+9)) + 15741*(f(i+1)+f(i+8)) + 1080*(f(i+2)+f(i+7)) + 19344*(f(i+3)+f(i+6)) + 5778*(f(i+4) + f(i+5)));
    
end