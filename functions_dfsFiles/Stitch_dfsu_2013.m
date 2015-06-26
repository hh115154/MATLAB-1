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

home
clear all; close all

%% User setup

if ispc
    dfsu_path ='C:\Work\cbec\Stitch_needed';
else
    dfsu_path = '/Users/sjbaek/WORK/cbec/2011_work/dfsu_works';
end

cd(dfsu_path)

%% Big file
big_dfsu = 'template_large.dfsu';
% copyfile('template_large.dfsu',big_dfsu);

[Header_big, loc_data_big, loc_time_big, loc_meshinfo_big] = Locate_Data_Block_2012(big_dfsu);

% open file

fidS = fopen(big_dfsu,'r');
% fseek(fidS,loc_data_big,'bof');

%%
dir_info = dir('*_p*');

% item1 = zeros(1,Header_big.Item_info.datasize);

for i = 1:length(dir_info)
    dfsu_name = dir_info(i).name;
    fid_part = fopen(dfsu_name,'a+');
    
    [Header, loc_data, loc_time, ~] = Locate_Data_Block_2012(dfsu_name);
    
    % go to data block
    fseek(fid_part,loc_data,'bof');
    % skip data headers
    read_dfs2_item(fid_part);
    read_dfs2_item(fid_part);
    [partial_item1 ~]= read_dfs2_item(fid_part);
    [partial_item2 ~]= read_dfs2_item(fid_part);
    [partial_item3 ~]= read_dfs2_item(fid_part);
    
    item1{i} = partial_item1;
    item2{i} = partial_item2;
    item3{i} = partial_item3;
    
    fclose(fid_part);
    clear partial_item*
    
end

item1_stit = cell2mat(item1);
item2_stit = cell2mat(item2);
item3_stit = cell2mat(item3);

%% write back to stitched file
data_type = {'float32' 'double' '*char' 'int32' 'uint32' 'int16'};

% currently at 'data_loc'
% read_dfs2_item(fidS);
% read_dfs2_item(fidS);

frewind(fidS);

Header_before_data = fread(fidS,loc_data_big+4,'*int8');

%% write data
fidW = fopen('test.dfsu','a+');


fwrite(fidW,Header_before_data,'int8');

% data start

%{
1
'length of variable' (int32)
Data
%}

fwrite(fidW,1,'int8');
fwrite(fidW,Header_big.Item_info.datasize,'int32');
fwrite(fidW,item1_stit,'float32');

fwrite(fidW,1,'int8');
fwrite(fidW,Header_big.Item_info.datasize,'int32');
fwrite(fidW,item2_stit,'float32');

fwrite(fidW,1,'int8');
fwrite(fidW,Header_big.Item_info.datasize,'int32');
fwrite(fidW,item3_stit,'float32');


fclose('all');
