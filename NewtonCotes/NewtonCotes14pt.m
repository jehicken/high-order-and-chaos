function I = NewtonCotes14pt(f, h)
    %% A function for integration with an 14pt Newton-Cotes rule, 14th order
    % Inputs:
    %   f is the function points to be integrated. length(f)%13 = 1 is required
    %   h is the desired step size
    %
    % Outputs:
    %   I is the scalar found by numerically integrating f with step size h
    %
    
    p = inputParser;
    validLength = @(x) mod(length(x), 13) == 1;
    addRequired(p, 'f', validLength)
    parse(p, f)
    
    n = length(f);
    I = 0;
    
    for i = 1:13:n-1
        I = I + NewtonCotes14ptInterval(f, h, i);
    end
    
end

function X = NewtonCotes14ptInterval(f, h, i)
    %% A function for implementing an 14pt Newton-Cotes Rule.
    % The rule is derived from the Lagrange Interpolating Polynomial.
    % Source: Magalhaes & Magalhaes, DOI: https://doi.org/10.3844/jmssp.2010.193.204
    % Inputs:
    %   f is the vector of solution points
    %   h is the step size
    %   i is the lower index of integration. i + 13 will be the upper.
    %
    % Outputs:
    %   X is the result of the integration rule applied to a single
    %   interval of appropriate length
    %
    
    X = (13/402361344000)*h*(8181904909*(f(i) + f(i+13)) + 56280729661*(f(i+1)+f(i+12)) - 31268252574*(f(i+2)+f(i+11)) + 156074417954*(f(i+3)+f(i+10)) - 151659573325*(f(i+4) + f(i+9)) + 206683437987*(f(i+5) + f(i+8)) - 43111992612*(f(i+6) + f(i+7)));
    
end