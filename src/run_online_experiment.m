function [ results ] = run_online_experiment( datastream, classifier, plotter, opts )
%RUN_ONLINE_EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4, opts = struct; end

if ~isa(datastream, 'StreamingData')
    error('run_online_experiment:BadStream', 'The first argument to the constructor must be a StreamingData object');
end

if ~isa(classifier, 'ClassifierModel')
    error('run_online_experiment:BadClassifier', 'The second argument to my constructor must be a ClassifierModel object');
end

if ~isa(plotter, 'Plotter')
    error('run_online_experiment:BadPlotter', 'The second argument to my constructor must be a ClassifierModel object');
end

if isempty(datastream.tMax)
    error('run_online_experiment:BadStream', 'The datastream must specify a value of tMax');
end


defaultOpts = struct;
defaultOpts.N = 100000;
defaultOpts.Ntr = 20000;
% defaultOpts.nFolds = 10;
% defaultOpts.nCores = 1;
% defaultOpts.saveEvery = 1000;
% defaultOpts.resultsDirectory = ['results' datestr(now, 'yyyy-mm-dd/HHMM/')];

% fill in default options to opts
for i = fieldnames(defaultOpts)
    if ~isfield(opts, i)
        opts.(i) = defaultOpts.(i);
    end
end

disp(['Experiment started at: ' datestr(now, 'HH:MM AM on mmm dd, yyyy')]);
disp(['Options: ', opts]);

results = struct;

t = linspace(0, classifier.tMax, opts.N + opts.Ntr);

results.t_tr = t(1:opts.Ntr);
results.t = t(1:opts.Ntr + 1:end);

[results.X_tr, results.y_tr] = datastream.sample(results.t_tr);

classifier.train(results.X_tr, results.y_tr, results.t_tr);

results.X = zeros(length(results.t), size(results.X_tr, 2));
results.h = zeros(size(results.t));
results.dur = zeros(size(results.t));

[results.X, results.y] = datastream.sample(results.t);

for i = 1:length(results.t)
    tStart = tic;
    results.h(i) = classifier.classify(results.X(i, :), results.t(i));
    results.dur(i) = toc(tStart);
end


end