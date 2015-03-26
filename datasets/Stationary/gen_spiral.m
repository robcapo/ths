function [x y] = gen_spiral(n, k, r, spread, theta0)
    if nargin < 5, theta0 = 0; end
    if nargin < 4, spread = 0; end
    if nargin < 3, r = 1; end
    if nargin < 2, k = 2; end
    if nargin < 1, n = 500; end
    
    thetas = linspace(theta0, theta0 + k*2*pi, n);
    
    rs = r * thetas ./ (theta0 + k*2*pi);
    
    r_spreads = randn(1, n) * spread / 2;
    
    rs = rs + r_spreads;
    
    [x y] = pol2cart(thetas, rs);
end