clear_except_breakpoints; close all;

load('datasets/UG_2C_2D_T100');

cse = KNNDensitySampler(struct('k', 100, 'p', .5));
% cse = AlphaShapeCompactor(struct('alpha', 5));
% cse = GMMDensitySampler;
ssl = LabelPropagator;
c = COMPOSE(cse, ssl, struct('autoExtract', 0));

c.train(dataset.data{1}, dataset.labels{1}, ones(size(dataset.labels{1})));

for i = 2:length(dataset.data)
    clf;
    hold on;
    data = dataset.data{i};
    gscatter(c.X(:, 1), c.X(:, 2), c.y);
    scatter(data(:, 1), data(:, 2), 'k.');
    xlim([-5 15]);
    ylim([-5 15]);
    title('New Data');
    getframe;
%     pause;
    
    
    clf;
    c.classify(data, i);
    gscatter(c.X(:, 1), c.X(:, 2), c.y);
    xlim([-5 15]);
    ylim([-5 15]);
    title('Classified');
    getframe;
%     pause;
    
    clf;
    c.extract();
    gscatter(c.X(:, 1), c.X(:, 2), c.y);
    xlim([-5 15]);
    ylim([-5 15]);
    title('Extracted');
    getframe;
%     pause;
%     hold off;
    
    
    
end