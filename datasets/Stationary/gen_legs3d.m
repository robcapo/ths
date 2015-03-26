% ns:       Number of points per leg (vector or scalar)
% thetas:   Number of legs (scalar) or theta values for each leg (vector)
% rhos:     Radius of each leg (vector or scalar)
% spreads:  Amount of spread for each leg (vector or scalar)
function [x y z] = gen_legs3d(ns, thetas, rhos, spreads)
    if nargin < 4; spreads = .2; end
    if nargin < 3, rhos = 1; end
    if nargin < 2, thetas = 3; end
    if nargin < 1, ns = 1000; end
    
    % Create vector of thetas
    if length(thetas) == 1
        n_legs = thetas;
        thetas = [1:n_legs]' * 2 * pi / n_legs; % Equally spaced around circle
    else
        n_legs = length(thetas);
    end
    
    % Create vector of rhos
    if length(rhos) == 1
        rhos = ones(n_legs, 1) * rhos;
    end
    
    % Create vector of spreads
    if length(spreads) == 1
        spreads = ones(n_legs, 1) * spreads;
    end
    
    % Create vector of ns per leg
    if length(ns) == 1
        ns = ones(n_legs, 1) * ns;
    end
    
    n_points = sum(ns);
    
    % Validate size of each vector
    if length(thetas) == length(rhos) && length(rhos) == length(spreads) && length(ns) == length(rhos)
        
    else
        error('All input arguments must be scalar or vectors of the same length');
    end
    
    % Initialize outputs
    x = zeros(n_points, 1);
    y = zeros(n_points, 1);
    z = zeros(n_points, 1);
    
    % Where to start filling x and y vectors
    start = 1;
    
    for i = 1:n_legs
        % Generate vector of rhos and thetas for points
        rhos_i = rand(ns(i), 1) * rhos(i);
        theta = thetas(i);
        
        % Create a horizontal leg
        [xi yi zi] = sph2cart(0, 0, rhos_i);
        
        % Add y and z white noise
        yi = yi + randn(ns(i), 1) * spreads(i) / 2;
        zi = zi + randn(ns(i), 1) * spreads(i) / 2;
        
        % Rotate entire leg point by point
        for j = 1:size(xi, 1)
            R = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1];
            A = R * [xi(j); yi(j); zi(j)];
            xi(j) = A(1);
            yi(j) = A(2);
            zi(j) = A(3);
        end
        
        x(start:start+ns(i)-1) = xi;
        y(start:start+ns(i)-1) = yi;
        z(start:start+ns(i)-1) = zi;
        
        start = start + ns(i);
    end
    
end