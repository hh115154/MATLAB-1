function [A Node B Elem] = fun_read_mesh_as_text_v2012(fid)
%
% A:     first line of mesh file
%        [100079] [1000] [# of node] [projection info]
% Node:  
%        [serial #, X, Y, Z, boundary code]
% B:     
%        [# of element, 3 or 4, 21 or 25]
% Elem:  
%        element table

% fid2 = fopen(fullfile(loc,mesh2));

A = textscan(fid,'%f %f %f %[^\n]\n',1);
node = textscan(fid,'%f %f %f %f %f',A{3});
Node = cell2mat(node);

B = textscan(fid,'%f %f %f',1);

if B{2} == 3
    efmt = '%f %f %f %f';
elseif B{2} == 4
    efmt = '%f %f %f %f %f';
end

elem = textscan(fid,efmt,B{1});
Elem = cell2mat(elem);
