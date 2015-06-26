% Calc differences of two dfsus with identical elements
% - calc Max WSE
% - calc Max Speed
% - calc Max Shear

clear all
close all


% out_folder = 'C:\Work\12-1018_Arcade_Creek\Modeling\output\Diff';
% out_folder = 'C:\Work\13-1017_Dos_Rios\2014_work\Alt1\t640';
out_folder = 'C:\Work\13-1018_Ardenwood\Modeling\output\M21';
cd(out_folder);

%% 1) Read 1st dfsu - project condition

% path1 = 'C:\Work\12-1018_Arcade_Creek\Modeling\output\Bridge\MaxWSE';
% path1 = 'C:\Work\12-1018_Arcade_Creek\Modeling\output\Bridge\MaxSpeed';
% path1 = 'C:\Work\12-1018_Arcade_Creek\Modeling\output\Bridge\MaxShear';
% path1 = 'C:\Work\13-1017_Dos_Rios\2014_work\Alt1\t640';
path1 = 'C:\Work\13-1018_Ardenwood\Modeling\output\M21';

% file1 = 'AC_2D_output_Bridge_Q100_fix_Max_WSE_feet.dfsu';
% file1 = 'AC_2D_output_Bridge_Q100_fix_Max_Speed_feet.dfsu';
% file1 = 'AC_2D_output_Bridge_Q100_fix_shear_Max_Shear.dfsu';
% file1 = 'WSE1_t640.dfsu';
% file1 = 'Ardenwood_v6_MF_dummyQ_test2_MF_veg_10pct.dfsu';
% file1 = 'Ardenwood_v6_MF_dummyQ_MF_link_fixed_veg_10pct_Max_WSE.dfsu';
% file1 = 'Ardenwood_MF_Q100_v5_EX_10pc_Bed_Max_Depth_meter.dfsu';
% file1 = 'Ardenwood_MF_Q100_v5_EX_10pc_Bed_Max_WSE.dfsu';
file1 = 'Ardenwood_MF_Q100_ph2_Run1_Max_WSE.dfsu';

fid1 = fopen(fullfile(path1,file1));

% define timestep ; 1st time step = 0
timestep1 = 0;
Data1 = fun_ReadItemTimeStep(fid1,1,timestep1);
fclose(fid1);
%% 1-1) Open an output file
output_fn = sprintf('%s_DIFF.dfsu',file1(1:end-5));

% output_fn = 'Max_WSE_.dfsu';

if exist(output_fn,'file') ~= 0    
    delete(output_fn)
end
fidW = fopen(fullfile(out_folder,output_fn),'a+');



%% 2) Read 2nd dfsu - existing condition

% path2 = 'C:\Work\12-1018_Arcade_Creek\Modeling\output\Ex\MaxWSE';
% path2 = 'C:\Work\12-1018_Arcade_Creek\Modeling\output\Ex\MaxSpeed';
% path2 = 'C:\Work\12-1018_Arcade_Creek\Modeling\output\Ex\MaxShear';
% path2 = 'C:\Work\13-1017_Dos_Rios\2014_work\Alt1\t640';
path2 = 'C:\Work\13-1018_Ardenwood\Modeling\output\M21';


% file2 = 'AC_2D_output_Ex_Q100_Max_WSE_feet.dfsu';
% file2 = 'AC_2D_output_Ex_Q100_Max_Speed_feet.dfsu';
% file2 = 'AC_2D_output_Ex_Q100_shear_Max_Shear.dfsu';
% file2 = 'WSE3_t640.dfsu';
% file2 = 'Ardenwood_v6_MF_dummyQ_test2_MF.dfsu';
% file2 = 'Ardenwood_v6_MF_dummyQ_MF_link_fixed_Max_WSE.dfsu';
% file2 = 'Ardenwood_MF_Q100_v5_EX_Max_Depth_meter.dfsu';
% file2 = 'Ardenwood_MF_Q100_v5_EX_Max_WSE.dfsu';
file2 = 'Ardenwood_MF_Q100_ph2_Run3_Max_WSE.dfsu';

fid2 = fopen(fullfile(path2,file2));

% define timestep
timestep2 = 0;

Data2 = fun_ReadItemTimeStep(fid2,1,timestep2);
fclose(fid2);
%% 3) Read the header from the 1st file

data_fn = file1;
[Header, loc_data, loc_time, ~] = Locate_Data_Block_2012(fullfile(path1,data_fn));
fidS = fopen(fullfile(path1,data_fn),'r');

header_time = fread(fidS,loc_time,'*int8');

%% 4) Write header to output file
TIME_for_max_value = 1;
fwrite(fidW,header_time,'int8');
fwrite(fidW,4,'int8');  % data_type: int32
fwrite(fidW,[2; TIME_for_max_value; 0],'int32');

read_dfs2_item(fidS); % move forward after 'total time' definition bytes in the template file

%% 5) Read header after TOTAL_TIME before 'data' field
loc_curr = ftell(fidS);

bytes_length_to_data = loc_data - loc_curr;
header_rest_all = fread(fidS,bytes_length_to_data,'*int8');

%% 6) Write the rest of header to output file

fwrite(fidW,header_rest_all,'int8');

fclose(fidS);  % closing the template file


% -----------------------------------------------------------
% -----------------------------------------------------------
% -----------------------------------------------------------


%% Write outputs

%% 7) take difference for only wet cells for both conditions

ind1 = find(abs(Data1.data)>1e-34);
ind2 = find(abs(Data2.data)>1e-34);
indx = intersect(ind1,ind2);

DATA = zeros(size(Data1.data));
DATA(indx) = Data1.data(indx)-Data2.data(indx);



%% when taking depth difference
% DATA(DATA==0) = min(Data1.data);  % delete values
DATA(DATA==0) = 1e-35;  % delete values
%% all other items
% DATA(DATA==0) = Data1.data(1);  % delete values


%% 8) write output for maximum shear stress

fwrite(fidW,[-2 81 -61 -1],'int8');

fwrite(fidW,1,'int8');
fwrite(fidW,Header.Item_info.datasize,'int32');  % define data length

% convert to feet
% maxSS(abs(maxSS)>1e-34) = maxSS(abs(maxSS)>1e-34).*3937./1200;

fwrite(fidW,DATA,'float32');  % raw data

    

fclose('all');

