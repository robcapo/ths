function [ pct ] = percent_equal( a, b )
%PERCENTEQUAL Returns the percentage of equal elements
if size(a) ~= size(b), error('capo:BadInput', 'The inputs must be the same size.'); end

pct = sum(reshape(a == b, [], 1)) / numel(a);

end

