function convert_dfsu_to_txt(items,nsteps)

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

tn = mzNetFromElmtArray(dfsu2.ElementTable); % Create element table in Matlab format

[xe,ye,ze] = mzCalcElmtCenterCoords(tn,xn,yn,zn);

%%
h = double(dfsu2.ReadItemTimeStep(items,nsteps-1).Data)';  % items = 1: WSE


NtoE = [];

[hn,NtoE] = mzCalcNodeValues(tn,xn,yn,h,xe,ye,NtoE);

%% write x,y,hn
fidw = fopen(sprintf('%s_xyZ.txt',filename(1:end-5)),'wt');
fprintf(fidw,'x,y,z\n');
fprintf(fidw,'%.3f,%.3f,%.4e\n',[xn' yn' hn']');
fclose(fidw);


disp('end')
toc

