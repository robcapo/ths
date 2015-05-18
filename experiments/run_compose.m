function results = run_compose(c, dataset, opts)
if nargin < 3, opts = struct; end

if ~isfield(opts, 'autoExtract'), opts.autoExtract = 0; end
if ~isfield(opts, 'debug'), opts.debug = 0; end

results = struct;
h = cell(length(dataset.data), 1);
dur = cell(length(dataset.data), 1);

for i = 1:size(dataset.data, 1)
    cs = dataset.use{i} == 1;
    ts = dataset.use{i} == 0;

    data = dataset.data{i};
    labels = dataset.labels{i};
    perf = 0;

    disp('Starting time step.');
    
    disp(['data: ' num2str(size(data, 1)) 'x' num2str(size(data, 2))]);
    disp(['training data: ' num2str(size(c.X, 1)) ' rows']);
    
    dur{i} = 0;
    if sum(cs) > 0
        trainData = data(cs, :);
        trainLabels = labels(cs, :);

        tic;
        c.train(trainData, trainLabels, 1);
        dur{i} = dur{i} + toc;
    end

    if sum(ts) > 0
        testData = data(ts, :);
        disp(['TS ' num2str(i) ' labels before classification ' mat2str(unique(c.y))]);
        tic;
        h{i} = c.classify(testData, i);
        dur{i} = dur{i} + toc;
        disp(['Classification took ' num2str(toc) 's.']);

        perf = sum(h{i} == labels(ts)) / sum(ts);

        if opts.debug == 1
            gscatter(c.X(:, 1), c.X(:, 2), c.y, 'brg', '.');
            title('Classified');
            pause;
        end
        
        disp(['TS ' num2str(i) ' labels after classification ' mat2str(unique(c.y))]);

        if c.autoExtract == 0
            tic;
            c.extract();
            dur{i} = dur{i} + toc;
        end
        
        disp(['TS ' num2str(i) ' labels after CSE ' mat2str(unique(c.y))]);

        if opts.debug == 1
            gscatter(c.X(:, 1), c.X(:, 2), c.y, 'brg', '*');
            title('Extracted');
            pause;
        end
    end

    disp(['COMPOSE with ' class(c.core_support_extractor) ' and ' class(c.classifier) ...
        ' finished timestep ' num2str(i) ' in ' num2str(dur{i}) 's and perf ' num2str(perf) '.']);
end

results.CSEClass = class(c.core_support_extractor);
results.duration = dur;
results.h = h;

end