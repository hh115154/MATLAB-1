% function Merge_FLUX_dfsu_Main

% This script does NOT employ the MATLAB-DHI dll, but rather uses
% 'binary-reading' technique(?).
% I found a certain rule by which the data are written in a dfsu file. By
% understanding the binary file structure, MATLAB scripting no more relies
% on the MATLAB-DHI dll.

% 1) Copy 1st file - Base file
% 2) Change time step of the Base file/ And close the file
% 3) fseek to the Data locations for 2nd and 3rd files
% 4) Open Base file with 'a+'
% 5) Read and paste - DONE

% rev.: 11/3/2011, sjb
%     : update [Locate_Data_Block_2011.m] file
% rev.: 9/18/2012, sjb
%     : use [Locate_Data_Block_2012.m] 
%     : concatenate dfsu files with configuration file


%%
home
clear all; close all
use_config = true;
%% User setup

if use_config
    [fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');
    fidc = fopen(fullfile(pn,fn)); fgetl(fidc);
    dfsu_path1 = fgetl(fidc); fgetl(fidc);
    dfsu_name1 = fgetl(fidc); fgetl(fidc);
    dfsu_path2 = fgetl(fidc); fgetl(fidc);
    dfsu_name2 = fgetl(fidc); fgetl(fidc);
    merged_folder = fgetl(fidc); fgetl(fidc);
    merged_name = fgetl(fidc);
    
    merged_folder = pn;
    
    No_of_merge_file = 2;
else
    dfsu_path1 ='C:\Work\11-1031_Prospect_Island\modeling_scenario\output\part1';
    dfsu_path2 ='C:\Work\11-1031_Prospect_Island\modeling_scenario\output\part2';
    
    dfsu_name1 = 'HD_Calibration_Part1.dfsu';
    dfsu_name2 = 'HD_Calibration_Part2.dfsu';
    dfsu3_name = 'Alt1_DecouplingFlux_part3.dfsu';

    No_of_merge_file = 2;

end
fclose(fidc);
%%
% merged_name = sprintf('%s_Merged.dfsu',dfsu1_name(1:end-5));
if exist(fullfile(merged_folder,merged_name),'file') == 0
    copyfile(fullfile(dfsu_path1,dfsu_name1),fullfile(merged_folder,merged_name));
else
    delete(fullfile(merged_folder,merged_name));
    copyfile(fullfile(dfsu_path1,dfsu_name1),fullfile(merged_folder,merged_name));
end

data_type = {'float32' 'double' '*char' 'int32' 'uint32' 'int16'};

% Header.File_name = dfsu1_name;

%% OPEN files - detect overlapping periods
fid1 = fopen(fullfile(dfsu_path1,dfsu_name1));
fid2 = fopen(fullfile(dfsu_path2,dfsu_name2));

[Header1, ~ , ~ , loc_meshinfo1] = fun_ReadDfsuHeader(fid1);
[Header2, ~ , ~ , loc_meshinfo2] = fun_ReadDfsuHeader(fid2);

% in hours
tseries1 = Header1.Time_info.tstart*24:Header1.Time_info.dt/3600:Header1.Time_info.tend*24;
tseries2 = Header2.Time_info.tstart*24:Header2.Time_info.dt/3600:Header2.Time_info.tend*24;
[tseries_all,i1,i2] = union(tseries1,tseries2,'R2012a');  % priority on the first vector

% back to days
tseries_all = tseries_all./24;
fclose(fid1); fclose(fid2);

%%
[Header1, loc_data1, loc_time1] = Locate_Data_Block_2012(fullfile(dfsu_path1,dfsu_name1));
[Header2, loc_data2, loc_time2] = Locate_Data_Block_2012(fullfile(dfsu_path2,dfsu_name2));
% [timesteps3, loc_data3] = Locate_Data_Block_2012(dfsu3_name);

TOTAL_TIME = length(tseries_all);
% if No_of_merge_file == 3
%     TOTAL_TIME = TOTAL_TIME + Header3.time_step_all;
% end


%% UPDATE # of time steps
fidFo = fopen(fullfile(merged_folder,merged_name),'r+');

% READ TIME STEP
% before_time_steps = ftell(fidF);
% [data3_before,type] = read_dfs2_item(fidF); % probably all available steps [85 0]

% rewind a little
fseek(fidFo,loc_time1+5,'bof'); % 5 is for int8+int32 before 'time step values'
fwrite(fidFo,[TOTAL_TIME;0],'int32');

fseek(fidFo,loc_time1,'bof');
data3 = read_dfs2_item(fidFo); % probably all available steps [85 0]

fclose(fidFo);
clear fidFo

%% Append after the 1st file ===

fidW = fopen(fullfile(merged_folder,merged_name),'a+');
% fidF2 = fopen(fullfile(dfsu_path2,dfsu_name2));

%%
fprintf('\ndata concatenation starting ...\n')
added_time = 0;
for iter = i2(1):i2(end)  % time steps for the latter file
    
    fwrite(fidW,[-2 81 -61 -1],'int8');  % this is time step separator
    
    for nitem = 1:Header1.Item_info.number
        
        
        % cross-check: the function test
        fidF2 = fopen(fullfile(dfsu_path2,dfsu_name2));
        item1_struc = fun_ReadItemTimeStep(fidF2,nitem,iter-1);
        item1_fun = item1_struc.data;
        
        fclose(fidF2);
        
           
        
        fwrite(fidW,1,'int8');
        fwrite(fidW,Header1.Item_info.datasize,'int32');  % define data length
        fwrite(fidW,item1_fun,'float32');  % raw data
        
        clear item1_fun
        
    end
    added_time = added_time + 1;
    if mod(iter,1) == 0
        fprintf('t(t merged) = %d(%d): %s\n',iter-1,length(i1)-1+added_time,datestr(tseries2(iter)/24,'mm/dd/yy HH:MM'));
    end
end
fprintf('File concatenation complete.\n')
fclose('all');