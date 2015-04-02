function [X] = genspiral(N, RangeMax, Spirals, B)
% GENSPIRAL: Generate Spiral Patterns
% [X] = genparametric(N, RangeMax, Spirals, B)
%
%   Generate spirals using parametric equations
%
%     INPUT
%         N: number of points made
%         RANGEMAX: t -> linspace(0,RangeMax,N)
%         SPIRALS: number of spirals to generate 
%         B: noise level (using randn(.))
%     OUTPUT
%         X: X contains the X and Y values of the 
%             generated data
%
% By - Greg Ditzler
% June 2009
%
% Modified - Rob Capo (changed output to cell array)
% Aug 2012

%Function Starts Here
t0 = linspace(0, RangeMax, N);
k = 1;

% Try varying these 4 parameters.
angle = 2*pi/Spirals;      % rotation angle


X = cell(1, Spirals);

%
%generate the spiral data set
%
for n = 1:Spirals,
    %generate parametric equations
    [x, y] = parametric(t0);
    
    sc = cos((n-1) * angle) ;
    ss = sin((n-1) * angle) ;
    
    % rotation transformation matrix
    T = [ sc ss; ss  -sc];
    
    %combine all the components 
    A = [x;y]';
    Z = A*T;
    
    [r, c] = size(Z);
    noise = B * randn(r, c);
    
    Z = Z + noise;
    
    %save into a matrix
    X{n} = Z;
end

