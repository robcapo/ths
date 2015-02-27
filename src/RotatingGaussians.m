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
        priors = [];
    end
    
    methods
        function obj = RotatingGaussians(n)
            if nargin < 1, n = 2; end
            obj.y = (1:n)';
            obj.d = 2;

            obj.initialAngles = linspace(2*pi/n, 2*pi, n)';

            obj.covariances = cell(size(obj.y));
            obj.covariances(:) = {[1 0; 0 1]};
            
            obj.rotationRates = ones(size(obj.y));
            obj.tMax = 2*max(obj.rotationRates);

            obj.radius = 5;

            obj.priors = ones(size(obj.y)) / n;
        end

        function [x, y] = sample(obj, t, y)
            if nargin < 3
                inds = round((length(obj.y) - 1)*rand(size(t))+1);
                y = obj.y(inds);
            end
            
            angle = obj.rotateLin(t, obj.initialAngles(inds), obj.rotationRates(inds));
            mu = [obj.radius*cos(angle), obj.radius*sin(angle)];
            
            x = zeros(length(inds), obj.d);
            
            for i = 1:length(inds)
                x(i, :) = mvnrnd(mu(i, :), obj.covariances{inds(i)}, 1);
            end
        end
    end
    
    methods (Static)
        function theta = rotateLin(t, initialAngle, rate)
            theta = initialAngle+t.*rate*2*pi;
        end
    end
    
end

