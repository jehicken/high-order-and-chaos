function I = NewtonCotes12pt(f, h)
    %% A function for integration with an 12pt Newton-Cotes rule, 12th order
    % Inputs:
    %   f is the function points to be integrated. length(f)%11 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 11) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:11:n-1
        I = I + NewtonCotes12ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes12ptInterval(f, h, i)
    %% A function for implementing an 12pt Newton-Cotes Rule.
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 11 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (11/87091200)*h*(2171465*(f(i) + f(i+11)) + 13486539*(f(i+1)+f(i+10)) - 3237113*(f(i+2)+f(i+9)) + 25226685*(f(i+3)+f(i+8)) - 9595542*(f(i+4) + f(i+7)) + 15493566 *(f(i+5) + f(i+6)));
    
end