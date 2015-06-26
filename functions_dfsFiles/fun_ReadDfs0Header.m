function [Header] = fun_ReadDfs0Header(dfs2_name)
%FUN_READDFS0_BINARY reads DHI formatted dfs0 (1-D) data file
%   
%   [HEADER,LOC_DATA,LOC_TIME,DATA] = FUN_READDFS0HEADER(FILENAME,ITEM,RANGE)
%   
%   Input: (all are optional)
%     FILENAME - dfs0 filename
%
%   Output: 
%     HEADER - header information 

% Read DFS0 file
% created by sjb, 4/30/2012

% -- relate with [Locate_Data_Block_2012.m]

if nargin <1
    [dfs2_name,dfs2_path]=uigetfile('*.dfs0','Select dfs0 to load ...');
    cd(dfs2_path)
    
end

data_type = {'float32' 'double' '*char' 'int32' 'uint32' 'int16'};

Header.File_name = dfs2_name;
% fidF = fopen(fullfile(dfs2_path,dfs2_name),'r+');
fidF = fopen(dfs2_name,'r+');

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

Header.Time_info.Start_time = [start_date(1:end-1) ' ' start_hour(1:end-1)];

Header.Time_info.time_unit = read_dfs2_item(fidF); % probably 'unit'
data2 = read_dfs2_item(fidF); % probably dt [0 900]

% %% READ TIME STEP
loc_time = ftell(fidF);

% 767 bytes


data3 = read_dfs2_item(fidF); % probably all available steps [85 0]


% 780 byte

%% After reading time step
Header.Time_info.time_step = data2(2);
Header.Time_info.time_step_all = data3(1);
% all_steps = data3(1);
% fread(fidF,4,'*int16');

read_dfs2_item(fidF);  % 30000
read_dfs2_item(fidF);  % 30001

xxx = read_dfs2_item(fidF);

Header.Item_info.number = xxx;


% 797 byte

read_dfs2_item(fidF);  % first appearing 30005

for i = 1:Header.Item_info.number  % iterate number of items

    Item(i).eum  = read_dfs2_item(fidF);
    Item(i).name = read_dfs2_item(fidF);
    Item(i).unit = read_dfs2_item(fidF);
    
    read_dfs2_item(fidF);  % 1
    
    Item(i).MaxMinEmpty = read_dfs2_item(fidF);
    
    while ~feof(fidF)
        xxx = read_dfs2_item(fidF);
        if xxx == 30003
            Item(i).etc = read_dfs2_item(fidF);
        end
        
        if xxx == 30005
            break
        elseif xxx == 50000
            fseek(fidF,-3,'cof');
            break
        end
        
        
        
    end
%     while xxx ~= 30003
%         [xxx, ~] = read_dfs2_item(fidF);
%     end
%     
%     Item(i).etc = read_dfs2_item(fidF); % values unknown
   
end

Header.Item_info.detail = Item;

% loc_data = ftell(fidF);

xxx = read_dfs2_item(fidF);

fread(fidF,1,'*int8');  % -1 
% loc_data = ftell(fidF);

% if xxx == 50000
%     fprintf(1,'Data block starts at bytes %d\n',loc_data)
% end

% byte 1299

%% Time series 
% tEnd = datenum(Header.Time_info.Start_time) + (Header.Time_info.time_step_all-1)*Header.Time_info.time_step/3600/24;
% 
% Time = datenum(Header.Time_info.Start_time):Header.Time_info.time_step/24/3600:tEnd;
% 
% % make the datenum integer at top of the hour marks
% 
% daily_data_entry = 24*3600/Header.Time_info.time_step;
% 
% Time_int = round(Time.*daily_data_entry);   % multiply to make integer for all
% Time = Time_int./daily_data_entry;         % divide back to the actual time
% 
% clear Time_int

% toc
fclose(fidF);