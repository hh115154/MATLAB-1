function Data = fun_ReadItemTimeStep(fid,item_num,t_step)
%
% [t_step] starts from ZERO, same as MIKE time step
%% read header information
[Header, loc_data, ~] = fun_ReadDfsuHeader(fid);

% These are the fixed number of bytes precede each data block
% --------------------
time_step_header = 4;
data_header = 5;
% --------------------
data_bytes = time_step_header + (Header.Item_info.datasize*4+data_header)*Header.Item_info.number; % bytes size of entier ONE time step

% t_step = 0 ~ end_of_timestep


%% sample data

loc_nstep = loc_data + data_bytes*t_step;  % data location for each time step (t_step)

% item_num starts at 1
loc_item = time_step_header + (data_header + Header.Item_info.datasize*4)*(item_num-1);  % always count 4 bytes (time step header)

LOC_Data = loc_nstep + loc_item;

%% read data

fseek(fid,LOC_Data,'bof');

[data, ~] = read_dfs2_item(fid);  % One item at One time step

Data.data = data;
Data.name = Header.Item(item_num).name;
Data.timestep = t_step;

frewind(fid);
% fclose('all');

% disp('Reading data Complete')