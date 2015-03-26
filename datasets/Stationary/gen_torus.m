% n:        number of points
% R:        Distance from origin to center of torus tube
% r:        Radius of tube
function [x y z] = gen_torus(n, R, r)
    if nargin < 3, r = .25; end
    if nargin < 2, R = 1; end
    if nargin < 1, n = 1000; end
    
    thetas = rand(n, 1) * 2 * pi;
    Rs = ones(n, 1) * R;
    phis = rand(n, 1) * pi;
    rs = randn(n, 1) * r / 2; % 95%
    
    x = (Rs + rs.*cos(phis)) .* cos(thetas);
    y = (Rs + rs.*cos(phis)) .* sin(thetas);
    z = rs.*sin(phis);
end