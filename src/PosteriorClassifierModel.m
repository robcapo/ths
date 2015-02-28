classdef PosteriorClassifierModel < ClassifierModel
    %POSTERIORCLASSIFIERMODEL Summary of this class goes here
    %   Detailed explanation goes here

    methods (Abstract = true)
        train(obj, X, Y, t)
        H = posterior(obj, X, t)
    end
    
    methods
        function h = classify(obj, X, t)
            [~, h] = max(obj.posterior(X, t));
        end
    end
end

