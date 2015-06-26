% copied from [function Merge_dfsu_Main_2011.m]

% This script does NOT employ the MATLAB-DHI dll, but rather uses
% 'binary-reading' technique(?).
% A certain rule by which the data are written in a dfsu file was found. By
% understanding the binary file structure, MATLAB no longer relies
% on the MATLAB-DHI dll.

% 2012 update
% Goal: replace a chunk of dataset in the middle of dfsu timesteps with a
% hotstart dfsu data - the original has corrupted data between t(k+1) and t(m)
%
% [original dfsu t(1~k)] + [hotstart dfsu t(k+1)~t(m)] + [original dfsu t(m+1)~t(end)]

% 1) Copy the Header from the original dfsu
% 2) Write Header in a NEW file (fopen with 'a+' option)
% 3) fseek to the Data locations for original and hotstart files
% 4) Open Base file with 'a+'
% 5) Read and paste - DONE

% rev.: 11/3/2011, sjb
%     : update [Locate_Data_Block_2011.m] file
% rev.: 7/23/2012, sjb
%     
%%
home
close all; close all

%% User setup

No_of_merge_file = 2;

dfsu_path1 ='\\CBECM8\Work\Projects\11-1031_Prospect_Island\output\Validation_round1_v13-6_30day_seep';
dfsu_path2 ='\\CBECM8\Work\Projects\11-1031_Prospect_Island\output\Validation_round1_v13-6_30day_seep_0724_hotstart';
cd(dfsu_path1)

% item = 'Area';
item = 'Flux';
partial_num = 0;

dfsu_name = sprintf('Cal_Decoupling%s_p%d.dfsu',item,partial_num);

orig_fn = fullfile(dfsu_path1,dfsu_name);
fidO = fopen(orig_fn,'r');

hot_fn  = fullfile(dfsu_path2,dfsu_name);

%%
merged_name = sprintf('%s_Merged.dfsu',dfsu_name(1:end-5));
if exist(merged_name)==0
    fidW = fopen(fullfile(dfsu_path1,merged_name),'a+');
%     copyfile(dfsu1_name,merged_name);
else
    delete(merged_name);
    fidW = fopen(fullfile(dfsu_path1,merged_name),'a+');
%     copyfile(dfsu1_name,merged_name);
end

data_type = {'float32' 'double' '*char' 'int32' 'uint32' 'int16'};

% Header.File_name = dfsu1_name;

%% OPEN original file - read header
[Header, loc_data, loc_time, loc_meshinfo] = Locate_Data_Block_2012(dfsu_name);

%% 

% read Header (original dfsu)
header_orig = fread(fidO,loc_data,'*int8');
fclose(fidO);

% write Header to merged
fwrite(fidW,header_orig,'int8');

% ---------------------------------------------------
% This code 'replaces' middle section with hotstart files,
% so no need to separately define the overall TIME_STEP
% in the Header.
% ---------------------------------------------------


% read Data(original) 'before corrupted point'

for iter = 1: Header.time_step_all
%     fprintf(1,'time step %d: starts\n',iter);
    fwrite(fidW,[-2 81 -61 -1],'int8');
    
    for nitem = 1:Header.Item_info.number
        
%         dfsu_name = dir_info(i).name;
%         fid_part = fopen(dfsu_name,'a+');
        
        if iter <= 1757  % calibration
            
            % cross-check: the function test
            fidO = fopen(orig_fn,'a+');
            item1_struc = fun_ReadItemTimeStep(fidO,nitem,iter-1);
            item1_fun = item1_struc.data;
            
            fclose(fidO);
            
        elseif iter >= 1758 && iter <= 1881  % calibration
            fidh = fopen(hot_fn,'a+');
            
            % hotstart file timestep count:
            % 1757 equas 69 in hotstart
            iter_hot = iter - 1688;
            if iter_hot == 193
                disp(iter_hot)
            end
            item1_struc = fun_ReadItemTimeStep(fidh,nitem,iter_hot-1);
            item1_fun = item1_struc.data;
            
            fclose(fidh);
            
        else
            fidO = fopen(orig_fn,'a+');
            item1_struc = fun_ReadItemTimeStep(fidO,nitem,iter-1);
            item1_fun = item1_struc.data;
            
            fclose(fidO);
            
        end
        
        fwrite(fidW,1,'int8');
        fwrite(fidW,Header.Item_info.datasize,'int32');  % define data length
        fwrite(fidW,item1_fun,'float32');  % raw data
        
        clear item1_fun
        
    end
    
    if mod(iter,50) == 0
        fprintf(1,'   t= %d\n',iter);
    end
end
fclose('all');