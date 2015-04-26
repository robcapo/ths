is = 20:30;
warning('off');
perfs = zeros(length(is), 4);
clearvars -except dataset perfs i is;

parfor i = is
    c1 = COMPOSE(AlphaShapeCompactor, LabelPropagator);
    c2 = COMPOSE(KNNDensitySampler, LabelPropagator);
    c3 = COMPOSE(GMMDensitySampler, LabelPropagator);
    c4 = COMPOSE(ParzenWindowSampler, LabelPropagator);
    a = zeros(1, 4);

    c1.train(dataset.data{i}, dataset.labels{i});
    c2.train(dataset.data{i}, dataset.labels{i});
    c3.train(dataset.data{i}, dataset.labels{i});
    c4.train(dataset.data{i}, dataset.labels{i});

    tic;
    c1.extract();
    a(1) = toc;
    disp(['ashape took ' num2str(a(1)) 's']);

    tic;
    c2.extract();
    a(2) = toc;
    disp(['KNN took ' num2str(a(2)) 's']);

    tic;
    c3.extract();
    a(3) = toc;
    disp(['GMM took ' num2str(a(3)) 's']);

    tic;
    c4.extract();
    a(4) = toc;
    disp(['Parzen window took ' num2str(a(4)) 's']);
    
    perfs(i, :) = a;
end

warning('on');