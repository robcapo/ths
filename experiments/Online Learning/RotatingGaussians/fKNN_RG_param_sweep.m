function results = fKNN_RG_param_sweep(betas, cores, ks)
    if nargin < 3, ks = 25; end
    if nargin < 2, cores = feature('numCores'); end
    if nargin < 1, betas = linspace(0, 20, 100); end
    
    inputs = cell(length(betas), 4);
    results = cell(length(betas), 1);
    
    i = 1;
    for j = 1:length(ks)
        for k = 1:length(betas)
            classifierOpts = struct;
            classifierOpts.beta = betas(k);
            classifierOpts.k = ks(j);

            inputs{i, 1} = RotatingGaussiansVariableRadius(struct('radiusVariance', 0));
            inputs{i, 2} = ForgettingKnnClassifier(classifierOpts);

            opts = struct;
            opts.Ntr = 50;
            opts.N = 500;
            opts.statsEveryN = 1000;

            inputs{i, 4} = opts;
            
            i = i + 1;
        end
    end
    
    pool = parpool(cores);

    try
        parfor i = 1:size(inputs, 1)
            results{i} = run_online_experiment(inputs{i, :});
        end
    catch e
        delete(pool);
        rethrow(e);
    end
    
    delete(pool);
    
end