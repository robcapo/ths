classdef Plotter < handle
    %PLOTTER The plotter interface is used to plot a given data, label, and
    %time value.
    
    methods (Abstract = true)
        plot(obj, X, y, t)
    end
    
end

