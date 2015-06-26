% to convert mesh horizontal units from feet to meters
clear all
close all

% cd('C:\Work\60196360.001 Quartz_Hill\Modeling\mesh')
xy_loc = pwd;

%% write the mesh back to the MIKE format

% read mesh file first

% xy_loc = '/Users/sjbaek/WORK/cbec/Mesh_works';
% mesh_fn = 'mesh_QH_v9_new_with_Z_feet.mesh';
mesh_fn = 'Cache_complex_v30_calibration_SJB_v6_Z.mesh';
fidm = fopen(fullfile(xy_loc,mesh_fn));
[A Node B Elem] = fun_read_mesh_as_text(fidm);
% A     : serial number for Nodes
% Node  : vertices of triangle
% B     : serial number for Elements
% Elem  : Elements, i.e. triangles or quadrangles
fclose(fidm);


%% Write mesh back after unit conversion.

% Node(:,2:3) = Node(:,2:3).*1200/3937;
% Node(:,2:3) = Node(:,2:3)./1200*3937;   % horizontal unit change
% Node(:,4) = Node(:,4).*3937/1200;         % vertical unit change

% define M
Node_bathy = Node;

Node(Node_bathy(:,4)<=-13,4) = 1/0.015;
Node(Node_bathy(:,4)>-13  & Node_bathy(:,4)<=-11 ,4) = 1/0.019;
Node(Node_bathy(:,4)>-11  & Node_bathy(:,4)<=-8.5,4) = 1/0.025;
Node(Node_bathy(:,4)>-8.5 & Node_bathy(:,4)<=-6.5,4) = 1/0.027;
Node(Node_bathy(:,4)>-6.5 & Node_bathy(:,4)<=-2  ,4) = 1/0.029;
Node(Node_bathy(:,4)>-2   & Node_bathy(:,4)<=-0.6,4) = 1/0.031;
Node(Node_bathy(:,4)>-0.6 & Node_bathy(:,4)<=-0.1,4) = 1/0.033;
Node(Node_bathy(:,4)>-0.1,4) = 1/0.05;

Node(:,4) = Node(:,4)./0.8; % matching 0.025 to 0.020 (M=50) at Cache

a1 = A{1}; % total number of nodes
a2 = A{2}{1};      % text info about projection, unit and etc.

siz = size(Elem);

if siz(2) == 4;
    wfmt = '%d %d %d %d\n';
else
    wfmt = '%d %d %d %d %d\n';
end

new_fn = sprintf('%s_variable_M.mesh',mesh_fn(1:end-5));
fidw = fopen(fullfile(xy_loc,new_fn),'wt');
fprintf(fidw,'%d  %s\n',a1,a2);
fprintf(fidw,'%d %.10f %.10f %.4f %d\n',Node');
fprintf(fidw,'%d %d %d\n',cell2mat(B));
fprintf(fidw,wfmt,Elem');

fclose(fidw);