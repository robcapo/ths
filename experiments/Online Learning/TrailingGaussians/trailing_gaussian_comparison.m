clear all; close all;

n = 1000;
batchSize = 25;
cse = AlphaShapeCompactor;
fknnOpts = struct;

fknnPerfs = [];
composePerfs = [];
bayesPerfs = [];
scargcPerfs = [];
for i = 1:10
    fknn = ForgettingKnnClassifier(fknnOpts);
    c = COMPOSE(cse, LabelPropagator);
    datastream = TrailingGaussians(struct('spread', 4.7));
    dataset = get_dataset_from_datastream(datastream, n, batchSize);

    fknnResults = run_online_experiment(datastream, fknn, [], struct('N', n));
    composeResults = run_compose(c, dataset);
    
    X = fknnResults.X; y = fknnResults.y; t = fknnResults.t;
    
    bayesH = zeros(size(y));
    
    mu0s = datastream.mu0;
    dmu = datastream.dmu;
    for j = 1:length(t)
        maxH = 0;
        for k = 1:size(mu0s, 1)
            h = mvnpdf(X(j, :), mu0s(k, :) + t(j)*dmu, datastream.sig);
            if h > maxH
                maxH = h;
                bayesH(j) = k;
            end
        end
    end

    fknnH = chunkmat(fknnResults.h, batchSize);
    fknnY = chunkmat(fknnResults.y, batchSize);
    bayesH = chunkmat(bayesH, batchSize);
    scargcH = chunkmat(SCARGC_1NN(dataset, [], [], 3)', batchSize);
    
    
    bayesPerfs(:, i)   = cellfun(@percent_equal, bayesH(2:end), fknnY(2:end));
    fknnPerfs(:, i)    = cellfun(@percent_equal, fknnH(2:end), fknnY(2:end));
    composePerfs(:, i) = cellfun(@percent_equal, composeResults.h(2:end), dataset.labels(2:end));
    scargcPerfs(:, i) = cellfun(@percent_equal, scargcH);
end

hold on;
plot_confidence_intervals(bayesPerfs, 'm');
plot_confidence_intervals(fknnPerfs, 'b');
plot_confidence_intervals(composePerfs, 'r');
plot_confidence_intervals(scargcPerfs, 'c');
ylim([0 1]);
ylabel('Performance');
xlabel('Time step');
title('Trailing Gaussian Experiment Results');
legend({'Bayes', 'Forgetting kNN', 'COMPOSE', 'SCARGC'});
hold off;

