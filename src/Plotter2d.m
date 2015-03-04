classdef Plotter2d < StreamPlotter
    %PLOTTER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)

    end
    
    properties (Hidden)
        xlims = [Inf -Inf];
        ylims = [Inf -Inf];
        plotPoints;
        i = 1; % the total number of plotted points so far (used to update plotPoints)
    end
    
    methods
        function obj = Plotter2d(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'axh')
                obj.axh = opts.axh;
            else
                obj.axh = gca;
            end
            
            if isfield(opts, 'n'), obj.n = opts.n; end
            if isfield(opts, 'colors'), obj.colors = opts.colors; end
            
            if obj.n > 0
                obj.plotPoints = zeros(obj.n, 1);
            end
        end
        
        function plot(obj, X, c)
            if nargin < 3, c = 1; end
            
            if size(X, 2) > 2, warning('Warning: x is more than 2 dimensions, this class only plots on a 2D axis'); end
            
            axes(obj.axh);
            hold on;
            
            colors = obj.colors(mod(c - 1, length(obj.colors)) + 1, :);
            
            h = scatter(X(:, 1), X(:, 2), 25, colors, 'filled');
            
            if ~isempty(obj.n)
                ind = mod(obj.i - 1, obj.n) + 1;
                if obj.plotPoints(ind) ~= 0
                    delete(obj.plotPoints(ind));
                end
                
                obj.plotPoints(ind) = h;
            end
            
            hold off;
            
            obj.i = obj.i + 1;
        end
    end
    
end

