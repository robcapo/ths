classdef AlphaShapeCompactor < CoreSupportExtractor
    %ALPHASHAPECOMPACTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        alpha = 1;
    end
    
    methods
        function obj = AlphaShapeCompactor(opts)
            if nargin < 1, opts = struct; end
            
            if isfield(opts, 'p'), obj.p = opts.p; end
            if isfield(opts, 'alpha'), obj.alpha = opts.alpha; end
        end
        
        function inds = extract(obj, data)
            ashape = obj.createAlphaShape(data);

            if isempty(ashape)
                display('No Alpha Shape could be constructed try different alpha or check data');
                return;
            end
            
            N = size(data, 1);
            N_core_supports = ceil(N*obj.p);
            
            while true
                simplexInds = find(ashape.include == 1);
                simplexes = ashape.simplexes(simplexInds, :);
                
                % index of simplex that each d-1 simplex comes from
                edgeID = repmat( ...
                    simplexInds, ...
                    size(simplexes, 2), ...
                    1 ...
                );

                % find d-1 simplexes
                edges = zeros(size(simplexes, 1) * size(simplexes, 2), size(simplexes, 2) - 1);
                cols = 1:size(simplexes,2);
                for i = 1:size(ashape.simplexes,2)
                    edges((i-1)*size(simplexes, 1) + 1:i*size(simplexes, 1), :) = simplexes(:, cols(1:size(simplexes,2)-1));
                    cols = circshift(cols,[0 1]);    
                end

                % sort edges so that it's easy to find duplicates
                edges = sort(edges, 2);
                [edges, Sid] = sortrows(edges);
                edgeID = edgeID(Sid);

                % find duplicate edges
                diff_edges = [1; sum(abs(diff(edges)), 2)];
                diff_edges(find(diff_edges == 0) - 1) = 0;
                
                ashape.include(edgeID(diff_edges ~= 0)) = 0;
                points_remaining = unique(ashape.simplexes(ashape.include==1));
                
                if numel(points_remaining) < N_core_supports 
                   break;
                end
                
                inds = points_remaining;
            end
        end
        
        function ashape = createAlphaShape(obj, data)
            if size(data, 1) < size(data, 2) + 1                                      % If a class does not have enought points to construct a tesselation
                fprintf( ...
                    ['Warning::Alpha_Shape::Tesselation_Construction\n', ...
                    'Data of dimension %i requires a minimum of %i unique points.', ...
                    ' Alpha shape was not constructed for this data\n'], ...
                    obj.n_features, ...
                    obj.n_features+1 ...
                );
                ashape = [];
                return;
            else
                ashape.simplexes = delaunayn(data, {'Qt','Qbb','Qc','Qz'});         % set the output simplexes to the Delaunay Triangulation
                ashape.include   = zeros(size(ashape.simplexes, 1), 1);                % create a blank vector to indicate whether to include each simplex in the alpha shape
                
                for sID = 1:size(ashape.simplexes,1)                                                % iterate through each simplex     
                    if obj.alpha > obj.findCircumsphere(data(ashape.simplexes(sID, :), :)) % If alpha is larger than the radius of the simplex
                        ashape.include(sID) = 1;                                                    % Include that simplex in the alpha shape
                    end
                end
            end
        end
    end
    
    methods (Access = protected)
        % Alpha Shape Boundary Construction Dependency
        function [radius, center] = findCircumsphere(~, points)
            %CALC_RADIUS - finds the radius of an D-dimensional sphere from D+1 points
            %           
            % INPUTS
            %   points : [matrix] D+1 points x D dimensions
            %
            % OUPUTS
            %   radius : [double] radius of D-sphere
            %
            % Reference - http://mysite.verizon.net/res148h4j/zenosamples/zs_sphere4pts.html

            %%% Validation and Parser
            nD = size(points,2); % number of dimensions
            validateattributes(nD,{'numeric'},{'>=',2});

            p = inputParser;
            p.addRequired('points',@(x)validateattributes(x,{'numeric'},{'real','nonnan','finite','size',[nD+1,nD]}));

            p.parse(points)
            in = p.Results;         %Struct of inputs ex: in.variable

            %%% Construct Matrix
            M(:,1) = sum(in.points.^2,2);
            M = [M in.points ones(nD+1,1)];

            %%% Calculate minors
            m = zeros(size(M,2),1);
            for mID = 1:size(M,2)
                temp = M;
                temp(:,mID) = [];
                m(mID) = det(temp);
            end

            %%% Calculate center for each dimension
            center = zeros(1,nD);
            for j = 1:nD
                center(1,j)=((-1)^(j+1))*0.5*m(j+1)/m(1);
            end

            %%% Measure distance from center point to any first given point
            radius = sqrt(sum((center-in.points(1,:)).^2,2));
        end
    end
    
end

