classdef StreamingData < handle
%STREAMINGDATA This interface is used to generate data at a given point in
%time optionally specifying the class.
%   Extend this class to generate specific types of streaming data
%
%   Author: Rob Capo
%   Date: July, 2014

properties (SetAccess = protected)
    tMax;   % This is the maximum value of t that can be specified by `sample`
    y;      % This is a Cx1 vector of possible class labels
    d;      % A scalar specifying the number of dimensions
    priors = [];
end

methods (Abstract = true)
    % y must be optional as an input and should be generated randomly by
    % default
    [x, y] = sample(obj, t, y)
end

methods
    function y = chooseclass(obj, t)
        if isempty(obj.priors) || isscalar(obj.priors)
            obj.priors = ones(size(obj.y));
        end
        
        y = randsample(obj.y, size(t, 1), true, obj.priors);
    end
end

end

