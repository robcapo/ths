close all;

%% PLOT DATASET
figure;
for i = 1:length(dataset.data)
    gscatter(dataset.data{i}(:,1), dataset.data{i}(:, 2), dataset.labels{i});
    xlim([-1 65]);
    ylim([-6 6]);
    title(num2str(i));
    pause(.1);
end

%% PLOT BAYES
figure;
plot(dataset.bayes_perf)
title('Bayes performance');
ylim([0 1]);