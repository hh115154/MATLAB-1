% Shear Stress calculation
% sjb, 1/31/2012

% sjb, 10/22/2012 
%      calculate max shear stress
%      calculate max speed

% sjb, 10/29/2012
%      exclude first 6 hours

% sjb, 5/22/2013
%      modify code from [calc_MAX_Speed_2012_v3.m] under SCR_Newhall project
%{

******* Header information ************************

1. output - open an output file to write (fopen)
2. data file - Read the number of time step (nstep)
3. template - Read the header info up to 'time step' flag
4. write output 
    - the header to the output
    - define the new time step from 2.
5. template - Read the header between [loc_time] and [loc_data]
6. write output
    - write the rest of header

******* Data ************************
1. Read data
    - extract item info for each time step
    - calculate shear stress
2. Write output


%}

clear all; close all; home;
if ispc
%     dfsu_path ='C:\Work\13-1008_Moosa\from M2';
%     dfsu_path ='C:\Work\12-1016_Yolo_Ranch_Phase2\12-1016_Yolo_Ranch_Nework2_3\Modeling\output_v22';
%     dfsu_path = 'C:\Work\12-1016_Yolo_Ranch_Phase2\12-1016_Yolo_Ranch_Nework2_3\Modeling\output_5p8ft';
%     dfsu_path = 'C:\Work\12-1020_SCR_Newhall\Modeling\M9_results\Q25_Pr_2D_results';
%     dfsu_path = 'C:\Work\12-1020_SCR_Newhall\Modeling\M6_results\Q25_Existing_2D_results';
%     dfsu_path = 'C:\Work\12-1020_SCR_Newhall\Modeling\M6_results\Q100_Existing_2D_results';
%     dfsu_path = ...
%         'C:\Work\12-1016_Yolo_Ranch_Phase2\12-1016_Yolo_Ranch_Nework2_3\Modeling\m21fm_AD_coupled\output_6p2ft_low_n_interrupted';
%     dfsu_path = ...
%         'C:\Work\12-1016_Yolo_Ranch_Phase2\12-1016_Yolo_Ranch_Nework2_3\Modeling\m21fm_AD_coupled\output_5p8ft_low_n_SourceN2';
    dfsu_path = ...
        'C:\Work\13-1018_Ardenwood\Modeling\output\M21';
%         'C:\Work\12-1018_Arcade_Creek\Modeling\output\Bridge';
        
    
else
    %     dfsu_path = '/Users/sjbaek/WORK/cbec/2011_work/dfsu_works';
end
cd(dfsu_path)

% dfsu_name = 'Ex_test_Q10.dfsu';
% dfsu_name = 'Yolo_HD_output_v23_Only_wet_area_5p8ft.dfsu';
% dfsu_name = 'Yolo_HD_output_v23_real_wet_62_low_n_stitched.dfsu';
% dfsu_name = 'Yolo_HD_output_v23_real_wet_58_low_n.dfsu';
% dfsu_name = 'Ardenwood_v6_MF_dummyQ_test2_MF_veg_10pct.dfsu';
% dfsu_name = 'Ardenwood_v6_MF_dummyQ_MF_link_fixed.dfsu';
% dfsu_name = 'Ardenwood_v6_MF_dummyQ_MF_veg_10pct_link_fixed.dfsu';
% dfsu_name = 'Ardenwood_MF_Q100_v5_EX.dfsu';
% dfsu_name = 'AC_2D_output_Bridge_Q2_fix.dfsu';
dfsu_name = 'Ardenwood_MF_Q100_v5_EX_10pc_Bed.dfsu';
%% *******************************************************   HEADER
%% 1. Open an output file (a placeholder)
% output_fn = sprintf('%s_Max_WSE_feet.dfsu',dfsu_name(1:end-5));
output_fn = sprintf('%s_Max_Depth_meter.dfsu',dfsu_name(1:end-5));

% output_fn = 'Max_WSE_.dfsu';

if exist(output_fn,'file') ~= 0    
    delete(output_fn)
end
fidW = fopen(fullfile(dfsu_path,output_fn),'a+');

%% 2. Read total time steps from data file

data_fn = dfsu_name;
[Header_d, ~, ~, ~] = Locate_Data_Block_2012(data_fn);
TOTAL_TIME = Header_d.time_step_all;  % 

