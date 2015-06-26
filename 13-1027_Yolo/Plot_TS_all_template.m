clear all; close all
% only when debugging
cd('E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\MATLAB')
%% Read configuration file
[fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');

fidc = fopen(fullfile(pn,fn));
% fidc = fopen(cfg);

C_cfg = textscan(fidc,'%s','delimiter',sprintf('\n'));

path_PO    = C_cfg{1}{2};
item_sel   = C_cfg{1}{4};
image_name = C_cfg{1}{6};
fpath_WT   = C_cfg{1}{8};
fpath_OBS  = C_cfg{1}{10};

fclose(fidc);
%%
cd(path_PO)
% flt_path = pwd;
% 
% s = regexp(pwd,'\','split');
% model_year = str2double(s{end-2});

%%
model_year = 1997:2012;

%% plot setup
% s3 = axes('position',[0.65 0.664 .3 .247]);
close all
hf_1 = figure('position',[110 200 1700 750]);
plot_width = 0.0625;
s = zeros(1,length(model_year));
for k = 1:length(model_year)
    s(k) = axes('position',[0+plot_width*(k-1) 0.1 0.0625 0.8]);
%     s2 = axes('position',[0.0625 0.1 0.0625 0.8]);
    set(s(k),'ytick',[])
end

%% TS: OBS data
OBS = dir([fpath_OBS '\*.mat']);

for j = 1:length(OBS)   % read MAT files for OBS data
    load([fpath_OBS '\' OBS(j).name])
end

%{
variable names
freH_time, freH_data : hourly
freQ_time, freQ_data : daily
vonQ_time, vonQ_data : daily
yby_time, yby_data   : hourly
%}



%% TS: PO files (model results)
line_color = ...
    {'b','r','g','c','k','m','b','r','g','c','k','m','b','r','g','c','k','m'};


        
        
for j = 1:length(model_year)
    
    
    
    %% Figure 1. FREMONT Sim & Obs
    fpath_PO = sprintf('%d',model_year(j));
    
    file_find_str = sprintf('yolo*Exg*%s*.flt',item_sel);
    D = dir([sprintf('%d/NearBypass/grids/',model_year(j)) file_find_str]);
    TS_start = str2double(D(1).name(end-9:end-4));
    TS_end = str2double(D(end-1).name(end-9:end-4));

    
    fname_PO = sprintf('yolo_200ft_Exg_TS6_____%d_PO.csv',model_year(j));
    
    fidPO = fopen(fullfile(fpath_PO,fname_PO));
    readfmt = ['%*s%f' repmat('%*f',1,23) '%f%*f%f%*f%*f%f'];
    PO_Model_data = textscan(fidPO,readfmt,'delimiter',',','headerlines',2);
    fclose(fidPO);
    
    TS_PO_hr = PO_Model_data{1};
    TS_PO = TS_PO_hr(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
    Data_FreWSE_w = PO_Model_data{2}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
    Data_FreWSE_e = PO_Model_data{3}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
    Data_FreQ = PO_Model_data{4}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
    dTS_PO = TS_PO - TS_PO(1);   % time(hour) differences from the 1st entry
    
    % in real time (datenum)
    TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),TS_PO(1),'hour') + dTS_PO./24;
    
    % -----------------
    %% Plot OBS data
    plot(s(j),freQ_time,freQ_data,'--')
    hold(s(j),'on')

    plot(s(j),TS_PO_time,Data_FreQ,line_color{j})   % hourly data from PO.csv file (2D output)

    set(s(j),'xlim',[TS_PO_time(1) TS_PO_time(end)])
































fprintf(1,'year %d processed\n',model_year(j));
end










cd(pn);