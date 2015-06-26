function convert_dfsu_to_polygon_shp_BINARY_2013_v2(items,nsteps)

% Convert dfsu -> shp polygon using BINARY reading
% nsteps starts from ZERO (same as MIKE ZERO time step)
% 5/13/2013, sjb

tic

[filename,filepath] = uigetfile('*.dfsu','Select the .dfsu file to analyse');
infile = fullfile(filepath,filename);

% open the dfsu file
fid = fopen(infile);

%% read mesh info

fprintf(1,'Reading mesh info ...\n')

[Header, ~,~,~] = fun_ReadDfsuHeader_v2012(fid);

xn = Header.mesh_info(2).data;
yn = Header.mesh_info(3).data;

% xn = double(dfsu2.X);
% yn = double(dfsu2.Y);
% zn = double(dfsu2.Z);

[tn, ~,~,~] = fun_CalcElementCenter_binary(Header.mesh_info);

% tn_v = mzNetFromElmtArray(dfsu2.ElementTable); % Create element table in Matlab format
% [xe,ye,ze] = mzCalcElmtCenterCoords(tn,xn,yn,zn);     % Element center coordinates

%% Load data
fprintf(1,'Loading data ...\n')

if nargin < 2
    nsteps = Header.Time_info.nstep-1; % the last time step
end

Data = fun_ReadItemTimeStep(fid,items,nsteps);

% items = 3; % total water depth
item_name = Data.name;
item_name = regexprep(item_name,' ','_');


depth_threshold = NaN;


% h = double(dfsu2.ReadItemTimeStep(items,nsteps-1).Data)'; %Item 1 = surface elevation
h = Data.data';


if isnan(depth_threshold) 
    % FILTER 1: remove delete value, -1e-35
    h(abs(h)<eps) = NaN;
else
    % FILTER 2: Apply depth threshold
    h(abs(h)<eps | h>depth_threshold) = NaN;
end

idh = ~isnan(h);
tn_v = tn(idh,:);  % only with valid numbers -- 3 2 4 0 / 6123 6124 6125 6126 / ...
% index for Node numbers
% tn_v = tn;

% dfsu2.Close();

%% identify with 4 nodes - quadrilaterals
calc_xn = xn'; %transpose xn to work in assignments below
calc_yn = yn'; %transpose yn to work in assignments below

%% build shp file structure
Xcell = cell(size(tn,1),1);
Ycell = cell(size(tn,1),1);
BoundingBox = cell(size(tn,1),1);
valueH = num2cell(h);

if size(tn,2) == 3
    Node_x = zeros(length(tn),3);
    Node_x(:,1:3) = [calc_xn(tn(:,1)) calc_xn(tn(:,2)) calc_xn(tn(:,3))];
    
    Node_y = zeros(length(tn),3);
    Node_y(:,1:3) = [calc_yn(tn(:,1)) calc_yn(tn(:,2)) calc_yn(tn(:,3))];
    idtr = 1:length(tn);
    
    for i = 1:length(idtr)
        Xcell{idtr(i)} = [Node_x(idtr(i),[1:3 1]) nan];
        Ycell{idtr(i)} = [Node_y(idtr(i),[1:3 1]) nan];
        BoundingBox{idtr(i)} = [min(Xcell{idtr(i)}) min(Ycell{idtr(i)}); ...
            max(Xcell{idtr(i)}) max(Ycell{idtr(i)})];
        %     Xcell(idtr) = [Node_x(idtr,[1:3 1]) nan(length(idtr),1)];
    end

