function results = run_compose(c, dataset, opts)
if nargin < 3, opts = struct; end

if ~isfield(opts, 'autoExtract'), opts.autoExtract = 0; end
if ~isfield(opts, 'debug'), opts.debug = 0; end

results = struct;
h = cell(length(dataset.data), 1);
dur = cell(length(dataset.data), 1);

for j = 1:length(dataset.data)
    cs = dataset.use{j} == 1;
    ts = dataset.use{j} == 0;

    data = dataset.data{j};
    labels = dataset.labels{j};
    perf = 0;

    disp(['Starting on data with ' num2str(size(data, 1)) ' observations in ' num2str(size(data, 2)) ' dimensions'])
    dur{j} = 0;
    if ~isempty(cs)
        trainData = data(cs, :);
        trainLabels = labels(cs, :);

        tic;
        c.train(trainData, trainLabels, 1);
        dur{j} = dur{j} + toc;
    end

    if ~isempty(ts)
        testData = data(ts, :);

        tic;
        h{j} = c.classify(testData, j);
        disp(['Classification took ' num2str(toc) 's.']);

        perf = sum(h{j} == labels(ts)) / sum(ts);

        if opts.debug == 1
            gscatter(c.X(:, 1), c.X(:, 2), c.y, 'brg', '.');
            title('Classified');
            pause;
        end

        if c.autoExtract == 0
            tic;
            c.extract();
            dur{j} = dur{j} + toc;
        end

        if opts.debug == 1
            gscatter(c.X(:, 1), c.X(:, 2), c.y, 'brg', '*');
            title('Extracted');
            pause;
        end
    end

    disp(['COMPOSE with ' class(c.core_support_extractor) ' and ' class(c.classifier) ...
        ' finished timestep ' num2str(j) ' in ' num2str(dur{j}) 's and perf ' num2str(perf) '.']);
end

results.CSEClass = class(c.core_support_extractor);
results.duration = dur;
results.h = h;

end