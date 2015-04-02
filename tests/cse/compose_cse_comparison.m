function [ results ] = compose_cse_comparison( dataset, cses, ssl, opts)
%COMPOSE_CSE_COMPARISON Summary of this function goes here
%   Detailed explanation goes here
if ~iscell(cses), cses = {cses}; end
if nargin < 4, opts = struct; end
if nargin < 3, ssl = LabelPropagator; end

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
        
        z = tic;
        if ~isempty(cs)
            trainData = data(cs, :);
            trainLabels = labels(cs, :);
        
            c.train(trainData, trainLabels, 1);
        end
        
        if ~isempty(ts)
            testData = data(ts, :);
            h{j} = c.classify(testData, j);
        end
        dur{j} = toc(z);
        
        disp(['COMPOSE with ' classes{i} ' finished timestep ' num2str(j) ' in ' num2str(dur{j}) 's.']);
    end
    
    results(i).duration = dur;
    results(i).h = h;
end

