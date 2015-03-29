clear all; close all;

mu = [0 0];
sigma = eye(2);

Ns = 1000:1000:100000;

results = cell(length(Ns), 1);

warning('off', 'stats:gmdistribution:FailedToConverge');

pool = parpool(feature('numCores'));
try
    parfor i = 1:length(Ns)
        disp(['Testing with ' num2str(Ns(i)) ' samples']);

        results{i} = compare_cse_complexity(mvnrnd(mu, sigma, Ns(i)));
    end
    
    save('results', 'results');
    
catch e
    save('results', 'results');
    delete(pool);
    warning('on', 'stats:gmdistribution:FailedToConverge');
    rethrow(e);
end
delete(pool);

warning('on', 'stats:gmdistribution:FailedToConverge');