else
    idqd = find(tn(:,4)~=0);
    idtr = find(tn(:,4)==0);
    
    Node_x = zeros(length(tn),4);
    Node_x(idtr,1:3) = [calc_xn(tn(idtr,1)) calc_xn(tn(idtr,2)) calc_xn(tn(idtr,3))];
    Node_x(idqd,:) = [calc_xn(tn(idqd,1)) calc_xn(tn(idqd,2)) calc_xn(tn(idqd,3)) calc_xn(tn(idqd,4))];
    
    Node_y = zeros(length(tn),4);
    Node_y(idtr,1:3) = [calc_yn(tn(idtr,1)) calc_yn(tn(idtr,2)) calc_yn(tn(idtr,3))];
    Node_y(idqd,:) = [calc_yn(tn(idqd,1)) calc_yn(tn(idqd,2)) calc_yn(tn(idqd,3)) calc_yn(tn(idqd,4))];
    
    % %% read variable info
    % % item
    % item_num = dfsu2.ItemInfo.Count;
    
%% Calculate Area of cells
% % area of triangles
A(idtr) = ((Node_x(idtr,1).*Node_y(idtr,2)+Node_x(idtr,2).*Node_y(idtr,3)+Node_x(idtr,3).*Node_y(idtr,1)) ...
    -(Node_x(idtr,2).*Node_y(idtr,1)+Node_x(idtr,3).*Node_y(idtr,2)+Node_x(idtr,1).*Node_y(idtr,3)))/2;
% 
% % area of quadrilaterals: ((x1*y2+x2*y3+x3*y4+x4*y1)-(x2*y1+x3*y2+x4*y3+x1*y4))/2
A(idqd) = ((Node_x(idqd,1).*Node_y(idqd,2)+Node_x(idqd,2).*Node_y(idqd,3)+ ...
    Node_x(idqd,3).*Node_y(idqd,4)+Node_x(idqd,4).*Node_y(idqd,1))- ...
    (Node_x(idqd,2).*Node_y(idqd,1)+Node_x(idqd,3).*Node_y(idqd,2)+ ...
    Node_x(idqd,4).*Node_y(idqd,3)+Node_x(idqd,1).*Node_y(idqd,4)))/2;

A = abs(A);
valueA = num2cell(A');

% A_v = A(idh);
A_v = A;
A_v(~idh) = 0;
validA = num2cell(A_v');

% totalA = sum(A);
%%   
    
    %{
---> BCalc = [min(SW(1).X) min(SW(1).Y);
max(SW(1).X) max(SW(1).Y)];
    %}
    
    for i = 1:length(idtr)
        Xcell{idtr(i)} = [Node_x(idtr(i),[3:-1:1 3]) nan];
        Ycell{idtr(i)} = [Node_y(idtr(i),[3:-1:1 3]) nan];
        BoundingBox{idtr(i)} = [min(Xcell{idtr(i)}) min(Ycell{idtr(i)}); ...
            max(Xcell{idtr(i)}) max(Ycell{idtr(i)})];
        %     Xcell(idtr) = [Node_x(idtr,[1:3 1]) nan(length(idtr),1)];
    end
    
    
    for j = 1:length(idqd)
        Xcell{idqd(j)} = [Node_x(idqd(j),[4:-1:1 4]) nan];
        Ycell{idqd(j)} = [Node_y(idqd(j),[4:-1:1 4]) nan];
        BoundingBox{idqd(j)} = [min(Xcell{idqd(j)}) min(Ycell{idqd(j)}); ...
            max(Xcell{idqd(j)}) max(Ycell{idqd(j)})];
    end
end

toc

%% Write shape file
S(1:size(tn,1),1) = struct('Geometry','Polygon','BoundingBox',BoundingBox, ...
    'X',Xcell,'Y',Ycell,'Id',0,'value',valueH,'Area_m2',valueA,'Area_inun',validA);

item_name = Header.Item(items).name(1:end-1);
item_name = regexprep(item_name,' ','_');
shp_name = sprintf('%s_item%d_%s.shp',filename(1:end-5),items,item_name);
% shp_name = sprintf('shp\\%s_item%d.shp',filename(1:end-5),items);
shapewrite(S,fullfile([filepath 'shp'],shp_name))

% S(idtr).X = 
toc