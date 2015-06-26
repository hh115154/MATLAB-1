% replace nodes value without DHI license (mesh file)
clear all
close all


%% read mesh file
[mesh_name, mesh_path]=uigetfile('*.mesh','Select mesh to read...');
fid = fopen(fullfile(mesh_path,mesh_name));
[A Node B Elem] = fun_read_mesh_as_text_v2012(fid);
% A     : serial number for Nodes
% Node  : vertices of triangle
% B     : serial number for Elements
% Elem  : Elements, i.e. triangles or quadrangles
fclose(fid);




%% read replacing node value
[csv_name, csv_path]=uigetfile('*.csv','Select Node number to read...');

fcsv = fopen(fullfile(csv_path,csv_name));
C = textscan(fcsv,'%f%f','delimiter',',');
fclose(fcsv);

sel_node = cell2mat(C(1));

% - ----------------------------  JUST replace values
% new_value = -.914;
% Node(sel_node,4) = new_value;

% - ----------------------------   compare and take lesser: min(Bathymetry,new_value)
if false
    oxbow_value = -1.219;
    Node(sel_node,4) = min(oxbow_value,Node(sel_node,4));
end

% -------------------------- change boundary 'code' (5th column of Node)
bnd_code = 70;
Node(sel_node,5) = bnd_code;

%% write a NEW mesh
new_mesh_name = [mesh_name(1:end-5) '_fix50.mesh'];
fidw = fopen(fullfile(mesh_path,new_mesh_name),'wt');
a1 = A(1:3);       % total number of nodes
a2 = A{4}{1};      % text info about projection, unit and etc.

siz = size(Elem);

if siz(2) == 4;
    wfmt = '%d %d %d %d\n';
else
    wfmt = '%d %d %d %d %d\n';
end

%     new_fn = sprintf('%s_new_with_TD.mesh',mesh_fn(1:end-5));
%     fidw = fopen(fullfile(xy_loc,new_fn),'wt');
fprintf(fidw,'%d %d %d  %s\n',a1{1},a1{2},a1{3},a2);
fprintf(fidw,'%d %.10f %.10f %.4f %d\n',Node');
fprintf(fidw,'%d %d %d\n',cell2mat(B));
fprintf(fidw,wfmt,Elem');

fclose(fidw);



