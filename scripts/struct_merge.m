function [ out ] = struct_merge( varargin )
%STRUCT_MERGE Merges a variable number of structures such that the fields
%of the later structures overwrite the fields of the previous ones

out = struct;

for j = 1:nargin
    struc = varargin{j};
    fields = fieldnames(struc);
    for i = 1:length(fields)
        out.(fields{i}) = struc.(fields{i});
    end
end

end

