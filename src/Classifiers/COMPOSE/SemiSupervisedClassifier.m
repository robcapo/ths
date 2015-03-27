classdef SemiSupervisedClassifier < handle
    methods (Abstract = true)
        h = classify(obj, Xl, yl, Xu);
    end
end