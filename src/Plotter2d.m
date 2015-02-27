classdef Plotter2d < StreamPlotter
    %PLOTTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)

    end
    
    properties (Hidden)
        xlims = [Inf -Inf];
        ylims = [Inf -Inf];
        plotPoints;
    end
    
    methods
        function obj = Plotter2d(ax, opts)
            if nargin < 1, ax = gca; end
            
            
            obj.axh = ax;
            
            if nargin >= 2
                if isfield(opts, 'n'), obj.n = opts.n; end
                if isfield(opts, 'colors'), obj.colors = opts.colors; end
            end
            
            if obj.n > 0
                obj.plotPoints = zeros(obj.n, 1);
            end
        end
        
        function plot(obj, X, y, t)
            if nargin < 4, t = 0; end
            if size(X, 2) > 2, warning('Warning: x is more than 2 dimensions, this class only plots on a 2D axis'); end
            axes(obj.axh);
            hold on;
            
            % Adjust x and y limits if needed
            mins = min(X, [], 1);
            maxs = max(X, [], 1);
            
            changeLims = 0;
            
            if mins(1) < obj.xlims(1)
                obj.xlims(1) = mins(1);
                changeLims = 1;
            end
            
            if maxs(1) > obj.xlims(2)
                obj.xlims(2) = maxs(1);
                changeLims = 1;
            end
            
            if mins(2) < obj.ylims(1)
                obj.ylims(1) = mins(2);
                changeLims = 1;
            end
            
            if maxs(2) > obj.ylims(2)
                obj.ylims(2) = maxs(2);
                changeLims = 1;
            end
            
            if changeLims == 1
                ylim(obj.ylims);
                xlim(obj.xlims);
            end
            
            colors = obj.colors(mod(y, length(obj.colors)) + 1, :);
            
            scatter(X(:, 1), X(:, 2), 25, colors, 'filled');
            
            title(['Time ' num2str(t)]);
            hold off;
            getframe;
        end
    end
    
end

