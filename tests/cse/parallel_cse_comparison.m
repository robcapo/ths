function results = parallel_cse_comparison(dataFun, n)
results = cell(n, 2);
cses = { ...
    AlphaShapeCompactor(struct('p', .4)), ...
    KNNDensitySampler(struct('p', .4)), ...
    ParzenWindowSampler(struct('p', .4)), ...
    GMMDensitySampler(struct('p', .4)) ...
};

delete(gcp('nocreate'));
pool = parpool(feature('numCores'));
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