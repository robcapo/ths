function [ results ] = compare_cse_complexity( data )
%COMPARE_CSE_COMPLEXITY Summary of this function goes here
%   Detailed explanation goes here

cses.alpha = struct('obj', AlphaShapeCompactor, 'name', '\alpha-shape', 'duration', 0);
cses.gmm = struct('obj', GMMDensitySampler, 'name', 'GMM', 'duration', 0);
cses.knn = struct('obj', KNNDensitySampler, 'name', 'kNN', 'duration', 0);
cses.parzen = struct('obj', ParzenWindowSampler, 'name', 'Parzen Window', 'duration', 0);

results = struct('N', size(data, 1), 'd', size(data, 2));

fields = fieldnames(cses);

for i = 1:length(fields)
    tic;
    cses.(fields{i}).obj.extract(data);
    dur = toc;
    disp(['Extraction of ' ...
        num2str(size(data, 1)) ' samples in ' ...
        num2str(size(data, 2)) ' dimensions with ' ...
        cses.(fields{i}).name ' took ' num2str(dur) ' seconds']);
    
    results.cses.(fields{i}).duration = dur;
end

end

