function compare_cse_stationary_datasets( datasets, cses )
%COMPARE_CSE_STATIONARY_DATASETS plots the core supports extracted from
%datsets using cses

warning('off', 'stats:gmdistribution:FailedToConverge');

if ~iscell(datasets), datasets = {datasets}; end
if ~iscell(cses), cses = {cses}; end

for i = 1:size(datasets, 1)
    dataset = datasets{i, 1};
    params = datasets{i, 2};
    if ~iscell(params), params = {}; end
    
    disp(['Creating dataset: ' datasets{i, 3}]);
    [x, y] = dataset(params{:});
    disp('Done creating dataset.');
    
    
    figure('Name', datasets{i, 3});
    for j = 1:length(cses)
        disp(['Extracting with: ' cses{j, 2}]);
        cse = cses{j, 1};
        tic;
        inds = cse.extract([x, y]);
        dur = toc;
        
        subplot(1, length(cses), j);
        hold on;
        scatter(x, y, 'k.');
        scatter(x(inds), y(inds), 'r*');
        title([cses{j, 2}, ' took ' num2str(dur) 's']);
        hold off;
        
        disp(['Finished extracting in ' num2str(dur) ' s']);
    end
end

warning('on', 'stats:gmdistribution:FailedToConverge');


end

