classdef COMPOSE < ClassifierModel
    %COMPOSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        % Dependencies
        classifier;
        core_support_extractor;
        
        % Data
        X = [];
        y = [];
        classifyCount = 0; % number of times classify has been called since last extraction
        
        % Options
        autoExtract = 1; % extract every time classify is called 0
        persistCoreSupports = 0;
    end
    
    methods
        function obj = COMPOSE(cse, ssl, opts)
            if nargin < 3, opts = struct; end
            
            if ~isa(cse, 'CoreSupportExtractor')
                error('ths:COMPOSE:BadCSE', 'cse must be an implementation of CoreSupportExtractor');
            end
            
            if ~isa(ssl, 'SemiSupervisedClassifier')
                error('ths:COMPOSE:BadSSL', 'ssl must be an implementation of SemiSupervisedClassifier');
            end
            
            obj.core_support_extractor = cse;
            obj.classifier = ssl;
            
            if isfield(opts, 'autoExtract'), obj.autoExtract = opts.autoExtract; end
            if isfield(opts, 'persistCoreSupports'), obj.persistCoreSupports = opts.persistCoreSupports; end
        end
        
        function train(obj, X, y, ~)
            obj.X = [obj.X; X];
            obj.y = [obj.y; y];
        end
        
        function h = classify(obj, X, ~)
            h = obj.classifier.classify(obj.X, obj.y, X);
            
            if obj.persistCoreSupports == 0
                obj.X = [];
                obj.y = [];
            end
            
            obj.train(X, h);
            
            obj.classifyCount = obj.classifyCount + 1;
            
            if obj.classifyCount == obj.autoExtract
                obj.extract();
            end
        end
        
        function extract(obj)
            obj.classifyCount = 0;
            
            classes = unique(obj.y);
            
            supports = zeros(size(obj.y));
            
            for i = 1:length(classes)
                inds = find(obj.y == classes(i));
                x = obj.X(inds, :);
                
                cs = obj.core_support_extractor.extract(x);
                
                supports(inds(cs)) = 1;
            end
            
            obj.X = obj.X(supports == 1, :);
            obj.y = obj.y(supports == 1);
        end
    end
    
end

