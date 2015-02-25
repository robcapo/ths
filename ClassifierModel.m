classdef ClassifierModel
    %CLASSIFIERMODEL This interface specifies a trainable classifier that can predict
    %the label of an observation at a particular point in time
    
    methods (Abstract = true)
        train(X, y, t)
        h = classify(X, t)
    end
    
end

