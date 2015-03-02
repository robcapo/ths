classdef ForgettingKnnClassifier < ClassifierModel
    %FORGETTINGKNNCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        maxInd = 0; % current "end" of dynamic array
        
        X = []; % data
        y = []; % labels
        Y = []; % posteriors
        t = []; % sample times
        
        opts; % user 
        
        d; % dimensions of data
    end
    
    methods
        function obj = ForgettingKnnClassifier(opts)
            if nargin < 1, opts = struct; end
            
            defaultOpts = struct;
            defaultOpts.rowPadding = 500;
            defaultOpts.beta = .1;
            
            defaultOpts.k = 25;
            
            fields = fieldnames(defaultOpts);
            for i = 1:length(fields)
                if ~isfield(opts, fields{i})
                    opts.(fields{i}) = defaultOpts.(fields{i});
                end
            end
            
            obj.opts = opts;
        end
        
        function train(obj, X, y, t)
            if isempty(obj.d), obj.d = size(X, 2); end
            
            if size(X, 1) ~= size(y, 1) || size(X, 1) ~= size(t, 1)
                error('ths:Classifier:BadData', 'X, y, and t must all have the same number of rows');
            end
            
            if size(X, 2) ~= obj.d
                error('ths:Classifier:BadData', ['Dimensionality of X must be ', num2str(obj.d)]);
            end
            
            if size(y, 2) == 1
                Y = full(ind2vec(y'))';
            else
                Y = y;
                [~, y] = max(Y, [], 2);
            end
            
            n = size(X, 1);
            
            % Allocate more rows if our matrix is almost full
            obj.growStorage(n);
            
            % Ensure that posterior matrix matches the current set of known classes
            if size(Y, 2) > size(obj.Y, 2)
                obj.Y = [obj.Y, zeros(size(obj.Y, 1), size(Y, 2) -  size(obj.Y, 2))];
            elseif size(Y, 2) < size(obj.Y, 2)
                Y = [Y, zeros(size(Y, 1), size(obj.Y, 2) - size(Y, 2))];
            end
            
            % Add new data to known data
            ind = obj.maxInd + 1;
            obj.X(ind:ind+n-1, :) = X;
            obj.y(ind:ind+n-1, :) = y;
            obj.Y(ind:ind+n-1, :) = Y;
            obj.t(ind:ind+n-1, :) = t;
            
            obj.maxInd = obj.maxInd + size(X, 1);
        end
        
        function h = classify(obj, X, t)
            if obj.maxInd == 0, error('ths:Classifier:ForgettingKnn:Untrained', 'I have not been trained yet!'); end
            
            H = zeros(size(X, 1), size(obj.Y, 2));
            for i = 1:size(X, 1)
                H(i, :) = obj.learn(X(i, :), t(i));
            end
            
            obj.train(X, H, t);
            h = max(H, [], 2);
        end
        
        function [X, y, Y, t] = getKnownData(obj)
            X = obj.X(1:obj.maxInd, :);
            y = obj.y(1:obj.maxInd, :);
            Y = obj.Y(1:obj.maxInd, :);
            t = obj.t(1:obj.maxInd, :);
        end
        
    end
    
    methods (Hidden)
        function h = learn(obj, x, t)
            [Dk, Yk, tk] = obj.findKnn(x);
            
            dtk = tk - t;
            
            h = sum(exp(-obj.opts.beta * dtk).*Yk);
            h = h / sum(h);
            
            
        end
        
        function [Dk, Yk, tk] = findKnn(obj, x)
            [X, ~, Y, ttr] = obj.getKnownData();
            
            D = pdist2(X, x);
            
            k = min(obj.maxInd, obj.opts.k);
            
            [~, Dind] = sort(D);
            
            Dk = D(Dind(1:k));
            Yk = Y(Dind(1:k), :);
            tk = ttr(Dind(1:k));
            dtk = tk - t;
        end

        function growStorage(obj, n)
            if nargin < 1, n = 0; end
            
            unusedRows = size(obj.X, 1) - obj.maxInd;
            
            if unusedRows <= n
                obj.allocateRows(n + obj.opts.rowPadding)
            end
        end
        
        function allocateRows(obj, rowsNeeded)
            obj.X = [obj.X; zeros(rowsNeeded, obj.d)];
            obj.t = [obj.t; zeros(rowsNeeded, 1)];
            obj.y = [obj.y; zeros(rowsNeeded, 1)];
            obj.Y = [obj.Y; zeros(rowsNeeded, 1)];
        end
    end
    
end
