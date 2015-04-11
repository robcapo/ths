function results = parallel_cse_comparison_dataset(datasets, cores)
if nargin < 2, cores = feature('numCores'); end

n = length(datasets);

results = cell(n, 2);
cses = { ...
    KNNDensitySampler(struct('p', .4)), ...
    ParzenWindowSampler(struct('p', .4, 'sigma', 1)), ...
    GMMDensitySampler(struct('p', .4)) ...
    AlphaShapeCompactor(struct('p', .4)), ...
};

delete(gcp('nocreate'));
pool = parpool(cores);
try
    parfor i = 1:n
        dataset = datasets{i};
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

save('parallel_cse_comparison_results_datasets', 'results');
end