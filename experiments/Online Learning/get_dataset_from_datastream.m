function [ dataset ] = get_dataset_from_datastream( datastream, N, batches )
%GET_DATASET_FROM_DATASTREAM Outputs a COMPOSE compatible dataset from a
%Datastream instance

dataset = struct;

t = linspace(0, datastream.tMax, N)';

[X, y] = datastream.sample(t);

dataset.X = chunkmat(X, batches);
dataset.y = chunkmat(y, batches);

end

