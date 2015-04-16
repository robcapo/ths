classdef ParzenWindowSampler < CoreSupportExtractor
    %PARZENWINDOWSAMPLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sigma = 3; % size of box
        nMin = 2;  % min observations in window for density to be larger than 0
    end
    
    methods
        function obj = ParzenWindowSampler(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'sigma'), obj.sigma = opts.sigma; end
            if isfield(opts, 'nMin'), obj.nMin = opts.nMin; end
            if isfield(opts, 'p'), obj.p = opts.p; end
        end
        
        function inds = extract(obj, data)
            if size(obj.sigma, 2) == 1
                sig = obj.sigma * ones(1, size(data, 2));
            else
                if size(obj.sigma, 2) ~= size(data, 2)
                    error('ths:BadOption', 'Sigma must be scalar or the same dimensionality as data');
                end
                
                sig = obj.sigma;
            end
            
            d = zeros(size(data, 1), 1);
            
            dists = exp(-pdist2(data, data, 'mahalanobis', diag(sig)));
            
            for i = 1:size(data, 1)
                mu = data(i, :);
                
                minBox = repmat(mu - sig / 2, size(data, 1), 1);
                maxBox = repmat(mu + sig / 2, size(data, 1), 1);
                
                dist = dists(all([data > minBox, data < maxBox], 2), i);
                dist(dist == 0) = []; % remove center point so it doesn't improve average for small number of points
                
                if size(dist, 1) < obj.nMin
                    d(i) = 0;
                    continue;
                end
                
                d(i) = mean(dist);
                
            end
            
            [~, inds] = sort(d, 'descend');
            
            inds = inds(1:round(obj.p*end));
        end
    end
    
end

