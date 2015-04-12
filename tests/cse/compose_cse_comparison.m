function [ results ] = compose_cse_comparison( dataset, cses, ssl, opts)
%COMPOSE_CSE_COMPARISON Summary of this function goes here
%   Detailed explanation goes here
if ~iscell(cses), cses = {cses}; end
if nargin < 4, opts = struct; end
if nargin < 3, ssl = LabelPropagator; end

if ~isfield(opts, 'autoExtract'), opts.autoExtract = 0; end
if ~isfield(opts, 'debug'), opts.debug = 0; end

classes = cellfun(@class, cses, 'UniformOutput', false);
results = struct('CSEClass', classes);

for i = 1:length(cses)
    cse = cses{i};
    c = COMPOSE(cse, ssl, opts);
    
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

            tic;
            c.extract();
            dur{j} = dur{j} + toc;
            
            if opts.debug == 1
                gscatter(c.X(:, 1), c.X(:, 2), c.y, 'brg', '*');
                title('Extracted');
                pause;
            end
        end
        
        disp(['COMPOSE with ' classes{i} ' finished timestep ' num2str(j) ' in ' num2str(dur{j}) 's and perf ' num2str(perf) '.']);
    end
    
    results(i).duration = dur;
    results(i).h = h;
end

