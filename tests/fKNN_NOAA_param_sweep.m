function results = fKNN_NOAA_param_sweep(betas, cores)
    if nargin < 2, cores = feature('numCores'); end
    if nargin < 1, betas = linspace(0, 20, 100); end
    
    load('datasets/NOAA_Rain');
    tr = 500;
    
    inputs = cell(length(betas), 4);
    
    for i = 1:length(betas)
        classifierOpts = struct;
        classifierOpts.beta = betas(i);

        inputs{i, 1} = ForgettingKnnClassifier(classifierOpts);
        inputs{i, 2} = X;
        inputs{i, 3} = y;
        inputs{i, 4} = t;
        inputs{i, 5} = tr;
    end
    
    matlabpool('open', cores);

    try
        results = cell(length(betas), 1);
        
        parfor i = 1:length(betas)
            results{i} = run_online_dataset(inputs{i, :});
        end
    catch e
        matlabpool('close');
        rethrow(e);
    end
    
    matlabpool('close');
end