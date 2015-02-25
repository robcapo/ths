classdef RotatingGaussians < StreamingData
    %ROTATINGGAUSSIANS Generates streaming data from 2D rotating Gaussian's
    %   This class is initialized with a specified number of classes which
    %   are spread out evenly in a circle. As time goes on, each class
    %   rotates around the circle at a user specified rate.
    %
    %   Author: Rob Capo
    %   Date: July, 2014
    
    properties (SetAccess = protected)
        initialAngles = [];     % holds the initial angles of each class
        rotationFns = {};       % holds a cell array of functions that specify the rate at which each class rotates
        covariances = {};       % holds the covariances of each distribution
        rotationRates = [];     % holds the average rate (RPS) at which each distribution rotates
        radius = 5;             % holds the radius of the circle that the Gaussian's will rotate in
    end
    
    methods
        function [x, y] = sample(obj, t, y)
            if nargin < 3, y = obj.chooseClass(); end
            if nargin < 2
                if isempty(obj.t)
                    t = 0;
                else
                    t = obj.t + obj.dt;
                end
            end
            
            obj.t = t;
            
            angle = obj.rotationFns{y}(obj.initialAngles(y), obj.t, 2*pi*obj.rotationRates(y));
            mu = [obj.radius*cos(angle), obj.radius*sin(angle)];
            x = mvnrnd(mu, obj.covariances{y}, 1);
        end
        
        function obj = RotatingGaussians(n)
            if nargin < 1, n = 2; end
            
            obj.setNumberOfDistributions(n);
        end
        
        function setNumberOfDistributions(obj, n)
            if nargin < 2, n = 2; end
            
            obj.n = n;
            
            obj.initialAngles = cumsum([0; (2*pi/n)*ones(obj.n-1, 1)]);
            obj.classMix = 1/obj.n * ones(obj.n, 1);
            obj.setCovariance();
            obj.setRotationFn();
            obj.setRotationRate();
        end
        
        function setRadius(obj, r)
            obj.radius = r;
        end
        
        function setRotationRate(obj, i, r)
            if nargin < 3, r = 1; end
            if nargin < 2, i = 0; end
            
            if (obj.n > 0)
                if (i == 0)
                    obj.rotationRates = r*ones(obj.n, 1);
                elseif (i <= obj.n)
                    obj.rotationRates(i) = r;
                end
            end
        end
        
        function setRotationFn(obj, i, fn)
            if nargin < 3, fn = @RotatingGaussians.rotateLin; end
            if nargin < 2, i = 0; end
            
            if (obj.n > 0)
                if (size(obj.rotationFns, 1) ~= obj.n)
                    obj.rotationFns = cell(obj.n, 1);
                end
                if (i == 0)
                    [obj.rotationFns{:}] = deal(fn);
                elseif (i <= obj.n)
                    obj.rotationFns{i} = fn;
                end
            end
        end
        
        function setCovariance(obj, i, cov)
            if nargin < 3, cov = diag(ones(2,1)); end
            if nargin < 2, i = 0; end
            
            if (obj.n > 0)
                if (size(obj.covariances, 1) ~= obj.n)
                    obj.covariances = cell(obj.n, 1);
                end
                if (i == 0)
                    [obj.covariances{:}] = deal(cov);
                elseif (i <= obj.n)
                    obj.covariances{i} = cov;
                end
            end
        end
    end
    
    methods (Static)
        function theta = rotateLin(initialAngle, t, rate)
            theta = initialAngle+t*rate;
        end
    end
    
end

