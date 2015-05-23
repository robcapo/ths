clear_except_breakpoints; close all;
load data/keystroke.mat

batchSize = 200;

knnResults = run_online_dataset( ...
    ForgettingKnnClassifier(struct('beta', .2102, 'k', 5, 'trainThreshold', .8)), ...
    X, ...
    y, ...
    t, ...
    batchSize * 2 ...
);



knnOut = chunkmat(knnResults.h, batchSize);

dataset.data = chunkmat(X, batchSize);
dataset.labels = chunkmat(y, batchSize);
use = [ones(batchSize*2, 1); zeros(length(y) - batchSize*2, 1)];
dataset.use = chunkmat(use, batchSize);

composeResults = run_compose( ...
    COMPOSE(KNNDensitySampler(struct('k', 1, 'p', 1)), LabelPropagator, struct('persistCoreSupports', 1)), ...
    dataset ...
);

binaryAccuracy = chunkmat(SCARGC_1NN(dataset, [], [], 12)', batchSize);

knnPerf = cellfun(@percent_equal, knnOut, dataset.labels(3:end));
composePerf = cellfun(@percent_equal, composeResults.h(3:end), dataset.labels(3:end));
scargcPerf = cellfun(@percent_equal, binaryAccuracy);

hold on;
plot(knnPerf);
plot(composePerf);
plot(scargcPerf);

title('Performance on keystroke dataset');
ylabel('Performance'); xlabel('Time step');
legend({'Forgetting kNN', 'COMPOSE', 'SCARGC 1NN'});
hold off;