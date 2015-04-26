function report = run_experiment(learner, datastream, n, plotterClassifier, plotterDataset)
if nargin < 5, plotterDataset = []; end
if nargin < 4, plotterClassifier = []; end
if nargin < 3, n = 1000; end

nTr = n * .1;

report = struct;
report.learner = learner;
report.datastream = datastream;

report.tTr = linspace(0, nTr/n * datastream.tMax, nTr)';
report.tTe = linspace((nTr + 1)/n, datastream.tMax, n)';
report.h = zeros(size(report.tTe));
report.dur = zeros(size(report.tTe));

[report.XTr, report.yTr] = datastream.sample(report.tTr);
[report.XTe, report.yTe] = datastream.sample(report.tTe);

learner.train(report.XTr, report.yTr, report.tTr);

if ~isempty(plotterClassifier)
    [xTr, yTr] = learner.getData(max(1, learner.maxInd-plotterClassifier.N+1), learner.maxInd);
    
    plotterClassifier.plot(xTr, yTr);
end

if ~isempty(plotterDataset)
    [xTr, yTr] = learner.getData(max(1, learner.maxInd-plotterDataset.N+1), learner.maxInd);
    
    plotterDataset.plot(xTr, yTr);
end

for i = 1:length(report.tTe)
    x = report.XTe(i, :);
    y = report.yTe(i);
    t = report.tTe(i);
    
    tic;
    report.h(i) = learner.classify(x, t);
    report.dur(i) = toc;
    
    [~, h] = max(learner.lastY, [], 2);
    
    if ~isempty(plotterClassifier)
        plotterClassifier.plot(x, h);
        title('Predicted');
        getframe;
    end
    
    if ~isempty(plotterDataset)
        plotterDataset.plot(x, y);
        title('True');
        getframe;
    end
    if h ~= y
        disp('Misclassified');
    end
    if h ~= y && learner.lastSampleUsedForTraining == 1
        disp('Misclassified and trained');
        disp(['Predicted ' num2str(h) ' when true value was ' num2str(y)]);
        if 1
            Xk = learner.lastKnnX;
            Yk = learner.lastKnnY;
            [~, yk] = max(Yk, [], 2);
            tk = learner.lastKnnT;
            dk = learner.lastKnnD;

            fh = figure;
            hold on;
            c = [1 0 0; 0 1 0; 0 0 1; 1 1 0; 1 0 1; 0 1 1; 0 0 0];
            
            scatter(Xk(:, 1), Xk(:, 2), 25*pi, c(yk, :));
            scatter(report.XTr(:, 1), report.XTr(:, 2), 15, c(report.yTr, :), '+');
            scatter(report.XTe(1:i, 1), report.XTe(1:i, 2), 15, c(report.yTe(1:i), :), '+');
%             for j = 1:length(Xk)
%                 text(Xk(j, 1), Xk(j, 2), dk(j), mat2str([dk(j), abs(t - tk(j))], 2));
%             end
            zlim([0 max(dk)]);
            scatter(x(:, 1), x(:, 2), 'k*');
            title(mat2str(learner.lastY, 2));
            hold off;
            close(fh);
        end
    elseif h == y && learner.lastSampleUsedForTraining == 0
        disp('Correctly classified but not trained');
        if 1
            Xk = learner.lastKnnX;
            Yk = learner.lastKnnY;
            [~, yk] = max(Yk, [], 2);
            tk = learner.lastKnnT;
            dk = learner.lastKnnD;

            fh = figure;
            hold on;
            gscatter(Xk(:, 1), Xk(:, 2), yk, 'rgbcmyk');
            gscatter(report.XTr(:, 1), report.XTr(:, 2), report.yTr, 'rgbcmyk', '.', 1);
            gscatter(report.XTe(1:i, 1), report.XTe(1:i, 2), report.yTe(1:i), 'rgbcmyk', '.', 1);
%             for j = 1:length(Xk)
%                 text(Xk(j, 1), Xk(j, 2), dk(j), mat2str([dk(j), abs(t - tk(j))], 2));
%             end
            zlim([0 max(dk)]);
            scatter(x(:, 1), x(:, 2), 'k*');
            title(mat2str(learner.lastY, 2));
            hold off;
            close(fh);
        end
    end
end

end