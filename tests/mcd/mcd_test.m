function [ perf, m, perfdur, mcddur ] = mcd_test( cse, ssl, X1, y1, X2, y2 )
%MCD_TEST Summary of this function goes here
%   Detailed explanation goes here

classes = unique(y1);
if ~isequal(classes, unique(y2)), error('y1 and y2 must have the same number of classes'); end

Xcs = [];
ycs = [];

tic;
for i = 1:length(classes)
    Xi = X1(y1 == classes(i), :);
    yi = y1(y1 == classes(i));
    
    inds = cse.extract(Xi);
    Xcs = [Xcs; Xi(inds, :)];
    ycs = [ycs; yi(inds)];
end

h = ssl.classify(Xcs, ycs, X2);
perfdur = toc;

perf = sum(h == y2) / length(y2);

tic;
m = mcd(X1, y1, X2, y2);
mcddur = toc;

end

