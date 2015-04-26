function ps = plot_imbalanced_data_results(results)
ps = struct;
Ns = results(1).Ns;
Ns = Ns / max(Ns) / 2;
for i = 1:length(results)
    for j = 1:length(results(i).cses)
        cseClass = class(results(i).cses(j).cse);
        
        if ~isfield(ps, cseClass)
            ps.(cseClass) = results(i).cses(j).p;
        else
            ps.(cseClass) = [ps.(cseClass) results(i).cses(j).p];
        end
    end
end

cses = fieldnames(ps);
colors = 'rgbmcyk';
hold on;
for i = 1:length(cses)
    cse = cses{i};
    confInt = zeros(size(ps.(cse), 1), 2);
    for j = 1:size(ps.(cse), 1)
        [confInt(j, 1), confInt(j, 2)] = confidence_interval(ps.(cse)(j, :));
    end
    ciplot(confInt(:, 1), confInt(:, 2), Ns, colors(i));
end
ylim([0 .6]);
plot([0 .5], [0 .5], 'k');
legend(cses);
title('Core Support Extraction with Imbalanced Data');
ylabel('$\frac{||CS(X \in P_1)||}{||CS(X)||}$', 'FontSize', 20, 'interpreter', 'latex');
xlabel('$\frac{||X \in P_1||}{||X||}$', 'FontSize', 20, 'interpreter', 'latex');

hold off;
end