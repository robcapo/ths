function [l, u] = confidence_interval(data, pct)
if nargin < 2, pct = 95; end

se = std(data) / sqrt(length(data));
t = tinv([1-pct/100 pct/100], length(data) - 1);
ci = mean(data) + t*se;
l = ci(1);
u = ci(2);

end