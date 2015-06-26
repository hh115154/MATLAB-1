function [Header, loc_data, loc_time, loc_meshinfo] = fun_ReadDfsuHeader(fidF)
%fun_ReadDfsuHeader Read the header information from dfsu file
%
%   [Header, loc_data, loc_time, loc_meshinfo] = fun_ReadDfsuHeader(fid)
%   returns variables with header information and location of data block
%   and etc.
% 
%   skip header info and return the location of Data block
%   created by sjb, 4/22/2010
%   revised by sjb, 12/16/2011
%      - use fid instead of filename
%      - function name change: formerly [Locate_Data_Block_2011.m]
%
%   revised by sjb, 2/7/2012
%     - specify location for mesh-info in dfsu
frewind(fidF);

data_type = {'float32' 'double' '*char' 'int32' 'uint32' 'int16'};

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
fread(fidF,1,'*int32');
fread(fidF,1,'*int8');

junk2 = fread(fidF,1,'*int32');      %  'length of the name of the program used'
Header.Tool = fread(fidF,double(junk2),'*char')';

% 169 bytes

fseek(fidF,1,'cof');

junk3 = fread(fidF,63,'int16');   % junk3(end-1) : 'length of Projection string'
Header.Projection.Name = fread(fidF,junk3(end-1),'*char')';    

type = fread(fidF,1,'int8');
data_len = fread(fidF,1,'int32');

Geo_info = fread(fidF,data_len,'double')';
Header.Projection.Longitude = Geo_info(1);
Header.Projection.Latitude = Geo_info(2);
Header.Projection.Orientation = Geo_info(3);

fread(fidF,4,'int16');   
type = fread(fidF,1,'int8');
junk4 = fread(fidF,1,'int32'); %  'length of YYYY-MM-DD'

% YYYY-MM-DD
start_date = fread(fidF,junk4,'*char')';
type = fread(fidF,1,'int8');

junk5 = fread(fidF,1,'int32');
% fseek(fidF,411,'bof');
% HH:MM:SS
start_hour = fread(fidF,junk5,'*char')';

Header.Time_info.Start_time = [start_date(1:end-1) ' ' start_hour(1:end-1)];

data1 = read_dfs2_item(fidF); % probably 'unit'
data2 = read_dfs2_item(fidF); % probably dt [0 900]

% %% READ TIME STEP
loc_time = ftell(fidF);

% 767 bytes


data3 = read_dfs2_item(fidF); % probably all available steps [85 0]


% 780 byte

%% After reading time step
Header.Time_info.dt = data2(2);
Header.Time_info.nstep = data3(1);

Header.Time_info.tstart = datenum(Header.Time_info.Start_time);        % simulation start
Header.Time_info.tend = datenum(Header.Time_info.tstart + ...
    (Header.Time_info.nstep-1)*Header.Time_info.dt/3600/24);
Header.Time_info.End_time = datestr(Header.Time_info.tend,'yyyy-mm-dd HH:MM:SS');

% all_steps = data3(1);
fread(fidF,4,'*int16');

Header.Item_info.number = read_dfs2_item(fidF);


% 797 byte


for i = 1:Header.Item_info.number  % iterate number of items
    fread(fidF,2,'*int16');

    data5 = read_dfs2_item(fidF);
    Item(i).name = read_dfs2_item(fidF);
    Item(i).unit = read_dfs2_item(fidF);
    data8 = read_dfs2_item(fidF);
    data9 = read_dfs2_item(fidF);
    data10 = read_dfs2_item(fidF);
    data11 = read_dfs2_item(fidF);
    
%     fread(fidF,2,'*int16');
    var_name = read_dfs2_item(fidF);

    data12 = read_dfs2_item(fidF);

    %     fread(fidF,2,'*int16');
    var_name = read_dfs2_item(fidF);

    data13 = read_dfs2_item(fidF);  % [Unit Sets] from Data utility values
    data14 = read_dfs2_item(fidF);  % [Origin Spacing]
end

Header.Item_info.datasize = data13(2);
Header.Item = Item;
%% Read Custom Blocks
z = fread(fidF,1,'int8');
if z == -1,fseek(fidF,-1,'cof');brick=fread(fidF,2,'uint16')';end
block = 1;
while brick(2) == 60000
    type            = fread(fidF,1,'int8');
    data_len        = fread(fidF,1,'int32')';
    Header.Block(block).Name = fread(fidF,data_len,data_type{type})';
    
    type            = fread(fidF,1,'int8');
    data_len        = fread(fidF,1,'int32')';
    Header.Block(block).Elements = fread(fidF,data_len,data_type{type});

    z = fread(fidF,1,'int8');
    if z == -1,fseek(fidF,-1,'cof');brick=fread(fidF,2,'uint16')';end
    block = block +1;
end

%%
fread(fidF,1,'*int8');  % -1 
loc_meshinfo = ftell(fidF);

commonH = 1;
while ~feof(fidF);
    brick = read_dfs2_item(fidF);
    if brick == 999
        Header.mesh_info(commonH).name = read_dfs2_item(fidF);
    elseif brick == 40001
        Header.mesh_info(commonH).data = read_dfs2_item(fidF);
        commonH = commonH + 1;
    elseif brick==50000
        break
    end
end
% brick = 0;

%%

fread(fidF,1,'*int8');  % -1 
loc_data = ftell(fidF);

% fprintf(1,'Reading Header information complete.\n')

frewind(fidF);