function [ results ] = compose_cse_comparison( dataset, cses, ssl, opts)
%COMPOSE_CSE_COMPARISON Summary of this function goes here
%   Detailed explanation goes here
if ~iscell(cses), cses = {cses}; end
if nargin < 4, opts = struct; end
if nargin < 3, ssl = LabelPropagator; end

if ~isfield(opts, 'autoExtract'), opts.autoExtract = 0; end
if ~isfield(opts, 'debug'), opts.debug = 0; end

classes = cellfun(@class, cses, 'UniformOutput', false);
results = struct('CSEClass', classes);

for i = 1:length(cses)
    c = COMPOSE(cses{i}, ssl, opts);
    
    results(i) = run_compose(c, dataset, opts);
end

