function out = process_cse_result_permutations(results, y)
out = struct;
for i = 1:length(results)
    perfs = zeros(length(results(i).h), 1);
    for j = 2:length(results(i).h)
        perfs(j) = sum(results(i).h{j} == y{j}) / length(y{j});
    end
    
    if ~isfield(out, results(i).CSEClass)
        out.(results(i).CSEClass) = perfs;
    else
        out.(results(i).CSEClass) = [out.(results(i).CSEClass), perfs];
    end
end

cses = fieldnames(out);
figure;
hold on;
for i = 1:length(cses)
    disp(out.(cses{i}));
end

end