classdef COMPOSE < ClassifierModel
    %COMPOSE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        classifier;
        core_support_extractor;
        
        extractEvery = 1; % extract every time classify is called
        classifyCount = 0; % number of times classify has been called since last extraction
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
    end
    
end

