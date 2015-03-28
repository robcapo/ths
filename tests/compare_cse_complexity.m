function [ results ] = compare_cse_complexity( data )
%COMPARE_CSE_COMPLEXITY Summary of this function goes here
%   Detailed explanation goes here

cses(1) = struct('obj', AlphaShapeCompactor, 'name', '\alpha-shape');
cses(2) = struct('obj', GMMDensitySampler, 'name', 'GMM');
cses(3) = struct('obj', KNNDensitySampler, 'name', 'kNN');
cses(4) = struct('obj', ParzenWindowSampler, 'name', 'Parzen Window');

for i = 1:length(cses)
    tic;
    cses(i).obj.extract(data);
    dur = toc;
    results(i) = struct( ...
        'name', cses(i).name, ...
        'duration', dur, ...
        'N', size(data, 1), ...
        'd', size(data, 2) ...
    );
end

end

