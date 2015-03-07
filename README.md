# ths

This is a framework for classifying datastreams.

It includes a few interfaces, a function to run an experiment with
specified modules, and a few implementations of different modules.

## Interfaces
### StreamingData
An object that can provide a stream of observations and corresponding
labels at arbitrary points in time.

__Properties__:
- `tMax`: the maximum time (ending time) of the experiment
- `y`: A column vector specifying the possible class labels
- `d`: A scalar specifying the number of dimensions in the dataset

__Methods__:
- `[x, y] = obj.sample(t, y)`: Sample a new observation at time `t`
from class `y`. `y` should be optional and drawn from a uniform
distribution containing all possible classes by default. `t` is
required.

__Implementations__:

__RotatingGaussians__- a 2d environment that generates observations
from Gaussians that are rotating around the origin

`obj = RotatingGaussians(n);`

- `n` is the number of Gaussian classes to use. They will be divided
  equally around the origin, and will all rotate in the same direction
  around a circle of radius 5 at `1` full rotation per second.

__TrailingGaussians__- an experiment where Gaussians will move uniformly
along a line.

`obj = TrailingGaussians(opts)`

- `opts` is a `struct` with the following fields:

Field      | Description
-----------|-------------------------------------------------
`C`        | The number of classes (Gaussians) to sample from (_defualt_: `3`)
`dmu`      | The rate at which the distributions move. Either a scalar or a vector in units / second to move in each dimension. (_defualt_: `1`)
`spread`   | How far (Euclidean distance) each Gaussian will be from the one in front / behind it (_default_: `5`)
`sig`      | Either a scalar specifying the diagonal covariances of each Gaussian or a covariance matrix (_default_: `1`)
`d`        | The number of dimensions for the experiment (must agree with `sig`) (_default_: `2`)
`tMax`     | The maximum time of the experiment (_default_: `1.1` times the number of seconds required for the last distribution to reach the original position of the first)


### StreamPlotter
This object is used to plot datasets that come from a stream. Objects
that implement this interface should hide older observations as the
data changes.

__Properties__:
- `axh`: The handle to the axes the plotter is using
- `n`: The number of most recent points to retain on the graph
- `colors`: A * by 3 matrix specifying the RGB values of the plotter's
colormap. This can be any length, and the plotter should restart
from the beginning of the matrix if there are more classes than colors

__Methods__:
- `obj.plot(X, c)` plot observations in `X` as color specified by index `c`.
  `c` must have the same number of rows as `X` or be scalar.

__Implementations__:

__Plotter2d__- a plotter in 2 dimensions that will discard old observations
in a FIFO manner. Note: observations that were provided to the plotter in
batches will be deleted in batches. So if `plot` was called with `X` being
matrix with 50 rows, those observations will remain on the axes until `plot`
is called `opts.N` more times, at which point they will all be deleted at
once.

`obj = Plotter2d(opts);`

- `opts` is a `struct` with the following fields:

Field    | Description
---------|----------------
axh      | An existing axis handle that Plotter2d should attach to
N        | The number of points to retain on the graph at once (FIFO)
colors   | A Cx3 matrix where C is the number of colors in the colormap and columns are RGB values


### ClassifierModel
The actual classifier for data streams

__Methods__:
- `obj.train(X, y, t)`: Train the classifier with observations specified
in `X` that were drawn at time `t` from class `y`. The number of rows in
`X`, `y`, and `t` must match. `y` can be a vector or matrix containing
posterior probabilities. If `y` is a matrix, the sum of its columns must
be a vector of `1`s.

- `h = obj.classify(X, t)`: Predict the labels of the observations in `X`
drawn at time `t`. The number of rows in `X` and `t` must be the same. `h`
is a vector containing the same number of rows as `X` and `t`, with integers
specifying the class label that the observations belong to, according to the
classifier.

__Implementations__:

__ForgettingKnnClassifier__

`obj = ForgettingKnnClassifier(opts);`

- `opts` is a `struct` with the following fields:

Field        | Description 
-------------|------------------------------------------------------------------------------------
`rowPadding` | The number of rows to grow the resizable array `X` when it gets full (_default_: `500`) 
`k`          | The number of nearest neighbors to consider (_default_: `25`) 
`beta`       | The forgetting rate over time (_default_: `.1`) 
