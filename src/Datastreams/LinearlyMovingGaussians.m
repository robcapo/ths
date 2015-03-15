classdef LinearlyMovingGaussians < StreamingData
    %LINEARLYMOVINGGAUSSIANS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        mu0;
        muT;
        sig;
    end
    
    methods
        function obj = LinearlyMovingGaussians(opts)
            if nargin < 1, opts = struct; end
            
            defaultOpts = struct;
            defaultOpts.mu0 = [0, 0; 4.5, 4.5];
            defaultOpts.muT = [4.5, 0; 0, 4.5];
            defaultOpts.sig = {[1, 0; 0, 1]; [1, 0; 0, 1]};
            defaultOpts.tMax = 5;
            
            
            fields = fieldnames(defaultOpts);
            for i = 1:length(fields)
                if ~isfield(opts, fields{i})
                    opts.(fields{i}) = defaultOpts.(fields{i});
                end
            end
            
            
            obj.mu0 = opts.mu0;
            obj.muT = opts.muT;
            obj.sig = opts.sig;
            
            obj.d = size(obj.mu0, 2);
            obj.y = (1:size(obj.mu0, 1))';
            obj.tMax = opts.tMax;
        end
        
        function [x, y] = sample(obj, t, y)
            if nargin < 3
                inds = round((length(obj.y) - 1)*rand(size(t))+1);
                y = obj.y(inds);
            end
            
            if t > obj.tMax
                warning(['tMax is ' num2str(obj.tMax) ' and the last sample was generated at ' num2str(t)]);
            end
            
            mu =  obj.mu0(y, :) + (obj.muT(y, :) - obj.mu0(y, :)) .* repmat(t, 1, size(obj.muT, 2)) / obj.tMax;
            
            x = zeros(length(t), size(obj.mu0, 2));
            
            for i = 1:length(t)
                x(i, :) = mvnrnd(mu(i, :), obj.sig{y(i)}, 1);
            end
        end
    end
    
end

