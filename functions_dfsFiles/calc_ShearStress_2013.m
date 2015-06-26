% Shear Stress calculation
% sjb, 1/31/2012

% sjb, 10/22/2012 
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
    dfsu_path ='C:\Work\12-1018_Arcade_Creek\Modeling\output';
else
    %     dfsu_path = '/Users/sjbaek/WORK/cbec/2011_work/dfsu_works';
end
cd(dfsu_path)

%% *******************************************************   HEADER

%% 0. Select output dfsu for shear computation

[data_fn,filepath] = uigetfile('*.dfsu','Select the .dfsu file to analyse');
infile = fullfile(filepath,data_fn);
cd(filepath)

%% 1. Open an output file (a placeholder)

output_fn = sprintf('%s_shear.dfsu',data_fn(1:end-5));

if exist(fullfile(filepath,output_fn),'file') ~= 0    
    delete(fullfile(filepath,output_fn))
end
fidW = fopen(fullfile(filepath,output_fn),'a+');

%% 2. Read total time steps from data file

% data_fn = 'Newhall_extension_2D.dfsu';
[Header_d, ~, ~, ~] = Locate_Data_Block_2012(data_fn);
TOTAL_TIME = Header_d.time_step_all;  % 

%% 3. Read the header from template file
template_pn = 'C:\Work\12-1018_Arcade_Creek\Modeling\output';
template_fn = 'shear_stress_template.dfsu';
[Header, loc_data, loc_time, ~] = Locate_Data_Block_2012(fullfile(template_pn,template_fn));
fidS = fopen(fullfile(template_pn,template_fn),'r');

header_time = fread(fidS,loc_time,'*int8');

%% 4. Write header to output file

fwrite(fidW,header_time,'int8');
fwrite(fidW,4,'int8');  % data_type: int32
fwrite(fidW,[2; TOTAL_TIME; 0],'int32');

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
fidd = fopen(infile);
[Header_d, ~, ~] = fun_ReadDfsuHeader(fidd);

disp('---------- Available items')
for q = 1:length(Header_d.Item)
    fprintf(1,'%d. %s \n',q,Header_d.Item(q).name)
end
i_DragC = input('\nSelect Drag Coefficient (just ''Enter'' for default = 6) \nDrag = ');
i_Speed = input('\nSelect Current Speed (just ''Enter'' for default = 5) \nSpeed = ');

if isempty(i_DragC)
    i_DragC = 6;
end

if isempty(i_Speed)
    i_Speed = 5;
end


% shear stress equation: tau = rho*D_coef*speed^2
% item number:    tau = rho * (6) * (5) * (5)

for k = 1:Header_d.Time_info.nstep
    
    DragC = fun_ReadItemTimeStep(fidd,i_DragC,k-1);
    nan_drag = find(abs(DragC.data)<1e-34); 
    Not_a_number = DragC.data(nan_drag(1));
    
    Speed = fun_ReadItemTimeStep(fidd,i_Speed,k-1);
    nan_spd = find(abs(Speed.data)<1e-34);
        
    tau = 1000.*DragC.data.*Speed.data.^2;
    tau(nan_drag) = Not_a_number;
    tau(nan_spd) = Not_a_number;
    
    
    
    %% write output each time step
    
    fprintf(1,'time step %d: starts\n',k);
    fwrite(fidW,[-2 81 -61 -1],'int8');
    
    fwrite(fidW,1,'int8');
    fwrite(fidW,Header_d.Item_info.datasize,'int32');  % define data length
    fwrite(fidW,tau,'float32');  % raw data
    
    
end
fclose('all');
