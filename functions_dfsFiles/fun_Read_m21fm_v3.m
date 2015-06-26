function Output = fun_Read_m21fm_v3(m21fm)
home

% Reading m21fm file

m21fm = 'Existing_HD_calibration_round1_v13_30day.m21fm';
fid = fopen(m21fm);
line = 1;
xx = strtrim(fgetl(fid));

while ~feof(fid)
    if ~isempty(strfind(xx,'OUTPUT_'))
        break
        xx = strtrim(fgetl(fid));
        
        line = line+1;
        fprintf('%d:%s\n',line,xx);
    
        
    end
    xx = strtrim(fgetl(fid));
    line = line+1;
    fprintf('%d:%s\n',line,xx)
    
    
end

while ~feof(fid)
    
    if ~isempty(strfind(xx,'file_name')) && strfind(xx,'file_name') == 1 ...
            && ~isempty(strfind(xx,'dfs0'))
        
        eval(xx)    % first dfs0 file located!!!
%         xx = strtrim(fgetl(fid));
%         line = line+1;
%         fprintf('%d:%s\n',line,xx);
        break
    end

xx = strtrim(fgetl(fid));
line = line+1;
fprintf('%d:%s\n',line,xx)

end

while ~feof(fid)
    if ~isempty(strfind(xx,'LINE'))
        xx = strtrim(fgetl(fid));
        line = line+1;
        
        fprintf('%d:%s\n',line,xx)
        
        
        
        
        
        npoints = strtrim(fgetl(fid));
        line = line+1;
        
        for i = 1:6   % reading x_first ... z_last
            xx = strtrim(fgetl(fid));
            if ~isempty(strfind(xx,'EndSect'))
                break
            end
            eval(sprintf('%s;',xx))
            line = line+1;
            fprintf('%d:%s\n',line,xx)

        end
        
        fprintf('%d:%s\n',line,xx)
        
        
    end
    
    
    
    
    xx = strtrim(fgetl(fid));
    line = line+1;
    fprintf('%d:%s\n',line,xx)
    
    
    
end

    
    
    
    

fclose(fid);