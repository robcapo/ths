function results = fKNN_RG_param_sweep(betas, cores)
    if nargin < 2, cores = feature('numCores'); end
    if nargin < 1, betas = linspace(0, 20, 100); end
    
    inputs = cell(length(betas), 4);
    results = cell(length(betas), 1);
    
    for i = 1:length(betas)
        classifierOpts = struct;
        classifierOpts.beta = betas(i);

        inputs{i, 1} = RotatingGaussians;
        inputs{i, 2} = ForgettingKnnClassifier(classifierOpts);

        opts = struct;
        opts.Ntr = 100;
        opts.N = 5000;
        opts.statsEveryN = 1000;
        
        inputs{i, 4} = opts;
    end
    
    matlabpool('open', cores);

    try
        parfor i = 1:length(betas)
            results{i} = run_online_experiment(inputs{i, :});
        end
    catch e
        matlabpool('close');
        rethrow(e);
    end
    
    matlabpool('close');
    
end