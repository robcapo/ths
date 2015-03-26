function [x, y] = gen_circle(n, r, mode)
    if nargin < 3, mode = 'normal'; end
    if nargin < 2, r = 1; end
    if nargin < 1, n = 1000; end
    
    if strcmp(mode, 'normal')
        thetas = rand(n, 1) * pi;
        rhos = randn(n, 1) * r / 2;
    else
        thetas = rand(n, 1) * 2 * pi;
        rhos = rand(n, 1) * r;
    end
    
    [x, y] = pol2cart(thetas, rhos);
end