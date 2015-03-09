% Run an online experiment with models
%
% datastream: An extension of class StreamingData 
% classifier: An extension of class ClassifierModel
% plotter: An extension of class StreamPlotter
% opts struct
% .N: number of observations to classify
% .Ntr: number of observations to initially classify
% .statsEveryN: report statistics every N samples classified
function [ results, opts ] = run_online_experiment( datastream, classifier, plotter, opts )
%RUN_ONLINE_EXPERIMENT Summary of this function goes here
%   Detailed explanation goes here

if nargin < 4, opts = struct; end
if nargin < 3, plotter = []; end
if nargin < 2, classifier = []; end

if ~isa(datastream, 'StreamingData')
    error('ths:DataStream:Invalid', 'The first argument to this function must be a StreamingData object');
end

if ~isa(classifier, 'ClassifierModel') && ~isempty(classifier)
    error('ths:Classifier:Invalid', 'The second argument to this function must be a ClassifierModel object');
end

if ~isa(plotter, 'StreamPlotter') && ~isempty(plotter)
    error('ths:Plotter:Invalid', 'The third argument to this function must be a StreamPlotter object');
end

if isempty(datastream.tMax)
    error('ths:DataStream:Invalid', 'The datastream must specify a value of tMax');
end


defaultOpts = struct;
defaultOpts.N = 1000;
defaultOpts.Ntr = 100;
defaultOpts.statsEveryN = 100;
% defaultOpts.nFolds = 10;
% defaultOpts.nCores = 1;
% defaultOpts.saveEvery = 1000;
% defaultOpts.resultsDirectory = ['results' datestr(now, 'yyyy-mm-dd/HHMM/')];

% fill in default options to opts
fields = fieldnames(defaultOpts);
for i = 1:length(fields)
    if ~isfield(opts, fields{i})
        opts.(fields{i}) = defaultOpts.(fields{i});
    end
end

if ~isempty(classifier)
    opts.ClassifierOpts = classifier.opts;
end

disp(['Experiment started at: ' datestr(now, 'HH:MM AM on mmm dd, yyyy')]);
disp('Options:');
disp(opts);
disp('Dataset:');
disp(datastream);
disp('Classifier:');
disp(classifier);
disp('Plotter:');
disp(plotter);

results = struct;
results.opts = opts;

t = linspace(0, datastream.tMax, opts.N + opts.Ntr)';

results.t_tr = t(1:opts.Ntr);
[results.X_tr, results.y_tr] = datastream.sample(results.t_tr);

if ~isempty(classifier)
    z = tic;
    classifier.train(results.X_tr, results.y_tr, results.t_tr);
    disp(['Training took: ' num2str(toc(z)) 's']);
end

results.t = t(opts.Ntr + 1:end);
[results.X, results.y] = datastream.sample(results.t);

results.h = zeros(size(results.t));
results.dur = zeros(size(results.t));



for i = 1:length(results.t)
    % classify
    if ~isempty(classifier)
        tStart = tic;
        results.h(i) = classifier.classify(results.X(i, :), results.t(i));
        results.dur(i) = toc(tStart);
        
        time(i);
    end
    
    % plot
    if ~isempty(plotter)
        if isempty(classifier)
            y = results.y(i);
        else
            y = results.h(i);
        end
        
        plotter.plot(results.X(i, :), y);
        title(plotter.axh, ['Time: ' num2str(results.t(i))]);
        getframe;
    end
end




function time(i)
    if mod(i, opts.statsEveryN) == 0
        disp('--');
        disp(['t: ' num2str(results.t(i))]);
        disp(['N: ' num2str(i)]);
        disp(['Last ' num2str(opts.statsEveryN) ' steps took ' ...
            num2str(sum(results.dur(i-opts.statsEveryN+1:i))) 's ' ...
            '(' num2str(mean(results.dur(i-opts.statsEveryN+1:i))) ' avg)']);
        disp(['Current performance: ' ...
            num2str(sum(results.h(1:i) == results.y(1:i)) * 100/ i) '%']);
    end
end


end