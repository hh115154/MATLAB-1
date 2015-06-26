% converting mesh to polygon shp file (ArcGIS)
%  - originally written for comparing mesh coordinate shifting
%  - 2/19/2012, sjb

clear all; close all;
%% read mesh
tic
fprintf(1,'Loading mesh ...\n')

[mesh_name, mesh_path]=uigetfile('*.mesh','Select mesh to read...');
% mesh_name = 'Validation_v52_rev2.mesh';
% mesh_path = 'C:\Work\cbec\Mesh_Shift_CC2SB_021712';

fid = fopen(fullfile(mesh_path,mesh_name));
[A Node B Elem] = fun_read_mesh_as_text(fid);
% A     : serial number for Nodes
% Node  : ID, X, Y, elevation, boundary code (5 column matrix)
% B     : serial number for Elements
% Elem  : Elements, i.e. triangles or quadrangles

fclose(fid);

%% Convert mesh info into the template previously written for dfsu conversion

calc_xn = Node(:,2); 
calc_yn = Node(:,3);
tn_v = Elem(:,2:end);

fprintf(1,'Calculating element coordinates ...\n')

h = Node(:,4);
item_name = 'mesh';
[~,~,he] = mzCalcElmtCenterCoords(tn_v,calc_xn',calc_yn',h');


%% Use the old code for dfsu conversion

% build shp file structure
Xcell = cell(size(tn_v,1),1);
Ycell = cell(size(tn_v,1),1);
BoundingBox = cell(size(tn_v,1),1);
valueH = num2cell(he);

if size(tn_v,2) == 3
    Node_x = zeros(length(tn_v),3);
    Node_x(:,1:3) = [calc_xn(tn_v(:,1)) calc_xn(tn_v(:,2)) calc_xn(tn_v(:,3))];
    
    Node_y = zeros(length(tn_v),3);
    Node_y(:,1:3) = [calc_yn(tn_v(:,1)) calc_yn(tn_v(:,2)) calc_yn(tn_v(:,3))];
    idtr = 1:length(tn_v);
    
    for i = 1:length(idtr)
        Xcell{idtr(i)} = [Node_x(idtr(i),[1:3 1]) nan];
        Ycell{idtr(i)} = [Node_y(idtr(i),[1:3 1]) nan];
        BoundingBox{idtr(i)} = [min(Xcell{idtr(i)}) min(Ycell{idtr(i)}); ...
            max(Xcell{idtr(i)}) max(Ycell{idtr(i)})];
        %     Xcell(idtr) = [Node_x(idtr,[1:3 1]) nan(length(idtr),1)];
    end

else
    idqd = find(tn_v(:,4)~=0);
    idtr = find(tn_v(:,4)==0);
    
    Node_x = zeros(length(tn_v),4);
    Node_x(idtr,1:3) = [calc_xn(tn_v(idtr,1)) calc_xn(tn_v(idtr,2)) calc_xn(tn_v(idtr,3))];
    Node_x(idqd,:) = [calc_xn(tn_v(idqd,1)) calc_xn(tn_v(idqd,2)) calc_xn(tn_v(idqd,3)) calc_xn(tn_v(idqd,4))];
    
    Node_y = zeros(length(tn_v),4);
    Node_y(idtr,1:3) = [calc_yn(tn_v(idtr,1)) calc_yn(tn_v(idtr,2)) calc_yn(tn_v(idtr,3))];
    Node_y(idqd,:) = [calc_yn(tn_v(idqd,1)) calc_yn(tn_v(idqd,2)) calc_yn(tn_v(idqd,3)) calc_yn(tn_v(idqd,4))];
    
    % %% read variable info
    % % item
    % item_num = dfsu2.ItemInfo.Count;
    
    
    
    %{
---> BCalc = [min(SW(1).X) min(SW(1).Y);
max(SW(1).X) max(SW(1).Y)];
    %}
    
    for i = 1:length(idtr)
        Xcell{idtr(i)} = [Node_x(idtr(i),[1:3 1]) nan];
        Ycell{idtr(i)} = [Node_y(idtr(i),[1:3 1]) nan];
        BoundingBox{idtr(i)} = [min(Xcell{idtr(i)}) min(Ycell{idtr(i)}); ...
            max(Xcell{idtr(i)}) max(Ycell{idtr(i)})];
        %     Xcell(idtr) = [Node_x(idtr,[1:3 1]) nan(length(idtr),1)];
    end
    
    
    for j = 1:length(idqd)
        Xcell{idqd(j)} = [Node_x(idqd(j),[1:4 1]) nan];
        Ycell{idqd(j)} = [Node_y(idqd(j),[1:4 1]) nan];
        BoundingBox{idqd(j)} = [min(Xcell{idqd(j)}) min(Ycell{idqd(j)}); ...
            max(Xcell{idqd(j)}) max(Ycell{idqd(j)})];
    end
end

fprintf(1,'Writing the mesh shp polygon file ...\n')


%% Write shape file
S(1:size(tn_v,1),1) = struct('Geometry','Polygon','BoundingBox',BoundingBox,'X',Xcell,'Y',Ycell,'Id',0,'value',valueH);

shp_name = sprintf('%s_%s.shp',mesh_name(1:end-5),item_name);

shapewrite(S,fullfile(mesh_path,shp_name))

toc
