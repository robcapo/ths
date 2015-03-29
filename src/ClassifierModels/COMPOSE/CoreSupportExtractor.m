classdef CoreSupportExtractor < handle
    properties
        p = .2; % percentage of observations to retain
    end
    
    methods (Abstract = true)
        inds = extract(obj, data);
    end
end