% updating mesh elevation with z from ArcMap
% This is the 1st step - Reading the existing mesh:
% [extract_xy_from_mesh.m]


% this is a variation of the code to updated bathy for a partial area
% defined by a shape polygon file
% [extract_xy_from_mesh_inpolygon.m]

clear all
close all
home
%% read configuration file
fic = fopen('extract_xy_from_mesh_inpolygon.cfg');
fgetl(fic);
mesh_path = fgetl(fic);
fgetl(fic);
mesh_name = fgetl(fic);
fgetl(fic);
shp_path = fgetl(fic);
fgetl(fic);
shp_name = fgetl(fic);
fgetl(fic);
polygon_num = str2double(fgetl(fic));

%% read mesh file
% mesh_path = 'L:\UTIL\Temp\mesh\Mesh_works\mesh';
% mesh_name = 'mesh_v24_new_v4.mesh';
fid = fopen(fullfile(mesh_path,mesh_name));
[A Node B Elem] = fun_read_mesh_as_text(fid);
% A     : serial number for Nodes
% Node  : vertices of triangle [serial_num easting northing z boundary_code]
% B     : serial number for Elements
% Elem  : Elements, i.e. triangles or quadrilaterals [serial_num Node_numbers (3 or 4 columns)]
fclose(fid);

%% read shp file
% shp_path = 'L:\UTIL\Temp\mesh\GIS\shp';
S = shaperead(fullfile(shp_path,shp_name));
% specify which polygon
% polygon_num = 10;

in = inpolygon(Node(:,2),Node(:,3),S(polygon_num).X(1:end-1),S(polygon_num).Y(1:end-1));

plot(S(polygon_num).X,S(polygon_num).Y,'r')
hold on
plot(Node(in,2),Node(in,3),'.')

%% write x,y for 'NODE'
% fidw = fopen(sprintf('%s_xy.txt',mesh_name),'wt');
% fprintf(fidw,'x,y\n');
% fprintf(fidw,'%.3f,%.3f\n',[Node(:,2) Node(:,3)]');
% fclose(fidw);
xyz_poly_in = fopen(sprintf('xyz_inside_shp_from_%s.txt',mesh_name(1:end-5)),'wt');
fprintf(xyz_poly_in,'id,x,y\n');
fprintf(xyz_poly_in,'%d,%.3f,%.3f\n',[Node(in,1) Node(in,2) Node(in,3)]');
