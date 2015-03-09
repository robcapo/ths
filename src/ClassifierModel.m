classdef ClassifierModel < handle
    %CLASSIFIERMODEL This interface specifies a trainable classifier that can predict
    %the label of an observation at a particular point in time
    
    properties (SetAccess = protected)
        opts;
    end
    
    methods (Abstract = true)
        train(obj, X, y, t)
        h = classify(obj, X, t)
    end
    
end

