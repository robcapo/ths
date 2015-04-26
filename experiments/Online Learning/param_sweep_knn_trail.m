clear_except_breakpoints;
n = 1000;
betas = .5:.1:5;
perfs = zeros(size(betas));
for i = 1:length(betas)
    r = run_experiment(ForgettingKnnClassifier(struct('beta', betas(i))), TrailingGaussians(struct('spread', 3)), n);
    perfs(i) = sum(r.h == r.yTe) / length(r.h);
end