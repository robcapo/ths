function [ l, u ] = plot_confidence_intervals( performances, c, x )
%PLOT_CONFIDENCE_INTERVALS Summary of this function goes here
%   Detailed explanation goes here
if nargin < 2, c = 'r'; end
if nargin < 3, x = 1:size(performances, 1); end
l = [];
u = [];

for i = 1:size(performances, 1)
    [l(i), u(i)] = confidence_interval(performances(i, :));
end

ciplot(l, u, x, c);

end

