function Output = fun_ReadM21FM_Discharge_locations(m21fm)
home

% Reading m21fm file

% m21fm = 'Existing_HD_calibration_round1_v13_30day.m21fm';
if nargin < 1
    [m21fm,fp] = uigetfile('*.m21fm');
else
    fp = pwd;
end
fid = fopen(fullfile(fp,m21fm));
line = 1;
dfs0_count = 1;


xx = strtrim(fgetl(fid));

while ~feof(fid)
    if ~isempty(strfind(xx,'OUTPUT_'))    % 'OUTPUT_' found!
        
        xx = strtrim(fgetl(fid));
        
        line = line+1;
        %         fprintf('%d:%s\n',line,xx);
        while isempty(strfind(xx,'OUTPUT_'))   % OUTPUT BLOCK
            
            if ~isempty(strfind(xx,'file_name')) && strfind(xx,'file_name') == 1 ...
                    && ~isempty(strfind(xx,'dfs0'))
                
                
                eval(sprintf('%s;',xx))  % read 'file_name'
%                 dfs0_name{dfs0_count,1} = file_name;
                Output(dfs0_count).dfs0_name = file_name;
                
                
                
%                fprintf('%d:%s\n',line,xx);
                
                while isempty(strfind(xx,'LINE'))
                    % Read insignificant info until [LINE]
                    xx = strtrim(fgetl(fid));
                    line = line+1;
                    
                end
                
                % [LINE] is just read
                npoints = strtrim(fgetl(fid));
                line = line+1;
                
%                fprintf('%d:%s\n',line,npoints)
                for i = 1:6   % reading x_first ... z_last
                    xx = strtrim(fgetl(fid));
                    eval(sprintf('%s;',xx))
                    line = line+1;
%                    fprintf('%d:%s\n',line,xx)
                end
%                fprintf('read output %d coordinates\n',dfs0_count)
                
                % save coordinates
                Output(dfs0_count).x = [x_first x_last];
                Output(dfs0_count).y = [y_first y_last];
                
                
                
                dfs0_count = dfs0_count + 1;
            end
            
            xx = strtrim(fgetl(fid));
            line = line+1;


        end
%        fprintf('%d:%s\n',line,xx);
    end
    
    xx = strtrim(fgetl(fid));
    line = line+1;
    %     fprintf('%d:%s\n',line,xx)
    
    
end

fclose(fid);

% Output.filenames = dfs0_name;
