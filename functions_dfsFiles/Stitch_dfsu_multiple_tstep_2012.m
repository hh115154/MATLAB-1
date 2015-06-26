% stitch dfsu's into one

%{
1. 8 parts total
2. sum of elements = total elements
3. BUT, sum of nodes ~= total nodes. Due to the cutting faces of each dfsu.
   Nodes on the cut faces count double.

4. Create a template from the big dfsu (place holder for the items/time step)
   - Use data utility to change 'Start Time'/'Custom Block'
5. Read data from partial dfsu and merge
6. Write them back to template

%}

%{
<*> stitch 8 file with 51 time steps

1. Create a template with all 7 items for the header information
2. Copy binary data [before 'time step definition'] and paste
3. Re-write the new time step
4. Rest of the header: copy binary data between 'time step definition' and 'data location'
5. Write the rest of the header
6. Start writing the raw data

%}

% 1/15/12 revision: to stitch 8 files with 'time steps'

home
clear all; close all

%% User setup
% read configure file
[fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');


%{

*** typical cfg file contents ***

% dfsu path
C:\Work\11-1031_Prospect_Island\modeling_scenario\output\3_Screening_alt_4_30day_HD_decoup
% dfsu template file name
HD_Calibration_alt4_original.dfsu
% output file name
HD_alt4_merged_all.dfsu
% number of merging files
6
% file name
HD_part0.dfsu
HD_part1.dfsu
HD_part2.dfsu
HD_part3.dfsu
HD_part4.dfsu
HD_part5.dfsu


%}

fidc = fopen(fullfile(pn,fn));
fgetl(fidc);
dfsu_path = fgetl(fidc);
% dfsu_path ='C:\Work\11-1031_Prospect_Island\modeling_scenario\output\3_Screening_alt_4_30day_HD_decoup';

    %     dfsu_path = '/Users/sjbaek/WORK/cbec/2011_work/dfsu_works';

cd(dfsu_path)

%% Big file

% template filename
fgetl(fidc);
big_dfsu = fgetl(fidc);

% big_dfsu = 'HD_Calibration_alt4_original.dfsu';
% copyfile('template_large.dfsu',big_dfsu);
fgetl(fidc);
merged_name = fgetl(fidc);
% merged_name = 'test.dfsu';

if exist(merged_name,'file') ~= 0    
    delete(merged_name)
end

[Header_big, loc_data_big, loc_time_big] = Locate_Data_Block_2012(big_dfsu);

% open file

fidS = fopen(big_dfsu,'r');
%% Read header info
[Header, loc_data, loc_time, loc_meshinfo] = fun_ReadDfsuHeader(fidS);
frewind(fidS);

header_time = fread(fidS,loc_time_big,'*int8');
% fseek(fidS,loc_data_big,'bof');



%%
% dir_info = dir('*part*');

fgetl(fidc);
num_parts = str2double(fgetl(fidc));
fgetl(fidc);
for ii = 1:num_parts
    dir_info(ii).name = fgetl(fidc);
    
end

fclose(fidc);

% item1 = zeros(1,Header_big.Item_info.datasize);

%% Write header data to the output file dfsu

fidW = fopen(fullfile(dfsu_path,merged_name),'a+');
fwrite(fidW,header_time,'int8');
fwrite(fidW,4,'int8');  % data_type: int32


%--------------------------------------------------------------

[Header_p, ~,~] = Locate_Data_Block_2012(dir_info(1).name);

TOTAL_TIME = Header_p.time_step_all; 
% TOTAL_TIME = 3;  % hardwired
%--------------------------------------------------------------


fwrite(fidW,[2; TOTAL_TIME; 0],'int32');

read_dfs2_item(fidS); % move forward after 'total time' definition bytes in the template file
loc_curr = ftell(fidS);

bytes_length_to_data = loc_data_big - loc_curr;
header_rest_all = fread(fidS,bytes_length_to_data,'*int8');
% write back to output file
fwrite(fidW,header_rest_all,'int8');

fclose(fidS);
%% Extract data from partial files and write


for iter = 1:TOTAL_TIME            % for loop for time steps
    fprintf(1,'time step %d: starts\n',iter-1);
    fwrite(fidW,[-2 81 -61 -1],'int8');

    for nitem = 1:Header.Item_info.number         % for loop for items
        for i = 1:length(dir_info)  % for loop for partial files
            
            dfsu_name = dir_info(i).name;
            fid_part = fopen(dfsu_name,'a+');
            
            
            % cross-check: the function test
            item1_struc = fun_ReadItemTimeStep(fid_part,nitem,iter-1);
            item1_fun{i} = item1_struc.data;
            
            fclose(fid_part);
            clear partial_item*
            
%             disp(length(item1_struc.data));
        end
        %%
        
        item_stitched = cell2mat(item1_fun);
    
        
        %% write data (for each time step t=0, 1, 2 ... 51) back to dfsu
        fwrite(fidW,1,'int8');
        fwrite(fidW,Header_big.Item_info.datasize,'int32');  % define data length
        fwrite(fidW,item_stitched,'float32');  % raw data
        
        fprintf(1,'   item%d\n',nitem);
    
    
    
    
    end
    fprintf(1,'writing time step %d: complete\n',iter-1);
    fprintf(1,'------------------------------\n');
end


fclose('all');
