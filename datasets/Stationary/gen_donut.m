% n:        number of points
% r:        radius of donut
% spread:   maxiumum deviation percentage (i.e. 0-1) from radius.
function [x, y] = gen_donut(n, r, spread, mode)
    if nargin < 4, mode = 'normal'; end
    if nargin < 3, spread = .5; end
    if nargin < 2, r = 1; end
    if nargin < 1, n = 1000; end
    
    thetas = rand(n, 1) * 2 * pi;
    radiuses = ones(n, 1) * r;
    
    if strcmp(mode, 'normal')
        % 95% of data will fall within desired range. scale by 1/3 instead
        % of 1/2 to get 99.7% of data within desired range.
        r_offsets = randn(n, 1)*spread*r/2;    
    else
        r_offsets = (rand(n, 1) * 2 - 1)*spread*r;
    end
    
    
    radiuses = radiuses + r_offsets;
    
    [x, y] = pol2cart(thetas, radiuses);
end