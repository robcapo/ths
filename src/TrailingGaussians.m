classdef TrailingGaussians < StreamingData
    %TRAILINGGAUSSIANS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = protected)
        mu0;
        dmu;
        sig;
    end
    
    methods
        
        function obj = TrailingGaussians(opts)
            if nargin < 1, opts = struct; end
            
            defaultOpts = struct;
            defaultOpts.C = 3;
            defaultOpts.spread = 5;
            defaultOpts.sig = 1;
            defaultOpts.d = 2;
            defaultOpts.tMax = 10;
            defaultOpts.dmu = 1;
            
            fields = fieldnames(defaultOpts);
            for i = 1:length(fields)
                if ~isfield(opts, fields{i})
                    opts.(fields{i}) = defaultOpts.(fields{i});
                end
            end
            
            obj.tMax = opts.tMax;
            obj.y = (1:opts.C)';
            obj.d = opts.d;
            
            obj.mu0 = repmat((0:opts.spread:opts.spread*(opts.C - 1))', 1, opts.d);
            
            if length(opts.dmu) == 1
                obj.dmu = opts.dmu * ones(1, obj.d);
            elseif length(opts.dmu) == obj.d
                obj.dmu = opts.dmu;
            else
                error('ths:StreamingData:BadOptions', 'opts.dmu must be a 1xopts.d vector');
            end
            
            if length(opts.sig) == 1
                obj.sig = diag(opts.sig * ones(obj.d, 1));
            elseif size(opts.sig, 1) == obj.d && size(opts.sig, 2) == obj.d
                obj.sig = opts.sig;
            else
                error('ths:StreamingData:BadOptions', 'opts.sig must be a scalar or a opts.dxopts.d matrix');
            end
        end
        
        function [x, y] = sample(obj, t, y)
            if nargin < 3
                inds = round((length(obj.y) - 1)*rand(size(t))+1);
                y = obj.y(inds);
            end
            
            mus = obj.mu0(inds, :);
            
            x = zeros(length(inds), obj.d);
            
            for i = 1:length(inds)
                x(i, :) = mvnrnd(mus(i, :) + t(i)*obj.dmu, obj.sig, 1);
            end
        end
    end
    
end

