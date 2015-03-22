classdef GMMDensitySampler < CoreSupportExtractor
    %GMMDENSITYSAMPLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        k = 1:20;
    end
    
    methods
        function obj = GMMDensitySampler(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'k'), obj.k = opts.k; end
        end
        
        function inds = extract(obj, data)
            bestGMM = [];
            for i = 1:length(obj.k)
                k = obj.k(i);
                
                gmm = fitgmdist(data, k, 'RegularizationValue', .01);
                
                if isempty(bestGMM) || gmm.BIC < bestGMM.BIC
                    bestGMM = gmm;
                end
            end
            
            dists = min(bestGMM.mahal(data), [], 2);
            
            [~, sortInds] = sort(dists);
            
            inds = sortInds(1:round(size(data, 1) * obj.p));
        end
    end
    
end