clear all; close all; home
tic

global st_name st_num PathName
if ispc
    FileName_setup = 'RDI_Setup_Telog.xlsx';
else
    FileName_setup = 'RDI_Setup_Telog.xls';
end

PathName_setup = pwd;

if ~exist(FileName_setup,'file')
    
    [FileName_setup,PathName_setup] = uigetfile( ...
        {'*.inp;*.xlsx;*.xls','RDI Setup Files (*.inp,*.xlsx,*.xls)';
        '*.inp',  'Code files (*.m)'; ...
        '*.xlsx','Figures (*.fig)'; ...
        '*.xls','MAT-files (*.mat)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Pick a Setup file');
end

cd(PathName_setup)

% PathName = 'C:\Work\HNL_model\from_ZFM\';

Input = fun_read_RDI_input(FileName_setup,PathName_setup);

%% Read data file
%if data is in excel format
%{

[num,txt]=xlsread('187580.xls');
ind_nan = isnan(num(:,1));

timeseries = datenum(txt(2,1)):5/60/24:datenum(txt(end,1));
%}


% if data is in csv format

%% Dry Weater Flow
%{
1) use old function to analyse DWF
2) overwrite file path and name because new data format include both FM and RG in one file
%}

[RG,FM,DW] = fun_MDW_Calibrate_Telog_v2(Input);

%{
plot(timeseries(~ind_nan),num(~ind_nan,1),'.-')
hold on
plot(timeseries,yi,'ro')
%}
%%
%{


### REMOVE the original gaps (gaps = largerthan 15 minutes) - prevent interpolation for these gaps



1) convert 5 minutes data into the format compatible with [fun_MDW_Calibrate_v2.m]
  1. Input = fun_read_RDI_input.m;

2) 'DW' is the result - dry weather pattern
3) Create csv file; Infoworks format

%}

StormID = fun_storm_identification_Telog(Input,RG);


%% Plot storm
fun_plot_RDI_telog(StormID,RG(3:4),FM(3:4),DW)  % entire data only (exclude summer portions)


toc