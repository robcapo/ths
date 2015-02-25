classdef ClassifierModel < handle
    %CLASSIFIERMODEL This interface specifies a trainable classifier that can predict
    %the label of an observation at a particular point in time
    
    methods (Abstract = true)
        train(obj, X, y, t)
        h = classify(obj, X, t)
    end
    
end

