classdef KNNDensitySampler < CoreSupportExtractor
    %KNNDENSITYSAMPLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        k = 25;
    end
    
    methods
        function obj = KNNDensitySampler(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'k'), obj.k = opts.k; end
        end
        
        function inds = extract(obj, data)
            % returns NxK matrix of nearest neighbor distances
            [~, D] = knnsearch(data, data, 'K', obj.k);
            
            % average over all neighbors
            D = mean(D, 2);
            
            % return the observations with the lowest overall distance (highest density)
            [~, ind] = sort(D);
            inds = ind(1:min(length(ind), round(obj.p * length(ind))));
        end
    end
    
end