function [ results ] = run_online_dataset( classifier, X, y, t, tr )
%RUN_ONLINE_DATASET Summary of this function goes here
%   classifier- An implementation of the ClassifierModel interface
%   X- an Nxd matrix of observations
%   y- an Nx1 vector of labels
%   t- an Nx1 vector of times sampled
%   tr- either a scalar saying the first M observations should be used as training data, or a binary vector specifying
%       which observations should be used

if ~isa(classifier, 'ClassifierModel')
    error('ths:Classifier:Invalid', 'classifier must implement the ClassifierModel interface');
end

if size(y, 2) ~= 1
    error('ths:Data:Invalid', 'y must be a column vector of labels');
end

if size(t, 2) ~= 1
    error('ths:Data:Invalid', 't must be a column vector of times sampled');
end

if size(tr, 2) ~= 1
    error('ths:Data:Invalid', 'tr must be a scalar or binary column vector of training indices');
end

if size(X, 1) ~= size(y, 1) || size(X, 1) ~= size(t, 1)
    error('ths:Data:Invalid', 'X, y, and t must have the same number of rows');
end

if size(tr, 1) ~= 1 && size(tr, 1) ~= size(X, 1)
    error('ths:Data:Invalid', 'tr must be a scalar or have the same number of rows as X');
end

if isscalar(tr)
    if tr > size(X, 1)
        error('ths:InvalidArgument', 'tr was specified to be more than the length of the dataset.');
    end
    
    tr = padarray(ones(tr, 1), size(X, 1) - tr, 0, 'post');
end

opts = struct;
opts.ClassifierOpts = classifier.opts;

results = struct;

results.opts = opts;
results.t_tr = t(tr == 1, :);
results.X_tr = X(tr == 1, :);
results.y_tr = y(tr == 1, :);

results.t = t(tr == 0, :);
results.X = X(tr == 0, :);
results.y = y(tr == 0, :);

results.h = zeros(size(find(tr == 0)));
results.dur = zeros(size(find(tr == 0)));

disp(['Experiment started at: ' datestr(now, 'HH:MM AM on mmm dd, yyyy')]);
disp('Classifier:');
disp(classifier);
disp(['Data: ' num2str(size(results.X_tr, 1)) ' observations for training, ' ...
    num2str(size(results.X, 1)) ' for testing.']);

tTr = tic;
classifier.train(results.X_tr, results.y_tr, results.t_tr);
disp(['Trianing took ' num2str(toc(tTr)) 's.']);


results.trainedIncorrect = 0;
results.notTrainedCorrect = 0;
tTe = tic;
for i = 1:size(results.X, 1)
    tStart = tic;
    results.h(i) = classifier.classify(results.X(i, :), results.t(i));
    results.dur(i) = toc(tStart);
    
    if results.h(i) ~= results.y(i) && classifier.lastSampleUsedForTraining == 1
        results.trainedIncorrect = results.trainedIncorrect + 1;
    end
    
    if results.h(i) == results.y(i) && classifier.lastSampleUsedForTraining == 0
        results.notTrainedCorrect = results.notTrainedCorrect + 1;
    end
    
    if mod(i, 500) == 0
        disp(['Classifying observation ' num2str(i) '. '...
            'Elapsed time: ' num2str(toc(tTe))]);
    end
end
end
