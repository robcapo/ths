function [ X1, y1, X2, y2 ] = ug_hsep_vsep( v, h, d, n )
%MCD_UG_DRIFT Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4, n = 1000; end

X1 = [mvnrnd([0 v], eye(2), n); mvnrnd([h 0], eye(2), n)];
y1 = [ones(n, 1); 2*ones(n, 1)];

X2 = [mvnrnd([d v], eye(2), n); mvnrnd([h - d, 0], eye(2), n)];
y2 = y1;

end

