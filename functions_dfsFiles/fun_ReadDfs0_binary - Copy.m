function [Header, loc_data, loc_time, dfs0] = fun_ReadDfs0_binary(dfs2_name,item)
% 
% Read DFS0 file
% created by sjb, 4/20/2012


% -- relate with [Locate_Data_Block_2012.m]

if nargin <1
    [dfs2_name,dfs2_path]=uigetfile('*.dfs0','Select dfs0 to load ...');
    item = 'all';
elseif nargin < 2
    item = 'all';
    dfs2_path = cd;
else
    dfs2_path = cd;
%     disp('Error: Select Valid dfs2 file');
end

if nargout<3
    loc_time = [];
end
% home
close all

data_type = {'float32' 'double' '*char' 'int32' 'uint32' 'int16'};

Header.File_name = dfs2_name;
fidF = fopen(fullfile(dfs2_path,dfs2_name),'r+');

% junk0 = fread(fidF,81,'*char');
fseek(fidF,81,'bof');
fread(fidF,1,'*int8'); % 26 : don't know what it means
created_date = fread(fidF,6,'*int16')'; % saved date
created_date = datestr(double(created_date));
fread(fidF,2,'*int32'); % 104 106 : don't know what they mean
modified_date = fread(fidF,6,'*int16')'; % saved date
modified_date = datestr(double(modified_date));
fread(fidF,4,'*int32'); % 104 106 0 0 : don't know what they mean
for i = 1:4,read_dfs2_item(fidF);end

Header.Title = read_dfs2_item(fidF);
junk = read_dfs2_item(fidF);

% fread(fidF,1,'*int32');
% fread(fidF,1,'*int8');
% 
% junk2 = fread(fidF,1,'*int32');      %  'length of the name of the program used'
Header.Tool = read_dfs2_item(fidF);

xxx = read_dfs2_item(fidF);

while xxx ~= 20053
    [xxx, ~] = read_dfs2_item(fidF);
end

% 
% fseek(fidF,1,'cof');
% 
% junk3 = fread(fidF,63,'int16');   % junk3(end-1) : 'length of Projection string'
% Header.Projection.Name = fread(fidF,junk3(end-1),'*char')';    

% 670 bytes

% YYYY-MM-DD
start_date = read_dfs2_item(fidF);
% HH:MM:SS
start_hour = read_dfs2_item(fidF);

Header.Start_time = [start_date(1:end-1) ' ' start_hour(1:end-1)];

Header.time_unit = read_dfs2_item(fidF); % probably 'unit'
data2 = read_dfs2_item(fidF); % probably dt [0 900]

% %% READ TIME STEP
loc_time = ftell(fidF);

% 767 bytes


data3 = read_dfs2_item(fidF); % probably all available steps [85 0]


% 780 byte

%% After reading time step
Header.time_step = data2(2);
Header.time_step_all = data3(1);
% all_steps = data3(1);
% fread(fidF,4,'*int16');

read_dfs2_item(fidF);  % 30000
read_dfs2_item(fidF);  % 30001

Header.Item_info.number = read_dfs2_item(fidF);


% 797 byte


for i = 1:Header.Item_info.number  % iterate number of items
    read_dfs2_item(fidF);  % 30005

    Item(i).eum  = read_dfs2_item(fidF);
    Item(i).name = read_dfs2_item(fidF);
    Item(i).unit = read_dfs2_item(fidF);
    
    read_dfs2_item(fidF);  % 1
    
    Item(i).MaxMinEmpty = read_dfs2_item(fidF);
    
    xxx = read_dfs2_item(fidF);
    while xxx ~= 30003
        [xxx, ~] = read_dfs2_item(fidF);
    end
    
    Item(i).etc = read_dfs2_item(fidF); % values unknown
   
end
loc_data = ftell(fidF);

xxx = read_dfs2_item(fidF);

fread(fidF,1,'*int8');  % -1 
loc_data = ftell(fidF);

if xxx == 50000
    fprintf(1,'Data block starts at bytes %d\n',loc_data)
end

% byte 1299

%% Data Read
tic
% --------------------
time_step_header = 4;
data_header = 5;
% --------------------


if strcmp(item,'all')
    % Read all ranges/all item
    
    % pre-allocate memory
    dfs0_Data = zeros(Header.time_step_all,Header.Item_info.number);
    
    for k = 1:Header.time_step_all
        fseek(fidF,time_step_header,'cof');  % skip 50001
        
        for j = 1:Header.Item_info.number
            fseek(fidF,data_header,'cof');  % skip [1 1 0 0 0 0]
            temp_data = fread(fidF,1,'float32');
            temp_data(abs(temp_data)<1e-29) = NaN;
            dfs0_Data(k,j) = temp_data;
            
            clear temp_data
            
            
        end
    end
    
elseif item>Header.Item_info.number
    disp('Error: Item number exceeds available items. ')
    
else
    % pre-allocate memory
    dfs0_Data = zeros(Header.time_step_all,1);   % one item
    
    for k = 1:Header.time_step_all
        fseek(fidF,time_step_header,'cof');  % skip 50001
        
        fseek(fidF,(time_step_header+data_header)*item - 4,'cof'); % skip to item
        
        temp_data = fread(fidF,1,'float32');
        temp_data(abs(temp_data)<1e-29) = NaN;
        dfs0_Data(k) = temp_data;
        
        fseek(fidF,(time_step_header+data_header)*(Header.Item_info.number - item),'cof'); % skip rest of time step
        
        clear temp_data
    end
end

tEnd = datenum(Header.Start_time) + (Header.time_step_all-1)*Header.time_step/3600/24;

dfs0.Data = dfs0_Data;
Time = datenum(Header.Start_time):Header.time_step/24/3600:tEnd;

% make the datenum integer at top of the hour marks

daily_data_entry = 24*3600/Header.time_step;

Time_int = round(Time.*daily_data_entry);   % multiply to make integer for all
Time = Time_int./daily_data_entry;         % divide back to the actual time

clear Time_int
dfs0.Time = Time';
toc
fclose(fidF);