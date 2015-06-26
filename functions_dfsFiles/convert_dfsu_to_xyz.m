function convert_dfsu_to_xyz(items,nsteps)

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
zn = double(dfsu2.Z);

tn_v = mzNetFromElmtArray(dfsu2.ElementTable); % Create element table in Matlab format
[xe,ye,ze] = mzCalcElmtCenterCoords(tn_v,xn,yn,zn);     % Element center coordinates

h = double(dfsu2.ReadItemTimeStep(items,nsteps-1).Data)'; %Item 1 = surface elevation

%% write xyz
txt_name = [filename(1:end-5) '.xyz'];
fid = fopen(txt_name,'wt');
fprintf(fid,'%.3f %.3f %.3f\n',[xe ye h]');
fclose(fid);