function Output = fun_Read_m21fm(m21fm)
home

% Reading m21fm file

m21fm = 'Existing_HD_calibration_round1_v13_30day.m21fm';
fid = fopen(m21fm);
line = 1;
xx = strtrim(fgetl(fid));

while ~feof(fid)
    while isempty(strfind(xx,'OUTPUT_'))
       xx = strtrim(fgetl(fid)); 
%        disp(line)
       line = line+1;
%        fprintf('%d:%s\n',line,xx);
       if line == 6278
          disp(xx) 
       end
    end
    loc = ftell(fid);
    
    % after hit [OUTPUT_..]
    
    xx = strtrim(fgetl(fid)); 
    line = line+1;
    
    while isempty(strfind(xx,'file_name'))
%         fprintf('%d:%s\n',line,xx)
        xx = strtrim(fgetl(fid));
        line = line+1;
        
    end
    eval(xx);  % read OUTPUT 'file_name'
    
    while isempty(strfind(file_name,'dfs0'))   % if NOT dfs0 file
        fprintf('%d:%s\n',line,xx)
        
        xx = strtrim(fgetl(fid));
        line = line+1;
        if ~isempty(strfind(xx,'file_name'))
            if strfind(xx,'file_name') == 1
                eval(xx);
            end
        end
        
    end
    
    xx = strtrim(fgetl(fid));
    line = line+1;
    
end

fprintf('%d:%s\n',line,xx)
fclose(fid);