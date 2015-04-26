clear all; close all;

load('results/mcd/mcd_results');

vs = [0 5 10 15];
hs = [10 10 10 25];


for i = 1:length(vs)
    res = cell2mat(cellfun(@(a) a(i, :), mcds, 'UniformOutput', false)');
    resp = cell2mat(cellfun(@(a) a(i, :), perfs, 'UniformOutput', false)');
    
    l = zeros(1, size(res, 2));
    u = zeros(size(l));
    lp = zeros(size(l));
    up = zeros(size(lp));
    
    for j = 1:size(res, 2)
        [l(j), u(j)] = confidence_interval(res(:,j));
        [lp(j), up(j)] = confidence_interval(resp(:, j));
    end
    
    subplot(length(vs), 1, i);
    hold on;
    ciplot(l, u, linspace(0, hs(i), length(l)), 'b');
    
    if isequal(lp, up)
        plot(linspace(0, hs(i), length(lp)), lp, 'r');
    else
        ciplot(lp, up, linspace(0, hs(i), length(lp)), 'r');
    end
    
    title(['v = ' num2str(vs(i)) ', h = ' num2str(hs(i))]);
    xlabel('d');
    ylabel('MCD');
end