% use two different surface for dbf-csv file
clear all
close all
home
%% read configuration file
fic = fopen('extract_xy_from_mesh_back_to_mesh_Yolo_TWO_surfaces.cfg');

fgetl(fic);
mesh_path = fgetl(fic);
fgetl(fic);
mesh_name = fgetl(fic);
fgetl(fic);

xy_path = fgetl(fic);
fgetl(fic);
xy_fn = fgetl(fic);
fgetl(fic);

csv_path = fgetl(fic);
fgetl(fic);
csv_fn1 = fgetl(fic);
fgetl(fic);
csv_fn2 = fgetl(fic);

fclose(fic);

%% read mesh file
% mesh_path = 'L:\UTIL\Temp\mesh\Mesh_works\mesh';
% mesh_name = 'mesh_v24_new_v4.mesh';
fid = fopen(fullfile(mesh_path,mesh_name));
[A Node B Elem] = fun_read_mesh_as_text_v2012(fid);
% A     : serial number for Nodes
% Node  : vertices of triangle [serial_num easting northing z boundary_code]
% B     : serial number for Elements
% Elem  : Elements, i.e. triangles or quadrilaterals [serial_num Node_numbers (3 or 4 columns)]
fclose(fid);

%% read xy file that does NOT have 'index'
% it reads just xy file: output from [Extract_xy_from_mesh_2012.m]

fixy = fopen(fullfile(xy_path,xy_fn));
XY = textscan(fixy,'%f%f','delimiter',',','headerlines',1);
% [ID, X, Y]

fclose(fixy);

%% read bathymetry updated csv file from ArcMap (dbf->csv)

ficsv1 = fopen(fullfile(csv_path,csv_fn1));
CSV1 = textscan(ficsv1,'%f%f%f%f','delimiter',',','headerlines',1);

fclose(ficsv1);

ficsv2 = fopen(fullfile(csv_path,csv_fn2));
CSV2 = textscan(ficsv2,'%f%f%f%f','delimiter',',','headerlines',1);

fclose(ficsv2);

%% use priority mesh points (csv1)

xy = cell2mat(XY);
csvz1 = cell2mat(CSV1);
csvz1(:,4) = csvz1(:,4).*1200/3937;  % feet to meters
csvz2 = cell2mat(CSV2);


csvz_merge = [];
[~,icsv2,icsv1] = intersect(csvz2(:,3),csvz1(:,3),'rows','stable');
csvz_merge = csvz2;
csvz_merge(icsv2,4) = csvz1(icsv1,4);



[C,ixy,icsv] = intersect(xy,csvz_merge(:,1:2),'rows','stable');
Node(:,4) = -9999;
Node(ixy,4) = csvz_merge(icsv,4);  % if length(xy) > length(csvz) then missing xy coordinates will have -9999


%% write a NEW mesh
new_mesh_name = [mesh_name(1:end-5) '_with_Z.mesh'];
fidw = fopen(fullfile(mesh_path,new_mesh_name),'wt');
a1 = A{3}; % total number of nodes
a2 = A{4}{1};      % text info about projection, unit and etc.

siz = size(Elem);

if siz(2) == 4;
    wfmt = '%d %d %d %d\n';
else
    wfmt = '%d %d %d %d %d\n';
end

%     new_fn = sprintf('%s_new_with_TD.mesh',mesh_fn(1:end-5));
%     fidw = fopen(fullfile(xy_loc,new_fn),'wt');
fprintf(fidw,'%d  %s\n',a1,a2);
fprintf(fidw,'%d %.10f %.10f %.4f %d\n',Node');
fprintf(fidw,'%d %d %d\n',cell2mat(B));
fprintf(fidw,wfmt,Elem');

fclose(fidw);
