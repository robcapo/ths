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
            data = [Xl; Xu];
            n_instances = size(data, 1);
            n_features = size(data, 2);
            n_labeled = length(yl);
            labels = full(ind2vec(yl'))';
            labels = [labels; zeros(size(Xu, 1), size(labels, 2))];
            
            a = reshape(data,1,n_instances,n_features);
            b = reshape(data,n_instances,1,n_features);
            W = exp(-sum((a(ones(n_instances,1),:,:) - b(:,ones(n_instances,1),:)).^2,3)/(obj.sigma^2));

            % The probabilty to jump from node j to i : T_ij = P(j->i)
            T = W ./ repmat(sum(W), n_instances, 1); %Column Normalize W
            T(isnan(T)) = 0;             % Convert any NaNs to zero elements

            % Normalize the transisiton matrix and truncate small elements (1e-5)
            Tn = pinv(diag(sum(T,2)))*T; % Row Normalize T
            Tn(Tn<1e-5)=0;               % Removing small elements increases speed

            % We refer to differenct segements of the matrices as follows:
            % Tn = [Tll Tlu     Y = [Yl
            %       Tul Tuu]         Yu]
            %
            % Break the normalized transisiton matrix into its components
            Tul = Tn(n_labeled+1:end, 1:n_labeled);     %Grab lower left corner of normalized transition matrix
            Tuu = Tn(n_labeled+1:end, n_labeled+1:end);   %Grab lower right corner of normalized transition matrix

            
            % CONVERGENCE THEOREM METHOD:
            % Refernce paper for entire proof
            % YU_pr = (eye(size(Tuu))-Tuu)\Tul*YL; % prob. of belonging to each class
            Z = pinv((eye(size(Tuu))-Tuu))*Tul*labels(1:n_labeled,:);
            labels(n_labeled+1:end,:) = Z;
            
            [~, h] = max(labels(n_labeled+1:end, :), [], 2);
        end
    end
    
end

