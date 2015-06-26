clear all;close all

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
NEW_filename = sprintf('%s_feet.dfsu',orig_filename(1:end-5));

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

converting_item = 2;

for i=0:Total_time-1
    % Read first time step from file
    itemData = dfsu2.ReadItemTimeStep(converting_item,i); %(n,m), n:item m:time step
    data     = double(itemData.Data)';
    % Do not consider elements with delete value
    I        = find(data ~= deleteval);
    % Calculate new values
%     data(I)  = data(I) - 0.01*cos(0.0005*x(I)).*cos(0.0003*y(I));
    data(I) = data(I).*3937/1200;
    % Write to memory
    dfsu2.WriteItemTimeStep(converting_item,i,itemData.Time,NET.convertArray(single(data(:))));
end

% Save and close file
dfsu2.Close();

fprintf('\nFile created: ''%s''\n',NEW_filename);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % The remaining part is just plotting.
% 
% % Now plot and check the difference between the original and the modified
% % file.
% clf, shg
% %-----------------------------------------
% dfsu2a = DfsFileFactory.DfsuFileOpen('data/data_oresund_2D.dfsu');
% 
% t       = mzTriangulateElmtCenters(x,y,tn);
% data0   = double(dfsu2a.ReadItemTimeStep(1,0).Data);
% data1   = double(dfsu2a.ReadItemTimeStep(1,1).Data);
% dfsu2a.Close();
% 
% % Remove delete values from plot
% data0(data0 == deleteval) = NaN;
% data1(data1 == deleteval) = NaN;
% 
% subplot(2,2,1)
% trimesh(t,x,y,data0)
% %shading interp
% title('original, first timestep')
% axis tight
% subplot(2,2,2)
% trimesh(t,x,y,data1)
% %shading interp
% title('original, second timestep')
% axis tight
% 
% %-----------------------------------------
% dfsu2b = DfsFileFactory.DfsuFileOpen(filename);
% 
% data0   = double(dfsu2b.ReadItemTimeStep(1,0).Data);
% data1   = double(dfsu2b.ReadItemTimeStep(1,1).Data);
% dfsu2b.Close()
% 
% % Remove delete values from plot
% data0(data0 == deleteval) = NaN;
% data1(data1 == deleteval) = NaN;
% 
% subplot(2,2,3)
% trimesh(t,x,y,data0)
% %shading interp
% title('modified, first timestep')
% axis tight
% subplot(2,2,4)
% trimesh(t,x,y,data1)
% %shading interp
% title('modified, second timestep')
% axis tight
% 
% 