%% 3. Read the header from template file
% template_pn = 'C:\Work\12-1020_SCR_Newhall\Modeling';
% template_fn = 'Shear_stress_template.dfsu';
% [Header, loc_data, loc_time, ~] = Locate_Data_Block_2012(fullfile(template_pn,template_fn));
[Header, loc_data, loc_time, ~] = Locate_Data_Block_2012(data_fn);
fidS = fopen(data_fn,'r');

header_time = fread(fidS,loc_time,'*int8');

%% 4. Write header to output file
TIME_for_max_value = 1;
fwrite(fidW,header_time,'int8');
fwrite(fidW,4,'int8');  % data_type: int32
fwrite(fidW,[2; TIME_for_max_value; 0],'int32');

read_dfs2_item(fidS); % move forward after 'total time' definition bytes in the template file

%% 5. Read header after TOTAL_TIME before 'data' field
loc_curr = ftell(fidS);

bytes_length_to_data = loc_data - loc_curr;
header_rest_all = fread(fidS,bytes_length_to_data,'*int8');

%% 6. Write the rest of header to output file

fwrite(fidW,header_rest_all,'int8'); 

fclose(fidS);  % closing the template file

%% *******************************************************   DATA
%% 1. Read Data
fidd = fopen(dfsu_name);
[Header_d, ~, ~] = fun_ReadDfsuHeader(fidd);

% disp('---------- Available items')
% for q = 1:length(Header_d.Item)
%     fprintf(1,'%d. %s \n',q,Header_d.Item(q).name)
% end
% i_DragC = input('\nSelect Drag Coefficient (just ''Enter'' for default = 6) \nDrag = ');
% i_Speed = input('\nSelect Current Speed (just ''Enter'' for default = 5) \nSpeed = ');
% 
% if isempty(i_DragC)
%     i_DragC = 6;
% end
% 
% if isempty(i_Speed)
%     i_Speed = 5;
% end

% i_shearstress = 1; % only one item available
i_shearstress = 2; % depth item

% shear stress equation: tau = rho*D_coef*speed^2
% item number:    tau = rho * (6) * (5) * (5)

spin_up_end = 25; 
for k = 1:Header_d.Time_info.nstep
    if k < spin_up_end
        continue
    elseif k == spin_up_end % first time step; just save the value
        fprintf(1,'timesteps up to %d was skipped\n',spin_up_end);
        SS = fun_ReadItemTimeStep(fidd,i_shearstress,k-1);
        SS1 = SS.data;

        
    else % after k=1; comparing begins
        % SS1 = SS(k-1);  % Shear stress previous time
        nan_ss1 = find(abs(SS1)<1e-34);
        
        SS = fun_ReadItemTimeStep(fidd,i_shearstress,k-1);
        nan_ss = find(abs(SS.data)<1e-34);
        Not_a_number = SS.data(nan_ss(1));
        
        
%         DragC = fun_ReadItemTimeStep(fidd,i_shearstress,k-1);
%         nan_drag = find(abs(DragC.data)<1e-34);
%         Not_a_number = DragC.data(nan_drag(1));
%         
%         Speed = fun_ReadItemTimeStep(fidd,i_Speed,k-1);
%         nan_spd = find(abs(Speed.data)<1e-34);
%         
%         tau = 1000.*DragC.data.*Speed.data.^2;
%         tau(nan_drag) = Not_a_number;
%         tau(nan_spd) = Not_a_number;
        
        maxSS = max(SS1,SS.data);
%         maxSS(nan_ss1) = Not_a_number;
        
        SS1 = maxSS;
    end
    
    
end
    
    %% write output for maximum shear stress
    
%     fprintf(1,'time step %d: starts\n',k);
    fwrite(fidW,[-2 81 -61 -1],'int8');
    
    fwrite(fidW,1,'int8');
    fwrite(fidW,Header_d.Item_info.datasize,'int32');  % define data length
    
    % convert to feet
%     maxSS(abs(maxSS)>1e-34) = maxSS(abs(maxSS)>1e-34).*3937./1200;
    maxSS(abs(maxSS)>1e-34) = maxSS(abs(maxSS)>1e-34);

    fwrite(fidW,maxSS,'float32');  % raw data
    
    

fclose('all');
