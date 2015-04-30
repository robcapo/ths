function [ dataset ] = get_dataset_from_datastream( datastream, N, batches )
%GET_DATASET_FROM_DATASTREAM Outputs a COMPOSE compatible dataset from a
%Datastream instance

dataset = struct;

t = linspace(0, datastream.tMax, N)';

[X, y] = datastream.sample(t);
use = zeros(size(y));
dataset.data = chunkmat(X, batches);
dataset.labels = chunkmat(y, batches);
dataset.use  = chunkmat(use, batches);
dataset.use{1} = ones(size(dataset.use{1}));

end

