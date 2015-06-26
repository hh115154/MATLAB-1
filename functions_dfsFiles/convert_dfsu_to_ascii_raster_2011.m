function convert_dfsu_to_ascii_raster_2011(plot_item,DfsuName)
% convert dfsu to ascii raster
NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;

close all
% sjb, 6/24/10

%% Open dfsu: flexible mesh grid
if nargin < 2
    [DfsuName, DfsuPath] = uigetfile('*.dfsu', 'MIKE FM Output DFSU File...');
    if nargin < 1
        plot_item = 1;
    end
else
    DfsuPath = pwd;
end
tic
cd(DfsuPath)

% dfsu = dfsManager(fullfile(DfsuPath,DfsuName));
fprintf(1,'Loading dfsu file ...\n')
dfsu2 = DfsFileFactory.DfsuFileOpen(DfsuName);

% % read mesh info (imbedded in dfsu)
% Elmts      = readElmtNodeConnectivity(dfsu);
% tn = mzNetFromElmtArray(dfsu2.ElementTable);
% [xe,ye,ze] = readElmts(dfsu);     % Element center coordinates
% [xn,yn,zn] = readNodes(dfsu);     % Node coordinates
% items      = get(dfsu,'items');
% nsteps     = get(dfsu,'numtimesteps');
% itemnames  = get(dfsu,'ItemNames');

%% read mesh info
xn = double(dfsu2.X);
yn = double(dfsu2.Y);
zn = double(dfsu2.Z);

tn = mzNetFromElmtArray(dfsu2.ElementTable); % Create element table in Matlab format
[xe,ye,ze] = mzCalcElmtCenterCoords(tn,xn,yn,zn);     % Element center coordinates

nsteps = dfsu2.NumberOfTimeSteps;
% item_select = i;
item_name = char(dfsu2.ItemInfo.Item(plot_item-1).Name);
item_name = regexprep(item_name,' ','_');

fprintf(1,'File: %s\n',DfsuName);
%% SELECT DATA TO PLOT, PROCESS or CONVERT TO RASTER
% 
% %{
% 1: surface elevation
% 2: depth
% 5: current speed
% %}
% 
% switch plot_name
%     case 'Surface elevation'
%         pname = 'wse';
%     case 'Total water depth'
%         pname = 'depth';
%     case 'Current speed'  % plot_item = 5
%         pname = 'Spd';
% end

% data_Last = dfsu(plot_item,nsteps-1-2);  % read the LAST time step
data_Last = double(dfsu2.ReadItemTimeStep(plot_item,nsteps-1).Data)';
% % 17B crashed - use 3rd to the last time step
% close(dfsu)

fprintf(1,'Item processed: %s\n',item_name);

dfsu2.Close();

%% convert into cartesian grid
method = 'nearest';
fXYZg = [xe ye ze]; 
% Axis_box = [613960 625810 4245215 4291805];
% dx = 790; dy = 3106;  % cell size 15 meters
% xllcorner = 613960;
% yllcorner = 4245215;
% 
% dx = [15 10]; dy = dx;
% ncols = [790 1185];
% nrows = [3106 4659];

%% raster dimension calculation
dx = 5;
dy = dx;

xllcorner = floor(min(xn));
yllcorner = floor(min(yn));

x_domain_length = max(xn) - min(xn);
y_domain_length = max(yn) - min(yn);

ncols = ceil((x_domain_length)/dx);
nrows = ceil((y_domain_length)/dy);

if floor(min(xn)) + ncols*dx < ceil(max(xn))
    disp('error in ncols')
end


% xllcorner = 2132094;
% yllcorner = 662786.021;
% dx = 10;
% dy = 10;
% ncols = 1431; nrows = 929;

%% select cell size
% 1: 15 meters / 2: 10 meters
csize = 1;

bound_box = [xllcorner xllcorner+ncols(csize)*dx(csize) ...
    yllcorner yllcorner+nrows(csize)*dy(csize)];

[x,y,z] = FM2rect_2011(fXYZg,data_Last,bound_box,ncols(csize),nrows(csize),method);
z(isnan(z))=-9999; % replacing NaN with NoDATA value, -9999
z(abs(z)<1e-34) = -9999;

%% mask z with a polygon to remove 'ghost' cells, byproduct of interpolation
shp_path = 'C:\Work\Desert_Flow\Modeling_Beacon_Site\Beacon\shp';
shp_name = 'Beacon_mesh_outline.shp';
% 
S = shaperead(fullfile(shp_path,shp_name));
in = inpolygon(x,y,S(1).X(1:end-1),S(1).Y(1:end-1));

z(~in) = -9999;

%% write ASC raster file 
z = flipud(z);

% cd('ASC_raster\')
% txt_fname = sprintf('%s_at_Nodes_%s.txt',DfsuName(1:end-5),pname);
asc_fname = sprintf('%s_%s_%s_raster_%dm.asc',DfsuName(1:end-5),item_name,method,dx(csize));
fidw = fopen(asc_fname,'wt');

% write header
fprintf(fidw,'ncols         %d\n',ncols(csize));
fprintf(fidw,'nrows         %d\n',nrows(csize));
fprintf(fidw,'xllcorner     %d\n',xllcorner);
fprintf(fidw,'yllcorner     %d\n',yllcorner);
fprintf(fidw,'cellsize      %d\n',dx(csize));
fprintf(fidw,'NODATA_value  %d\n',-9999);

% write data
for CurrRow = 1:nrows(csize)
    fprintf(fidw,'%g ',z(CurrRow,:));
    fprintf(fidw,'%s\n', ' ');
    
end

fclose(fidw);
end_time_sec = toc;
fprintf(1,'elapsed time: %.2f min\n',end_time_sec/60)


%% ArcMap Command Line usage
%{
USE command below to automate the conversion in ArcMap

ASCIIToRaster C:\Work\Projects\10-XXXX_BDCP_Modeling\Modeling\output\ASC_raster\RUN15A_2D_raster.asc C:\Work\Projects\10-XXXX_BDCP_Modeling\GIS\rasters\run15_wse FLOAT
%}