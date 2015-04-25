function results = parallel_imbalanced_gaussian
if nargin < 2, cases = 100; end
if nargin < 1, nMax = 5000; end

parfor i = 1:10
    results(i) = imbalanced_gaussian(nMax, cases);
end
end