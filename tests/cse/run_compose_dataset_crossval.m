function [ results ] = run_compose_dataset_crossval( cses, dataset, folds )
if nargin < 3, folds = 10; end

ncses = length(cses);

for i = 1:folds
    datasets(i) = dataset;
    use = randperm(length(datasets(i).use{1}));
    use = use(1:min(19, end));
    datasets(i).use{1} = zeros(size(datasets(i).use{1}));
    datasets(i).use{1}(use) = 1;
end

perms = cell(ncses*folds, 2);

for i = 1:length(datasets)
    for j = 1:ncses
        perms{(i - 1)*ncses+j, 1} = COMPOSE(cses{j}, LabelPropagator);
        perms{(i - 1)*ncses+j, 2} = datasets(i);
    end
end


disp(['Running ' num2str(length(perms)) ' COMPOSE permutations']);
parfor i = 1:length(perms)
    results(i) = run_compose(perms{i, :});
end

end
