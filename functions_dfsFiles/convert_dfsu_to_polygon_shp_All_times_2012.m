%% converting all time steps of dfsu into shp polygon
clear all
close all

%% read cfg file
[cfg_name,cfg_path]=uigetfile('*.cfg','Select a configuration file');

fid = fopen(fullfile(cfg_path,cfg_name));

fgetl(fid);  % header
pn = fgetl(fid);
fn = fgetl(fid);
fgetl(fid);
itemn = str2double(fgetl(fid));

%% read dfsu time steps

[Header_d, ~, ~, ~] = Locate_Data_Block_2012(fullfile(pn,fn));
TOTAL_TIME = Header_d.time_step_all;  % 

for i = 1:3
    convert_dfsu_to_polygon_shp_2012_v2(fullfile(pn,fn),itemn,i);
    fprintf(1,'convert t = %d\n',i);
end