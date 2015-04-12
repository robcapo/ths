function [ dataset ] = sinusoidal_gaussians( c, f, dx, A, N, T, l )
if nargin < 7, l = 30; end
if nargin < 6, T = 100; end
if nargin < 5, N = 500; end
if nargin < 4, A = 4; end
if nargin < 3, dx = 2.7; end
if nargin < 2, f = 0.08; end
if nargin < 1, c = 4; end

if length(c) == 1, c = 1:c; end
if length(N) == 1, N = repmat(N, 1, length(c)); end

dataset.data = cell(T, 1);
dataset.labels = cell(T, 1);
dataset.use = cell(T, 1);
dataset.bayes = cell(T, 1);
dataset.bayes_perf = zeros(T, 1);

X = linspace(0, l, T);

for t = 1:T
    mus = zeros(length(c), 2);
    data = [];
    labels = [];
    % Create dataset at timestep
    for j = 1:length(c)
        x = X(t) + (j - 1)*dx;
        y = A*sin(2*pi*f*x);
        
        mus(j, :) = [x y];
        
        data = [data; mvnrnd([x y], eye(2), N(j))];
        labels = [labels; c(j)*ones(N(j), 1)];
    end
    
    dataset.data{t} = data;
    dataset.labels{t} = labels;
    dataset.use{t} = zeros(sum(N), 1);
    
    % Calculate Bayes classifier predictions
    pdfs = zeros(sum(N), length(c));
    for j = 1:length(c)
        pdfs(:, j) = mvnpdf(dataset.data{t}, mus(j, :), eye(2));
    end
    
    [~, dataset.bayes{t}] = max(pdfs, [], 2);
    
    dataset.bayes_perf(t) = sum(dataset.bayes{t} == dataset.labels{t}) / sum(N);
    
    % Add core supports
    if t == 1
        p = randperm(sum(N));
        dataset.use{t}(p(1:round(sum(N)*.1))) = 1;
    end
end




end

