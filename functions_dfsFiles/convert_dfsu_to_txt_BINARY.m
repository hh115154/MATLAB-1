function convert_dfsu_to_txt_BINARY(items,nsteps)
% nsteps starts from ZERO (same as MIKE ZERO time step)

tic

% read in dfsu file via matlab toolbox 2011
[filename,filepath] = uigetfile('*.dfsu','Select the .dfsu file to analyse');
infile = fullfile(filepath,filename);

% open the dfsu file
fid = fopen(infile);

%% read mesh info

fprintf(1,'Reading mesh info ...\n')

[Header, ~,~,~] = fun_ReadDfsuHeader_v2012(fid);
% 
% xn = Header.mesh_info(2).data;
% yn = Header.mesh_info(3).data;
% zn = Header.mesh_info(4).data;

% xn = double(dfsu2.X);
% yn = double(dfsu2.Y);
% zn = double(dfsu2.Z);

[~, xe,ye,ze] = fun_CalcElementCenter_binary(Header.mesh_info);


%% Load data
fprintf(1,'Loading data ...\n')

if nargin < 2
    nsteps = Header.Time_info.nstep-1; % the last time step
end

Data = fun_ReadItemTimeStep(fid,items,nsteps);
value = Data.data';

fclose(fid);

% items = 3; % total water depth
item_name = Data.name;
item_name = regexprep(item_name,' ','_');


%% write to txt (ASCII)
fidw = fopen(sprintf('%s_xyz.txt',filename(1:end-5)),'wt');
fprintf(fidw,'x,y,z\n');
fprintf(fidw,'%.3f,%.3f,%.4f\n',[xe ye value]');
fclose(fidw);





% %% read mesh info
% 
% fprintf(1,'Reading mesh info ...\n')
% 
% xn = double(dfsu2.X);
% yn = double(dfsu2.Y);
% zn = double(dfsu2.Z);
% 
% tn = mzNetFromElmtArray(dfsu2.ElementTable); % Create element table in Matlab format
% 
% [xe,ye,ze] = mzCalcElmtCenterCoords(tn,xn,yn,zn);
% 
% %%
% h = double(dfsu2.ReadItemTimeStep(items,nsteps-1).Data)';  % items = 1: WSE
% 
% 
% NtoE = [];
% 
% [hn,NtoE] = mzCalcNodeValues(tn,xn,yn,h,xe,ye,NtoE);
% 
% %% write x,y,hn
% fidw = fopen(sprintf('%s_xyZ.txt',filename(1:end-5)),'wt');
% fprintf(fidw,'x,y,z\n');
% fprintf(fidw,'%.3f,%.3f,%.4e\n',[xn' yn' hn']');
% fclose(fidw);
% 

disp('end')
toc

