classdef ForgettingKnnClassifier < ClassifierModel
    %FORGETTINGKNNCLASSIFIER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        maxInd = 0; % current "end" of dynamic array
        priors = [];
        
        d; % dimensions of data
        
        trainThreshold = .8;
        
        beta = 1;
        k = 25;
        rowPadding = 500;
    end
    
    properties (Hidden, SetAccess = protected)
        X = []; % data
        y = []; % labels
        Y = []; % posteriors
        t = []; % sample times
        
        lastKnnX = [];
        lastKnnY = [];
        lastKnnT = [];
        lastKnnD = [];
        lastX = [];
        lastY = [];
        lastSampleUsedForTraining = 0;
    end
    
    % Instantiation
    methods
        % Constructor
        %
        % opts struct
        % .rowPadding: scalar # rows to grow matrix at once
        % .beta: scalar forgetting rate 
        % .k: number of neighbors to use
        function obj = ForgettingKnnClassifier(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'beta'          ), obj.beta = opts.beta; end
            if isfield(opts, 'k'             ), obj.k = opts.k; end
            if isfield(opts, 'rowPadding'    ), obj.rowPadding = opts.rowPadding; end
            if isfield(opts, 'trainThreshold'), obj.trainThreshold = opts.trainThreshold; end
        end
    end
        
    % ClassifierModel API
    methods 
        % Train classifier with n observations
        %
        % X: nxd matrix of observations
        % y: nx1 or nxc binary matrix of class labels
        % t: nx1 times sampled
        function train(obj, X, y, t)
            [y, Y] = obj.processYData(y);
            
            trainInds = max(Y, [], 2) > obj.trainThreshold;
            
            if sum(trainInds) >= 1
                obj.lastSampleUsedForTraining = 1;
                obj.addData(X(trainInds, :), y(trainInds), Y(trainInds, :), t(trainInds));
            else
                obj.lastSampleUsedForTraining = 0;
            end
        end
        
        
        % Classify m observations
        %
        % X: mxd matrix of observations
        % t: mx1 vector of times sampled
        function h = classify(obj, X, t)
            if obj.maxInd == 0, error('ths:Classifier:ForgettingKnn:Untrained', 'I have not been trained yet!'); end
            
            H = zeros(size(X, 1), size(obj.Y, 2));
            for i = 1:size(X, 1)
                H(i, :) = obj.classifyInstance(X(i, :), t(i));
            end
            
            obj.train(X, H, t);
            [~, h] = max(H, [], 2);
        end
    end
    
    % Public API for ForgettingKnnClassifier
    methods
        % Gets current data (ignoring empty allocated rows)
        function [X, y, Y, t] = getData(obj, minInd, maxInd)
            if nargin < 3, maxInd = obj.maxInd; end
            if nargin < 2, minInd = 1; end
            
            X = obj.X(minInd:maxInd, :);
            y = obj.y(minInd:maxInd, :);
            Y = obj.Y(minInd:maxInd, :);
            t = obj.t(minInd:maxInd, :);
        end
    end
        
    
    methods (Hidden, Access = protected)
        function [y, Y] = processYData(~, y)
            if size(y, 2) == 1
                Y = full(ind2vec(y'))';
            else
                Y = y;
                [~, y] = max(Y, [], 2);
            end
        end
        
        function addData(obj, X, y, Y, t)
            if isempty(obj.d), obj.d = size(X, 2); end
            
            if size(X, 1) ~= size(y, 1) || size(X, 1) ~= size(t, 1) || size(X, 1) ~= size(Y, 1)
                error('ths:Classifier:BadData', 'X, y, and t must all have the same number of rows');
            end
            
            if size(X, 2) ~= obj.d
                error('ths:Classifier:BadData', ['Dimensionality of X must be ', num2str(obj.d)]);
            end
            
            % Ensure that posterior matrix matches the current set of known classes
            if size(Y, 2) > size(obj.Y, 2)
                obj.Y = [obj.Y, zeros(size(obj.Y, 1), size(Y, 2) -  size(obj.Y, 2))];
                obj.priors = [obj.priors, zeros(1, size(Y, 2) - size(obj.priors, 2))];
            elseif size(Y, 2) < size(obj.Y, 2)
                Y = [Y, zeros(size(Y, 1), size(obj.Y, 2) - size(Y, 2))];
            end
            
            obj.priors = obj.priors + sum(Y, 1);
            
            n = size(X, 1);
            
            % Allocate more rows if our matrix is almost full
            obj.growStorage(n);
            
            % Append data to dynamic matrix
            ind = obj.maxInd + 1;
            obj.X(ind:ind+n-1, :) = X;
            obj.y(ind:ind+n-1, :) = y;
            obj.Y(ind:ind+n-1, :) = Y;
            obj.t(ind:ind+n-1, :) = t;
            
            obj.maxInd = obj.maxInd + size(X, 1);
        end
        
        % Classify a single observation
        %
        % h: 1xc posterior vector
        %
        % x: 1xd observation vector
        % t: 1x1 time drawn
        function h = classifyInstance(obj, x, t)
            [dk, Xk, Yk, tk] = obj.findKnnWithForgetting(x, t);
            
            h = sum(repmat(exp(-dk), 1, size(Yk, 2)) .* Yk, 1);
            h = h / sum(h);
            
            
            obj.lastKnnX = Xk;
            obj.lastKnnY = Yk;
            obj.lastKnnT = tk;
            obj.lastKnnD = dk;
            obj.lastX = x;
            obj.lastY = h;
        end
        
        % Find k nearest neighbors
        %
        % dk: 1xk distance vector to neighbors
        % Yk: cxk posterior matrix of neighbors
        % dtk: 1xk difference 
        function [dk, Xk, Yk, tk] = findKnn(obj, x)
            [Xtr, ~, Ytr, ttr] = obj.getData();
            
            d = pdist2(Xtr, x);
            
            k = min(obj.maxInd, obj.k);
            
            [~, dind] = sort(d);
            
            dk = d(dind(1:k));
            Xk = Xtr(dind(1:k), :);
            Yk = Ytr(dind(1:k), :);
            tk = ttr(dind(1:k));
        end
        
        % Find k nearest neighbors
        %
        % dk: 1xk distance vector to neighbors
        % Yk: cxk posterior matrix of neighbors
        % dtk: 1xk difference 
        function [dk, Xk, Yk, tk] = findKnnWithForgetting(obj, x, t)
            [Xtr, y, Ytr, ttr] = obj.getData();
            
            classPriors = obj.priors / sum(obj.priors, 2);
            
            dt = exp(abs(t - ttr)*obj.beta);
            
            % Find order of nearest neighbors
            d = pdist2([Xtr, dt], [x, zeros(size(x, 1), 1)]);
            [~, dind] = sort(d);
            
            % Return k closest
            k = min(obj.maxInd, obj.k);
            dk = d(dind(1:k));
            Xk = Xtr(dind(1:k), :);
            Yk = Ytr(dind(1:k), :);
            tk = ttr(dind(1:k));
        end
    
        % Pad matrix in batches
        %
        % n: The number of slots that need to be filled now (will pad by opts.rowPadding)
        function growStorage(obj, n)
            if nargin < 1, n = 0; end
            
            unusedRows = size(obj.X, 1) - obj.maxInd;
            
            if unusedRows <= n
                obj.allocateRows(n + obj.rowPadding)
            end
        end
        
        % Allocate rows in all the necessary spots
        function allocateRows(obj, rowsNeeded)
            obj.X = [obj.X; zeros(rowsNeeded, obj.d)];
            obj.t = [obj.t; zeros(rowsNeeded, 1)];
            obj.y = [obj.y; zeros(rowsNeeded, 1)];
            obj.Y = [obj.Y; zeros(rowsNeeded, size(obj.Y, 2))];
        end
    end
    
end

