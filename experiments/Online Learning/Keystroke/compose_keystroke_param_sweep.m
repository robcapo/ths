clear_except_breakpoints; close all;
load data/keystroke.mat

batchSize = 200;

dataset.data = chunkmat(X, batchSize);
dataset.labels = chunkmat(y, batchSize);
use = [ones(batchSize*2, 1); zeros(length(y) - batchSize*2, 1)];
dataset.use = chunkmat(use, batchSize);

bestPerf = 0;

for k = 1:4:31

    perfs = zeros(100, 1);
    ps = linspace(.2, 1, 100)';
    parfor i = 1:length(ps)
        composeResults = run_compose( ...
            COMPOSE(KNNDensitySampler(struct('k', 15, 'p', ps(i))), LabelPropagator, struct('persistCoreSupports', 1)), ...
            ...COMPOSE(AlphaShapeCompactor(struct('p', ps(i))), LabelPropagator, struct('persistCoreSupports', 1)), ...
            ...COMPOSE(GMMDensitySampler, LabelPropagator, struct('persistCoreSupports', 1)), ...
            dataset ...
        );

        perfs(i) = percent_equal(cell2mat(composeResults.h), cell2mat(dataset.labels(3:end)));
    end
    
    [perf, ind] = max(perfs);
    
    disp(['Best performing p was ' num2str(ps(ind)) ' at ' num2str(perf*100) '%']);
    
    if perf > bestPerf
        bestK = k;
        bestP = ps(ind);
        bestPerf = perf;
    end
end