function convert_dfsu_to_polygon_shp(items,nsteps)

% Convert dfsu to xyz + variable text file (csv)
tic

% read in dfsu file via matlab toolbox 2011
NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;

[filename,filepath] = uigetfile('*.dfsu','Select the .dfsu file to analyse');
infile = fullfile(filepath,filename);

dfsu2 = DfsFileFactory.DfsuFileOpen(infile);

%% read mesh info

fprintf(1,'Reading mesh info ...\n')

xn = double(dfsu2.X);
yn = double(dfsu2.Y);
% zn = double(dfsu2.Z);

tn_v = mzNetFromElmtArray(dfsu2.ElementTable); % Create element table in Matlab format
% [xe,ye,ze] = mzCalcElmtCenterCoords(tn,xn,yn,zn);     % Element center coordinates

%% Load data
fprintf(1,'Loading data ...\n')

% items = 3; % total water depth
item_name = char(dfsu2.ItemInfo.Item(items-1).Name);
item_name = regexprep(item_name,' ','_');

if nargin < 2
    nsteps = dfsu2.NumberOfTimeSteps; % the last time step
end

depth_threshold = 100;


h = double(dfsu2.ReadItemTimeStep(items,nsteps-1).Data)'; %Item 1 = surface elevation
  
if isnan(depth_threshold) 
    % FILTER 1: remove delete value, -1e-35
    h(abs(h)<eps) = NaN;
else
    % FILTER 2: Apply depth threshold
    h(abs(h)<eps | h>depth_threshold) = NaN;
end

% idh = ~isnan(h);
% tn_v = tn(idh,:);  % only with valid numbers -- 3 2 4 0 / 6123 6124 6125 6126 / ...
% index for Node numbers
% tn_v = tn;

dfsu2.Close();

%% identify with 4 nodes - quadrilaterals
calc_xn = xn'; %transpose xn to work in assignments below
calc_yn = yn'; %transpose yn to work in assignments below

%% build shp file structure
Xcell = cell(size(tn_v,1),1);
Ycell = cell(size(tn_v,1),1);
BoundingBox = cell(size(tn_v,1),1);
valueH = num2cell(h);

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

toc

%% Write shape file
S(1:size(tn_v,1),1) = struct('Geometry','Polygon','BoundingBox',BoundingBox,'X',Xcell,'Y',Ycell,'Id',0,'value',valueH);

shp_name = sprintf('%s_%s.shp',filename(1:end-5),item_name);

shapewrite(S,fullfile(filepath,shp_name))

% S(idtr).X = 
