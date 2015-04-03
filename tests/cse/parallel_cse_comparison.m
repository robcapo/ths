function results = parallel_cse_comparison(dataFun, n, cores)
if nargin < 3, cores = feature('numCores'); end
if nargin < 2, n = 10; end

results = cell(n, 2);
cses = { ...
    KNNDensitySampler(struct('p', .4)), ...
    ParzenWindowSampler(struct('p', .4)), ...
    GMMDensitySampler(struct('p', .4)) ...
    AlphaShapeCompactor(struct('p', .4)), ...
};

delete(gcp('nocreate'));
pool = parpool(cores);
try
    parfor i = 1:n
        dataset = dataFun();
        results(i, :) = {dataset, compose_cse_comparison(dataset, cses)};
    end
    
    save('results', 'results');
    
catch e
    disp('Caught error, saving results');
    save('results', 'results');
    delete(pool);
    warning('on', 'stats:gmdistribution:FailedToConverge');
    rethrow(e);
end

save('parallel_cse_comparison_results', 'results');
end