% updating mesh elevation with z from ArcMap
% This is the 1st step - Reading the existing mesh

% ---------------------------------------------------------------
% _v2012: only compatible with mesh created by MIKE 2012 version

clear all
close all


%% read mesh file
[mesh_name, mesh_path]=uigetfile('*.mesh','Select mesh to read...');

% mesh_ = 'mesh_QH_v4.mesh';
fid = fopen(fullfile(mesh_path,mesh_name));
[A Node B Elem] = fun_read_mesh_as_text_v2012(fid);
% A     : serial number for Nodes
% Node  : vertices of triangle
% B     : serial number for Elements
% Elem  : Elements, i.e. triangles or quadrangles
fclose(fid);


%% write x,y for 'NODE'
fidw = fopen(sprintf('%s_xy.txt',mesh_name(1:end-5)),'wt');
fprintf(fidw,'x,y\n');
fprintf(fidw,'%.3f,%.3f\n',[Node(:,2) Node(:,3)]');
fclose(fidw);