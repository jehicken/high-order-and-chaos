function I = NewtonCotes11pt(f, h)
    %% A function for integration with an 11pt Newton-Cotes rule, 12th order
    % Inputs:
    %   f is the function points to be integrated. length(f)%10 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 10) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:10:n-1
        I = I + NewtonCotes11ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes11ptInterval(f, h, i)
    %% A function for implementing an 11pt Newton-Cotes Rule.
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 10 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (5/299376)*h*(16067*(f(i) + f(i+10)) + 106300*(f(i+1)+f(i+9)) - 48525*(f(i+2)+f(i+8)) + 272400*(f(i+3)+f(i+7)) - 260550*(f(i+4)+f(i+6)) + 427368*f(i+5));
    
end