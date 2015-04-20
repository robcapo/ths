function plot_datastream(datastream, plotter, n)
if nargin < 3, n = 1000; end

t = linspace(0, datastream.tMax, n);

for i = 1:length(t)
    [x, y] = datastream.sample(t(i));
    
    plotter.plot(x, y);
    getframe;
end


end