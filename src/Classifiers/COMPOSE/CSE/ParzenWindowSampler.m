classdef ParzenWindowSampler < CoreSupportExtractor
    %PARZENWINDOWSAMPLER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sigma = 3; % size of box
    end
    
    methods
        function obj = ParzenWindowSampler(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'sigma'), obj.sigma = opts.sigma; end
        end
        
        function inds = extract(obj, data)
            if size(obj.sigma, 2) == 1
                sigma = obj.sigma * ones(1, size(data, 2));
            else
                if size(obj.sigma, 2) ~= size(data, 2)
                    error('ths:BadOption', 'Sigma must be scalar or the same dimensionality as data');
                end
                
                sigma = obj.sigma;
            end
            
            d = zeros(size(data, 1), 1);
            
            for i = 1:length(data)
                mu = data(i, :);
                
                minBox = repmat(mu - sigma / 2, size(data, 1), 1);
                maxBox = repmat(mu + sigma / 2, size(data, 1), 1);
                
                X = data( ...
                    all([data > minBox, data < maxBox], 2), ...
                    : ...
                );
                
                if isempty(X)
                    d(i) = 0;
                    continue;
                end
                
                d(i) = mean(exp(-pdist2(X, mu, 'mahalanobis', diag(sigma))));
                
            end
            
            [~, inds] = sort(d, 'descend');
            
            inds = inds(1:min(length(inds), obj.p*length(inds)));
        end
    end
    
end

