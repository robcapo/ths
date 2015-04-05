function [ d ] = mcd( X1, y1, X2, y2, c )
%MCD This metric calculates the MCD factor on a dataset
%   The MCD factor is calculated between two time steps, and is used to
%   determine like likelihood that COMPOSE will fail to correctly classify
%   the data in the second time step, given the data in the first.


classes = unique(y1);
if ~isequal(classes, unique(y2)), error('y1 and y2 must have the same classes'); end

% 0-1 loss cost
if nargin < 5, c = xor(ones(length(classes)), eye(length(classes))); end

drifts = pdist2(X2, X1);

d = zeros(size(classes));

for i = 1:length(classes)
    d(i) = mean(mean(drifts(y2 == classes(i), y1 == classes(i)))) / mean(mean(drifts(y2 == classes(i), y1 ~= classes(i))));
end


end

