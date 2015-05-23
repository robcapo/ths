classdef RotatingGaussiansVariableRadius < RotatingGaussians
    %ROTATINGGAUSSIANSVARIABLERADIUS This datastream behaves the same as
    %the RotatingGaussians datastream, but the radius from the origin of
    %each Gaussian varies with time.
    
    properties (SetAccess = protected)
        radiusFunction
        radiusVariance
        radiusFrequency
    end
    
    methods
        function obj = RotatingGaussiansVariableRadius(opts)
            if nargin < 1, opts = struct; end
            
            obj = obj@RotatingGaussians(opts);
            
            defaultOpts.radius = 5;
            defaultOpts.radiusFunction = @obj.sinRadius;
            defaultOpts.radiusVariance = 4.5;
            defaultOpts.radiusFrequency = 2;
            
            opts = struct_merge(defaultOpts, opts);
            
            obj.radius = opts.radius;
            obj.radiusFunction = opts.radiusFunction;
            obj.radiusVariance = opts.radiusVariance;
            obj.radiusFrequency = opts.radiusFrequency;
        end
        
        function mu = mu(obj, t, y)
            angle = obj.rotateLin(t, obj.initialAngles(y), obj.rotationRates(y));
            mu = [obj.radiusFunction(t).*cos(angle), obj.radiusFunction(t).*sin(angle)];
        end
        
        function r = sinRadius(obj, t)
            r = obj.radiusVariance*sin(2*pi*obj.radiusFrequency*t)+obj.radius;
        end
    end
    
end

