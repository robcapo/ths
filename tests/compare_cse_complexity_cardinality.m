clear all; close all;

pool = parpool(feature('numCores'));

mu = [0 0];
sigma = eye(2);

Ns = 1000:1000:2000;

results = cell(length(Ns), 1);

warning('off', 'stats:gmdistribution:FailedToConverge');

try
    parfor i = 1:length(Ns)
        disp(['Testing with ' num2str(Ns(i)) ' smamples']);

        results{i} = compare_cse_complexity(mvnrnd(mu, sigma, Ns(i)));
    end
    
    save('results', 'results');
    
catch e
    delete(pool);
    warning('on', 'stats:gmdistribution:FailedToConverge');
    rethrow(e);
end

warning('on', 'stats:gmdistribution:FailedToConverge');
delete(pool);