classdef StreamPlotter < handle
    %PLOTTER The plotter interface is used to plot a given data, label, and
    %time value.
    
    properties (SetAccess = protected)
        axh;
        n = 250; % number of most recent points to retain on plot
        colors  = [ 1 0 0;      % Red
                    0 1 0;      % Green
                    0 0 1;      % Blue
                    0 1 1;      % Cyan
                    1 0 1;      % Magenta
                    1 1 0;      % Yellow
                    0 0 0 ];    % Black
    end
    
    methods (Abstract = true)
        % Plots a new point or points
        % X - vector or matrix of points to plot
        % c - scalar or vector of color indices to plot each point in X in
        plot(obj, X, c)
    end
    
end

