function analyze_results(results)

for i = 1:length(results)
    result = results{i};
    
    disp(' ');
    disp(['===== Result ' num2str(i) ' =====']);
    if isfield(result, 'opts')
        disp('Options: ');
        disp(result.opts);
        disp('Classifier options: ');
        disp(result.opts.ClassifierOpts);
    end
    disp(['Avg. performance ' num2str(100*sum(result.h == result.y) / length(result.h)) '%']);
    disp(['Total duration ' num2str(sum(result.dur))]);
end

end