function fun_Update_dfsu_inPolygon_shp(shp_name,shp_item,new_ManningM)
% modify the code of [write_dfsu_2D_2012.m] for changing channel M values

% based on [change_ManningM_for_SacR.m] in Prospect Island project
% sjb, 4/22/13

NET.addAssembly('DHI.Generic.MikeZero.DFS');
import DHI.Generic.MikeZero.DFS.*;

% Modify and write changes to 2D dfsu file
% cd('C:\Work\60196360.001 Quartz_Hill\Modeling\output')
% cd('C:\Work\Desert_Flow\Modeling\Victor_Phalen\output')
% filename = 'Output_whole_mesh9_METERS_higher_drain_feet.dfsu';

%% select original file
[orig_filename,filepath] = uigetfile('*.dfsu','Select the .dfsu file to analyse');
infile = [filepath,orig_filename];

cd(filepath)
%% renaming the new file
NEW_filename = sprintf('%s_updated.dfsu',orig_filename(1:end-5));

% name of the NEW file
% filename = 'Output_whole_mesh9_METERS_New_topo_Pipe66_horiz_feet.dfsu';
% NEW_filename = 'Rosamond_2D_output_WEST_Source_feet.dfsu';
% This example we will show how to update two timesteps of an item, adding
% some sinusoidal "noise". We will handle delete values, such that elements
% having delete value is not updated.

% Copy to a new file, keeping the original intact.
copyfile(orig_filename, NEW_filename);

% Load existing dfsu 2D file for editing 
dfsu2 = DfsFileFactory.DfsuFileOpenEdit(NEW_filename);

% Node coordinates
xn = double(dfsu2.X);
yn = double(dfsu2.Y);
zn = double(dfsu2.Z);

% Create element table in Matlab format
tn = mzNetFromElmtArray(dfsu2.ElementTable);
% also calculate element center coordinates
[x,y,z] = mzCalcElmtCenterCoords(tn,xn,yn,zn);

deleteval = double(single(1e-35));
Total_time = dfsu2.NumberOfTimeSteps;

converting_item = 1;

%% Writing data
existing_M = 50;
% new_M = 1/0.03;
new_M = 1/new_ManningM;

i=0;
itemData = dfsu2.ReadItemTimeStep(1,i);
data     = double(itemData.Data)';

% read shp file

% shp_name = '1_Yolo_Mask_for_roughness.shp';
% shp_name = '2_Restore_tidal_marsh.shp';
% shp_name = '3_Tidal_channels.shp';

% shp_item = 1;



S = shaperead(fullfile('shp',shp_name));
in = inpolygon(x,y,S(shp_item).X(1:end-1),S(shp_item).Y(1:end-1));

fprintf(1,'\n')
fprintf(1,'number of items in shp: %d',length(S))
fprintf(1,'\n')

ind50 = data==50;

% xx = data(in);  % all in the polygon
% 
% I = find(xx == existing_M);



% I = find(data == existing_M);
% whos I
% data(in & ind50) = new_M;
data(in) = new_M;
dfsu2.WriteItemTimeStep(1,i,itemData.Time,NET.convertArray(single(data(:))));
dfsu2.Close();
%%
% Save and close file

fprintf('\nFile created: ''%s''\n',NEW_filename);

