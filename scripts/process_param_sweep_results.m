function perfs = process_param_sweep_results(results)
    perfs = zeros(length(results), 1);
    for i = 1:length(results)
        perfs(i) = percent_equal(results{i}.h, results{i}.y);
    end
end