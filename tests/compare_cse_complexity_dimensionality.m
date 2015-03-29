clear all; close all;

mu = [0 0];
sigma = eye(2);
N = 5000;
ds = 1:20;

results = cell(length(ds), 1);

warning('off', 'stats:gmdistribution:FailedToConverge');

pool = parpool(feature('numCores'));
try
    parfor i = 1:length(ds)
        disp(['Testing with ' num2str(ds(i)) ' dimensions']);

        results{i} = compare_cse_complexity(mvnrnd(zeros(1, ds(i)), eye(ds(i)), N));
    end
    
    save('results', 'results');
    
catch e
    disp('Caught error, saving results');
    save('results', 'results');
    delete(pool);
    warning('on', 'stats:gmdistribution:FailedToConverge');
    rethrow(e);
end
delete(pool);

warning('on', 'stats:gmdistribution:FailedToConverge');
