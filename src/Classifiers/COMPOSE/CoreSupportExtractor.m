classdef CoreSupportExtractor < handle
    methods (Abstract = true)
        inds = extract(obj, data);
    end
end