classdef PosteriorClassifierModel < ClassifierModel
    %POSTERIORCLASSIFIERMODEL Summary of this class goes here
    %   Detailed explanation goes here

    methods (Abstract = true)
        H = posterior(X)
        train(X, Y)
    end
    
    methods
        function h = classify(obj, X)
            [~, h] = max(obj.posterior(X));
        end
    end
end

