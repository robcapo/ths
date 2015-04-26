function [x, y, z] = gen_sphere(n, r)
    if nargin < 2, r = 1; end
    if nargin < 1, n = 1000; end
    
    thetas = rand(n, 1) * 2 * pi;
    phis = rand(n, 1) * pi;
    rhos = randn(n, 1) * r / 2;
    
    [x, y, z] = sph2cart(thetas, phis, rhos);
end