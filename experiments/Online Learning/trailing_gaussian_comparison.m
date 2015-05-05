clear all; close all;

n = 1000;
batchSize = 25;
cse = AlphaShapeCompactor;
fknnOpts = struct;

fknnPerfs = [];
composePerfs = [];
for i = 1:10
    fknn = ForgettingKnnClassifier(fknnOpts);
    c = COMPOSE(cse, LabelPropagator);
    datastream = TrailingGaussians;
    dataset = get_dataset_from_datastream(datastream, n, batchSize);

    fknnResults = run_online_experiment(datastream, fknn);
    composeResults = run_compose(c, dataset);

    fknnH = chunkmat(fknnResults.h, batchSize);
    fknnY = chunkmat(fknnResults.y, batchSize);

    fknnPerfs(:, i)    = cellfun(@percent_equal, fknnH(2:end), fknnY(2:end));
    composePerfs(:, i) = cellfun(@percent_equal, composeResults.h(2:end), dataset.labels(2:end));
end

hold on;
plot_confidence_intervals(fknnPerfs, 'b');
plot_confidence_intervals(composePerfs, 'r');
ylim([0 1]);
ylabel('Performance');
xlabel('Time step');
title('Trailing Gaussian Experiment Results');
legend({'Forgetting kNN', 'COMPOSE'});
hold off;

