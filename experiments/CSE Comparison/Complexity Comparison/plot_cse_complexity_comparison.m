function plot_cse_complexity_comparison(results, field)
if nargin < 2, field = 'd'; end

if field == 'd'
    xlbl = 'Dimensionlaity (d)';
else
    xlbl = 'Cardinality (N)';
end

X = zeros(length(results), 1);
alpha = zeros(length(results), 1);
gmm = zeros(length(results), 1);
knn = zeros(length(results), 1);
parzen = zeros(length(results), 1);

for i = 1:length(results)
    result = results{i};
    
    X(i) = result.(field);
    alpha(i) = result.cses.alpha.duration;
    gmm(i) = result.cses.gmm.duration;
    knn(i) = result.cses.knn.duration;
    parzen(i) = result.cses.parzen.duration;
    
end

alpha(alpha == 0) = [];
knn(knn == 0) = [];
gmm(gmm == 0) = [];
parzen(parzen == 0) = [];

figure;
hold on;
plot(X(1:length(alpha)), alpha, '-r*');
plot(X(1:length(gmm)), gmm, '-bd', 'MarkerFaceColor', 'b');
plot(X(1:length(knn)), knn, '-k^', 'MarkerFaceColor', 'k');
plot(X(1:length(parzen)), parzen, '-mv', 'MarkerFaceColor', 'm');

if field == 'd'
    xlim([2 max(X)]);
end

title('Time Complexity of CSE methods on Unimodal Gaussian');
xlabel(xlbl);
ylabel('Extraction Duration (seconds)');
legend({'\alpha-shape', 'GMM', 'kNN', 'Parzen Window'});

set(gca, 'FontSize', 13);
hold off;

end