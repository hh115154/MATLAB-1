function fun_ReplaceMesh_Bndry_ValueInPolygon_usingAttr(cfg)

% Replace mesh node values using polygon shp
% sjb, 1/14/2013

%{
1. Read Mesh (v2012)
2. Apply shp polygon file and use [inpolygon]
3. convert node inside each polygon into a new value
4. write a new mesh
%}

% sjb, 5/8/2013
% Edit [mesh_value_replace_Network23_usingAttr.cfg] in Yolo project folder
% This script uses 'for' loop for all shp attribute items at once

%% Read cfg file
if nargin < 1
[fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');  

%
% example ----  C:\Work\12-1016_Yolo_Ranch\New_Mesh\mesh_value_replace.cfg
% in this cfg, there are some placeholders not being used by the code.
%

else
   [pn,fn,ext] = fileparts(cfg);
   fn = [fn ext];
end
tic
fidc = fopen(fullfile(pn,fn));

C_cfg = textscan(fidc,'%s','delimiter',sprintf('\n'));

path_mesh  = C_cfg{1}{2};
fn_mesh    = C_cfg{1}{4};
NA_t_IC         = C_cfg{1}{6};

NA_fn_IC_user = C_cfg{1}{8};
NA_fn_IC = sprintf('%s%s.dfsu',NA_fn_IC_user(1:end-5),NA_t_IC);

NA_path_IC_dfsu = C_cfg{1}{10};
NA_fn_IC_dfsu   = C_cfg{1}{12};

path_shp     = C_cfg{1}{14};
fn_shp       = C_cfg{1}{16};
% item_shp     = str2double(C_cfg{1}{18});
% NEWvalue      = str2double(C_cfg{1}{20});

fclose(fidc);
cd(path_mesh)

%% 1. Read mesh
fido = fopen(fullfile(path_mesh,fn_mesh));  % open mesh output file
[A Node B Elem] = fun_read_mesh_as_text_v2012(fido);
fclose(fido);

xn = Node(:,2);
yn = Node(:,3);

%% 2-1. sort the center of elements
% [Elmt, xe, ye, ze] = fun_CalcElementCenter_binary(Header.mesh_info);


%% 2-2. shp masking
S = shaperead(fullfile(path_shp,fn_shp));

%% loop for the number of attribute item in shp

for item_shp = 1:length(S)
    in = inpolygon(xn,yn,S(item_shp).X(1:end-1),S(item_shp).Y(1:end-1));
    
    %% 3. convert elements inside polygon
    % zn(in) = NEWvalue;
    Node(in,5) = S(item_shp).new_bndry;
    clear in
end
%% 4. write data back to a template file
%% write a NEW mesh
new_mesh_name = sprintf('%s_bndry%d.mesh',fn_mesh(1:end-5),item_shp);
fidw = fopen(fullfile(path_mesh,new_mesh_name),'wt');
a1 = [A{1} A{2} A{3}]; % total number of nodes
a2 = A{4}{1};      % text info about projection, unit and etc.

siz = size(Elem);

if siz(2) == 4;
    wfmt = '%d %d %d %d\n';
else
    wfmt = '%d %d %d %d %d\n';
end

%     new_fn = sprintf('%s_new_with_TD.mesh',mesh_fn(1:end-5));
%     fidw = fopen(fullfile(xy_loc,new_fn),'wt');
fprintf(fidw,'%d %d %d  %s\n',a1,a2);
fprintf(fidw,'%d %.10f %.10f %.4f %d\n',Node');
fprintf(fidw,'%d %d %d\n',cell2mat(B));
fprintf(fidw,wfmt,Elem');

fclose(fidw);

fclose('all');
toc



