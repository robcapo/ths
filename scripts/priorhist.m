function priorhist( y, nbins )
%PRIORHIST Summary of this function goes here
%   Detailed explanation goes here

if nargin < 2, nbins = 100; end

c = unique(y);

bars = zeros(nbins, length(c));

for i = 1:length(c)
    inds = find(y == c(i));
    bars(:, i) = hist(inds, nbins)';
end

x = linspace(1, length(y), nbins);

b = bar(x, bars, 'stacked');
colors = 'rgbcmyk';
for i = 1:length(b)
    b(i).FaceColor = colors(i);
    b(i).EdgeColor = colors(i);
end
xlim([-1 length(y) + 1]);