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
        covariances = {};       % holds the covariances of each distribution
        rotationRates = [];     % holds the average rate (RPS) at which each distribution rotates
        radius = 5;             % holds the radius of the circle that the Gaussian's will rotate in
    end
    
    methods
        function obj = RotatingGaussians(opts)
            if nargin < 1, opts = struct; end
            
            defaultOpts.n = 2;
            defaultOpts.priors = 1;
            defaultOpts.radius = 5;
            defaultOpts.sig = [1 0; 0 1];
            defaultOpts.rotationRates = 1;
            
            opts = struct_merge(defaultOpts, opts);
            
            obj.y = (1:opts.n)';
            obj.d = 2;

            obj.initialAngles = linspace(2*pi/opts.n, 2*pi, opts.n)';

            obj.covariances = cell(size(obj.y));
            obj.covariances(:) = {opts.sig};
            
            obj.rotationRates = opts.rotationRates .* ones(size(obj.y));
            obj.tMax = 2*max(obj.rotationRates);

            obj.radius = opts.radius;

            obj.priors = opts.priors;
        end

        function [x, y] = sample(obj, t, y)
            if nargin < 3
                y = obj.chooseclass(t);
            end
            
            mu = obj.mu(t, y);
            
            x = zeros(length(y), obj.d);
            
            for i = 1:length(y)
                x(i, :) = mvnrnd(mu(i, :), obj.covariances{y(i)}, 1);
            end
        end
        
        function mu = mu(obj, t, y)
            angle = obj.rotateLin(t, obj.initialAngles(y), obj.rotationRates(y));
            mu = [obj.radius*cos(angle), obj.radius*sin(angle)];
        end
    end
    
    methods (Static)
        function theta = rotateLin(t, initialAngle, rate)
            theta = initialAngle+t.*rate*2*pi;
        end
    end
    
end

