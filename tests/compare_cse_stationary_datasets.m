function compare_cse_stationary_datasets( datasets, cses )
%COMPARE_CSE_STATIONARY_DATASETS plots the core supports extracted from
%datsets using cses

if ~iscell(datasets), datasets = {datasets}; end
if ~iscell(cses), cses = {cses}; end

for i = 1:length(datasets)
    dataset = datasets{i, 1};
    params = datasets{i, 2};
    if ~iscell(params), params = {}; end
    
    [x, y] = dataset(params{:});
    
    figure;
    for j = 1:length(cses)
        cse = cses{j, 1};
        tic;
        inds = cse.extract([x, y]);
        dur = toc;
        
        subplot(1, length(cses), j);
        hold on;
        scatter(x, y, 'k.');
        scatter(x(inds), y(inds), 'r*');
        title([cses{j, 2}, ' took ' num2str(dur) ' s']);
        hold off;
    end
end


end

