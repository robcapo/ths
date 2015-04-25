function results = imbalanced_gaussian(nMax, cases)
if nargin < 2, cases = 100; end
if nargin < 1, nMax = 5000; end

Ns = round(linspace(1, nMax, cases));

results.Ns = Ns;
results.nMax = nMax;

cses(1).cse = AlphaShapeCompactor;
cses(1).p = zeros(cases, 1);
cses(1).durs = zeros(cases, 1);
cses(2).cse= GMMDensitySampler;
cses(2).p = zeros(cases, 1);
cses(2).durs = zeros(cases, 1);
cses(3).cse = KNNDensitySampler;
cses(3).p = zeros(cases, 1);
cses(3).durs = zeros(cases, 1);
cses(4).cse = ParzenWindowSampler(struct('sigma', 3));
cses(4).p = zeros(cases, 1);
cses(4).durs = zeros(cases, 1);

warning('off');
for i = 1:length(Ns)
    data = [mvnrnd([5 0], eye(2), nMax); mvnrnd([-5 0], eye(2), Ns(i))];
    
    for j = 1:length(cses)
        tic;
        cs = cses(j).cse.extract(data);
        cses(j).durs(i) = toc;
        cses(j).p(i) = sum(cs > nMax) / length(cs);
        
        disp(['Finished case ' num2str(i) ' with P = ' num2str(Ns(i) / (Ns(i) + nMax)) ...
            ' and Pcs = ' num2str(cses(j).p(i)) ' using ' class(cses(j).cse) '.']);
    end
end
warning('on');

results.cses = cses;

end