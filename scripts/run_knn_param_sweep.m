% Keystroke Dataset
keystrokeBestK = 5;
keystrokeBestBeta = .2102;

best = 0;
for beta = linspace(0.1, 1, 50)
    for k = 1:2:40
        a = run_online_dataset(ForgettingKnnClassifier(struct('beta', beta, 'k', k)), X, y, t, 300);
        perf = sum(a.y == a.h) / length(a.y);
        if perf > best
            best = perf;
            bestK = k;
            bestBeta = beta;
        end
    end
end