classdef COMPOSE < ClassifierModel
    %COMPOSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        classifier;
        core_support_extractor;
        
        autoExtract = 1; % extract every time classify is called 0
        classifyCount = 0; % number of times classify has been called since last extraction
        
        X = [];
        y = [];
    end
    
    methods
        function obj = COMPOSE(cse, ssl, opts)
            if ~isa(cse, 'CoreSupportExtractor')
                error('ths:COMPOSE:BadCSE', 'cse must be an implementation of CoreSupportExtractor');
            end
            
            if ~isa(ssl, 'SemiSupervisedClassifier')
                error('ths:COMPOSE:BadSSL', 'ssl must be an implementation of SemiSupervisedClassifier');
            end
            
            obj.classifier = cse;
            obj.ssl = ssl;
            
            if isfield(opts, 'extractEvery'), obj.extractEvery = opts.extractEvery; end
        end
        
        function train(obj, X, y, ~)
            obj.X = [obj.X; X];
            obj.y = [obj.y; y];
        end
        
        function h = classify(obj, X, ~)
            h = obj.classifier.classify(obj.X, obj.y, X);
            obj.classifyCount = obj.classifyCount + 1;
            
            if obj.classifyCount == obj.autoExtract
                obj.y = obj.extract();
            end
        end
        
        function extract(obj)
            obj.classifyCount = 0;
            
            classes = unique(obj.y);
            
            for i = 1:length(classes)
                inds = obj.y == classes(i);
                x = obj.X(inds, :);
                
                cs = obj.core_support_extractor.extract(x);
                
                inds(cs) = [];
                obj.x(inds, :) = [];
                obj.y(inds) = [];
            end
        end
    end
    
end

