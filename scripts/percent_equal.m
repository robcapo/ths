function [ pct ] = percent_equal( a, b )
%PERCENTEQUAL Returns the percentage of equal elements (or the percentage
%of ones if only one argument is pased)
if nargin < 2, b = ones(size(a)); end
if size(a) ~= size(b), error('capo:BadInput', 'The inputs must be the same size.'); end

pct = sum(reshape(a == b, [], 1)) / numel(a);

end

