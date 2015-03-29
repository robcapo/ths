classdef LabelPropagator < SemiSupervisedClassifier
    %LABELPROPAGATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sigma = 1; % sigma value to use for label propagation
    end
    
    methods
        function obj = LabelPropagator(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'sigma'), obj.sigma = opts.sigma; end
        end
        
        function h = classify(obj, Xl, yl, Xu)
            T = exp(-pdist2(Xu, [Xl; Xu], 'mahalanobis', obj.sigma*eye(size(Xl, 2))));
            T = T ./ repmat(sum(T, 1), size(T, 1), 1);
            
            Tul = T(:, 1:size(Xl, 1));
            Tuu = T(:, size(Xl, 1)+1:end);
            
            Z = pinv((eye(size(Tuu))-Tuu))*Tul*full(ind2vec(yl'))';
            
            h = vec2ind(Z')';
        end
    end
    
end

