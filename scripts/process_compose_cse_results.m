function [confs, perfs] = process_compose_cse_results(results, plotResults)
if nargin < 2, plotResults = 1; end

% convert results into performance matrices
perfs = struct;

for i = 1:length(results)
    cseStruct = results{i, 2};
    dataset = results{i, 1};
    
    if isfield(dataset, 'bayes')
        bayes = cellfun(@(bayes, use) bayes(use == 0), dataset.bayes, dataset.use, 'UniformOutput', false);

        cseStruct(end + 1) = struct( ...
            'CSEClass', 'Bayes', ...
            'duration', 0, ...
            'h', {bayes} ...
        );
    end
    
    
    for j = 1:length(cseStruct)
        cse = cseStruct(j);
        
        if ~isfield(perfs, cse.CSEClass)
            perfs.(cse.CSEClass) = [];
        end
        
        for k = 1:length(cseStruct(j).h)
            y = dataset.labels{k};
            y = y(dataset.use{k} == 0);
            h = cseStruct(j).h{k};
            
            perfs.(cse.CSEClass)(k, i) = sum(h == y) / length(y);
        end
    end
end

% use performance matrices to calculate confidence intervals
confs = struct;

cses = fieldnames(perfs);
for i = 1:length(cses)
    confInts = zeros(size(perfs.(cses{i}), 1), 2);
    
    for j = 1:length(confInts)
        [confInts(j, 1), confInts(j, 2)] = confidence_interval(perfs.(cses{i})(j, :));
    end
    
    confs.(cses{i}) = confInts;
end

if plotResults
    % plot the confidence intervals
    colors = 'rgbcmyk';
    figure;
    hold on;
    cses = fieldnames(confs);
    for i = 1:length(cses)
        ciplot(confs.(cses{i})(:, 1), confs.(cses{i})(:, 2), 1:size(confs.(cses{i}), 1), colors(i));
    end
    legend(cses);
    ylim([0 1]);
    xlim([1, size(confs.(cses{i}), 1)]);
    hold off;
end
end