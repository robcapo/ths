function out = genspiral_timesteps(t, N, B, RangeMax, win, Spirals, theta_int, theta_start)
    if nargin < 8, theta_start = 0; end
    if nargin < 7, theta_int = pi/10; end
    if nargin < 6, Spirals = 5; end
    if nargin < 5, win = 9; end
    if nargin < 4, RangeMax = 10; end
    if nargin < 3, B = .1; end
    if nargin < 2, N = 500; end
    if nargin < 1, t = 50; end
    
    out = cell(t, 3);
    
    for i = 1:t
        x = genspiral_rotate(N, i, B, RangeMax, win, Spirals, theta_int, theta_start);
        x = x';
        [r c] = cellfun(@size, x);
        
        labels = [1:Spirals]';
        
        x = cell2mat(x);
        
        % Replicate labels so they match up with data instances
        h=[];
        h(cumsum(r))=1;
        labels = labels(cumsum(h)-h+1,:);
        
        out{i, 1} = x;
        out{i, 2} = labels;
        out{i, 3} = zeros(size(x, 1), 1);
    end
end