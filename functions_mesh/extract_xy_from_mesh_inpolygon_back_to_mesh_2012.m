% updating mesh elevation with z from ArcMap
% This is the 1st step - Reading the existing mesh:
% [extract_xy_from_mesh.m]

% this is a variation of the code to updated bathy for a partial area
% defined by a shape polygon file
% [extract_xy_from_mesh_inpolygon.m]

% this is the step where the output from ArcMap dbf -> excel -> csv
% gets reinserted back into the mesh
% [extract_xy_from_mesh_inpolygon_back_to_mesh.m]

clear all
close all
home
%% read configuration file
fic = fopen('extract_xy_from_mesh_inpolygon_back_to_mesh.cfg');
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
csv_fn = fgetl(fic);

fclose(fic);

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

%% read xy file that has 'index'
% this is an output from [extract_xy_from_mesh_inpolygon.m]
% xy_fn = 'xyz_inside_shp_from_Mesh_v68_3rd_code_1_ss4x_revised.txt';

fixy = fopen(fullfile(xy_path,xy_fn));
XY = textscan(fixy,'%f%f%f','delimiter',',','headerlines',1);
% [ID, X, Y]

fclose(fixy);

%% read bathymetry updated csv file from ArcMap (dbf->csv)
% csv_fn = 'Stairstep_mesh_elevations.csv';

ficsv = fopen(fullfile(csv_path,csv_fn));
CSV = textscan(ficsv,'%f%f%f','delimiter',',','headerlines',1);
% [X, Y, Z]

fclose(ficsv);

%% Compare xy and csv coordinates

if all(XY{2}==CSV{1}) && all(XY{3}==CSV{2})
    fprintf(1,'%s\n','Mesh index checks out!')
    
    %% Update elevation in mesh
    Node(XY{1},4) = CSV{3};
        
    %% write a NEW mesh
    new_mesh_name = [mesh_name(1:end-5) '_UPDATED.mesh'];
    fidw = fopen(fullfile(mesh_path,new_mesh_name),'wt');
    a1 = A{1}; % total number of nodes
    a2 = A{2}{1};      % text info about projection, unit and etc.
    
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
    
    
    
else
    fprintf(1,'%s','Revisit the mesh configuration.\n')
end

