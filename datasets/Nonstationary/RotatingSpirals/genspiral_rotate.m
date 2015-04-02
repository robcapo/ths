function [x0] = genspiral_rotate(N, t, B, RangeMax, win, Spirals, theta_int, theta_start)
    if nargin < 8, theta_start = 0; end
    if nargin < 7, theta_int = pi/10; end
    if nargin < 6, Spirals = 2; end
    if nargin < 5, win = 8; end
    if nargin < 4, RangeMax = 10; end
    if nargin < 3, B = .1; end
    if nargin < 2, N = 500; end
    if nargin < 1, t = 0; end
    
    theta = theta_int * t + theta_start;
    
    R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
    
    x0 = genspiral(N, RangeMax, Spirals, B);
    
    
    for i = 1:size(x0, 2)
        temp_x = x0{i};
        
        % Rotate all points in current spiral
        for j = 1:size(temp_x, 1)
            m = R * temp_x(j, :)';
            temp_x(j, :) = m';
        end
        
        [r c] = find(abs(temp_x) > win);
            
        temp_x(r, :) = [];
        
        x0{i} = temp_x;
    end
end