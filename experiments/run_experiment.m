function report = run_experiment(learner, datastream, n, plotterClassifier, plotterDataset, additionalPlots)
if nargin < 6, additionalPlots = 1; end
if nargin < 5, plotterDataset = []; end
if nargin < 4, plotterClassifier = []; end
if nargin < 3, n = 1000; end

report = struct;
report.learner = learner;
report.datastream = datastream;

if isa(datastream, 'StreamingData')
    nTr = n * .1;
    
    report.tTr = linspace(0, nTr/n * datastream.tMax, nTr)';
    report.tTe = linspace((nTr + 1)/n, datastream.tMax, n)';
    report.h = zeros(size(report.tTe));
    report.dur = zeros(size(report.tTe));
    
    [report.XTr, report.yTr] = datastream.sample(report.tTr);
    [report.XTe, report.yTe] = datastream.sample(report.tTe);
elseif isstruct(datastream) && isfield(datastream, 'X') && isfield(datastream, 'y') && isfield(datastream, 't') && isfield(datastream, 'nTr')
    report.XTr = datastream.X(1:datastream.nTr, :);
    report.yTr = datastream.y(1:datastream.nTr);
    report.tTr = datastream.t(1:datastream.nTr);
    
    report.XTe = datastream.X(datastream.nTr+1:end, :);
    report.yTe = datastream.y(datastream.nTr+1:end);
    report.tTe = datastream.t(datastream.nTr+1:end);
    report.h = zeros(size(report.yTe));
else
    error('ths:InvalidDataset', 'Dataset must be an implementation of StreamingData or a struct with X, y, t, and nTr');
end

learner.train(report.XTr, report.yTr, report.tTr);

if ~isempty(plotterClassifier)
    [xTr, yTr] = learner.getData(max(1, learner.maxInd-plotterClassifier.N+1), learner.maxInd);
    
    plotterClassifier.plot(xTr, yTr);
end

if ~isempty(plotterDataset)
    [xTr, yTr] = learner.getData(max(1, learner.maxInd-plotterDataset.N+1), learner.maxInd);
    
    plotterDataset.plot(xTr, yTr);
end

report.incorrectTrainedY = [];
report.incorrectTrainedX = [];
report.correctUntrainedY = [];
report.correctUntrainedX = [];

for i = 1:length(report.tTe)
    x = report.XTe(i, :);
    y = report.yTe(i);
    t = report.tTe(i);
    
    tic;
    report.h(i) = learner.classify(x, t);
    report.dur(i) = toc;
    
    h = report.h(i);
    
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
        
        report.incorrectTrainedY = [report.incorrectTrainedY; learner.lastY];
        if additionalPlots
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
        report.correctUntrainedY = [report.correctUntrainedY; learner.lastY];
        if additionalPlots
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

disp(['Done. ' num2str(100*sum(report.h == report.yTe)/length(report.h)) '% accuracy']);
disp(['Mislabeled yet trained instances: ' num2str(length(report.incorrectTrainedY)) '. Correct, yet untrained instances: ' num2str(length(report.correctUntrainedY))]);

end