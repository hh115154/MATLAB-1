clear all; close all

% read OBS data for TUFLOW

cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\OBS data')

f1 = 'Fremont_Spills_WDL+cdec.csv';
f2 = 'Fremont_Westend_A02170_LT_stage_NAVD88.csv';
f3 = 'Sac_R_Verona_daily_flows.csv';
f4 = 'YBY_stage_ft_NAVD88.csv';

%%

fid1 = fopen(f1);
freQ = textscan(fid1,'%s%f','delimiter',',','headerlines',1);

% this file is ok
fid2 = fopen(f2);
freH = textscan(fid2,'%s%f','delimiter',',','headerlines',1);


fid3 = fopen(f3);
vonQ = textscan(fid3,'%s%f','delimiter',',','headerlines',1);

fid4 = fopen(f4);
ybyH = textscan(fid4,'%s%f','delimiter',',','headerlines',1);

fclose('all');
