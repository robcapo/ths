classdef RotatingGaussians < StreamingData
    %ROTATINGGAUSSIANS Generates streaming data from 2D rotating Gaussian's
    %   This class is initialized with a specified number of classes which
    %   are spread out evenly in a circle. As time goes on, each class
    %   rotates around the circle at a user specified rate.
    %
    %   Author: Rob Capo
    %   Date: July, 2014
    
    properties (SetAccess = protected)
        d = 2;                  % 2d dataset
        initialAngles = [];     % holds the initial angles of each class
        rotationFns = {};       % holds a cell array of functions that specify the rate at which each class rotates
        covariances = {};       % holds the covariances of each distribution
        rotationRates = [];     % holds the average rate (RPS) at which each distribution rotates
        radius = 5;             % holds the radius of the circle that the Gaussian's will rotate in
        priors = [];
    end
    
    methods
        function obj = RotatingGaussians(n)
            if nargin < 1, n = 2; end
            obj.y = (1:n)';

            obj.initialAngles = linspace(2*pi/n, 2*pi, n);

            obj.covariances = cell(size(y));
            obj.covariances(:) = {[1 0; 0 1]};
            
            obj.rotationRates = ones(size(obj.y));
            obj.tMax = 2*max(obj.rotationRates);

            obj.radius = 5;

            obj.priors = ones(size(obj.y)) / n;
            
            obj.setNumberOfDistributions(n);
        end

        function [x, y] = sample(obj, t, y)
            if nargin < 3, y = obj.chooseClass(); end
            if nargin < 2, t = 0; end
            
            angle = obj.rotateLin(obj.initialAngles(y), rotationRates(y), t);
            mu = [obj.radius*cos(angle), obj.radius*sin(angle)];
            x = mvnrnd(mu, obj.covariances{y}, 1);
        end
    end
    
    methods (Static)
        function theta = rotateLin(initialAngle, t, rate)
            theta = initialAngle+t*rate;
        end
    end
    
end

