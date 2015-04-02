function [x y] = parametric(theta)
%%
%
% By - Greg Ditzler
% May 2009
%

x = theta.*cos(theta);
y = theta.*sin(theta);