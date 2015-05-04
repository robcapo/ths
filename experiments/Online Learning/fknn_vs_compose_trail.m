clear all; close all;

fknnPerfs = [];
composePerfs = [];
for i = 1:10
    fknn = ForgettingKnnClassifier;
    c = COMPOSE(AlphaShapeCompactor, LabelPropagator);
    datastream = TrailingGaussians;
    dataset = get_dataset_from_datastream(datastream, 1000, 25);

    fknnResults = run_online_experiment(datastream, fknn);
    composeResults = run_compose(c, dataset);


    fknnH = chunkmat(fknnResults.h, length(dataset.labels{1}));
    fknnY = chunkmat(fknnResults.y, length(dataset.labels{1}));

    fknnPerfs(i, :) = cellfun(@(a, b) sum(a == b) / length(b), fknnH(2:end), fknnY(2:end));
    composePerfs(i, :) = cellfun(@(a, b) sum(a == b) / length(b), composeResults.h(2:end), dataset.labels(2:end));
end

fkl = [];
fku = [];
cl = [];
cu = [];
for i = 1:size(fknnPerfs, 1)
    [fkl(i), fku(i)] = confidence_interval(fknnPerfs(i, :));
    [cl(i), cu(i)] = confidence_interval(composePerfs(i, :));
end

hold on;
ciplot(fkl, fku, 1:length(fkl), 'b');
ciplot(cl, cu, 1:length(cl), 'r');
hold off;