classdef SemiSupervisedClassifier < handle
    methods (Abstract = true)
        h = classify(obj, X, y, data);
    end
end