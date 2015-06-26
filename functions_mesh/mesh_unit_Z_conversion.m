% to convert mesh horizontal units from feet to meters
clear all
close all

% cd('C:\Work\60196360.001 Quartz_Hill\Modeling\mesh')
xy_loc = pwd;

%% write the mesh back to the MIKE format

% read mesh file first

% xy_loc = '/Users/sjbaek/WORK/cbec/Mesh_works';
% mesh_fn = 'mesh_QH_v9_new_with_Z_feet.mesh';
mesh_fn = 'MESH_T4_dtu071013_test.mesh';
fidm = fopen(fullfile(xy_loc,mesh_fn));
[A Node B Elem] = fun_read_mesh_as_text_v2012(fidm);
% A     : serial number for Nodes
% Node  : vertices of triangle
% B     : serial number for Elements
% Elem  : Elements, i.e. triangles or quadrangles
fclose(fidm);


%% Write mesh back after unit conversion.

% Node(:,2:3) = Node(:,2:3).*1200/3937;
% Node(:,2:3) = Node(:,2:3)./1200*3937;   % horizontal unit change
Node(:,4) = Node(:,4).*1200/3937;         % vertical unit change
a1 = A{3}; % total number of nodes
a2 = A{4}{1};      % text info about projection, unit and etc.

siz = size(Elem);

if siz(2) == 4;
    wfmt = '%d %d %d %d\n';
else
    wfmt = '%d %d %d %d %d\n';
end

new_fn = sprintf('%s_meter.mesh',mesh_fn(1:end-5));
fidw = fopen(fullfile(xy_loc,new_fn),'wt');
fprintf(fidw,'%d  %s\n',a1,a2);
fprintf(fidw,'%d %.10f %.10f %.4f %d\n',Node');
fprintf(fidw,'%d %d %d\n',cell2mat(B));
fprintf(fidw,wfmt,Elem');

fclose(fidw);