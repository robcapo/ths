clear all; close all;
datastream = TrailingGaussians(struct('spread', 4.7));

subplot(121);
hold on;
for i = 1:size(datastream.mu0, 1)
    mu = datastream.mu0(i, :); %// data
    sigma = datastream.sig;
    plot_circle(mu(1), mu(2), sigma(1)*3)
    quiver(mu(1), mu(2), 4, 4, 'MaxHeadSize', .5);
    text(mu(1), mu(2), ['P' num2str(i)], 'FontSize', 12);
end
title('Initial Gaussian Distributions');
hold off;

subplot(122);
t = linspace(0, datastream.tMax, 1100);

[X, y] = datastream.sample(t(1:500)');
gscatter(X(:, 1), X(:, 2), y);
legend({'P1', 'P2', 'P3'});
title('First 500 observations drawn');