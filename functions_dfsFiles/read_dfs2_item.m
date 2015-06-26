function [item_value, type] = read_dfs2_item(fid)
% Read individual items 'hidden' in dfs2 file

data_type = {'float32' 'double' '*char' 'int32' 'uint32' 'int16'};
type     = fread(fid,1,'int8');

if type>0
    data_len = fread(fid,1,'int32')';
    item_value   = fread(fid,data_len,data_type{type})';
elseif type == -1
    temp = fread(fid,1,'int8');  % -2
    if temp == -2
        item_value = fread(fid,1,'uint16');
    elseif temp>0                % incase -1 1 50 93 ...
        item_value = NaN;
        fseek(fid,-1,'cof');
    end
elseif type == -2
    item_value = fread(fid,1,'uint16');

end

if nargout < 2
    type = [];
end