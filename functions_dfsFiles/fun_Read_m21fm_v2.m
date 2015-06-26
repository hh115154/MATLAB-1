function Output = fun_Read_m21fm_v2(m21fm)
home

% Reading m21fm file

m21fm = 'Existing_HD_calibration_round1_v13_30day.m21fm';
fid = fopen(m21fm);
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
                dfs0_name{dfs0_count,1} = file_name;
                
                
                
                fprintf('%d:%s\n',line,xx);
                
                while isempty(strfind(xx,'LINE'))
                    % Read insignificant info until [LINE]
                    xx = strtrim(fgetl(fid));
                    line = line+1;
                    
                end
                
                % [LINE] is just read
                npoints = strtrim(fgetl(fid));
                line = line+1;
                
                fprintf('%d:%s\n',line,npoints)
                for i = 1:6   % reading x_first ... z_last
                    xx = strtrim(fgetl(fid));
%                     if ~isempty(strfind(xx,'EndSect'))
%                         break
%                     end
                    eval(sprintf('%s;',xx))
                    line = line+1;
                    fprintf('%d:%s\n',line,xx)
                end
                fprintf('read output %d coordinates\n',dfs0_count)
                
                
                
                dfs0_count = dfs0_count + 1;

                                
            end
            
            %             if ~isempty(strfind(xx,'LINE'))
            %                 npoints = strtrim(fgetl(fid));
            %                 line = line+1;
            %
            %                 fprintf('%d:%s\n',line,npoints)
            %                 for i = 1:6   % reading x_first ... z_last
            %                     xx = strtrim(fgetl(fid));
            %                     if ~isempty(strfind(xx,'EndSect'))
            %                         break
            %                     end
            %                     eval(sprintf('%s;',xx))
            %                     line = line+1;
            %                     fprintf('%d:%s\n',line,xx)
            %                 end
            %             end
            
            
            
            xx = strtrim(fgetl(fid));
            line = line+1;


        end
        fprintf('%d:%s\n',line,xx);
    end
    
    
    
    
    
    
    
    
    
    
    
    
    xx = strtrim(fgetl(fid));
    line = line+1;
    %     fprintf('%d:%s\n',line,xx)
    
    
end




















% 
% 
% 
% 
% while ~feof(fid)
%     
%     if ~isempty(strfind(xx,'file_name')) && strfind(xx,'file_name') == 1 ...
%             && ~isempty(strfind(xx,'dfs0'))
%         
%         eval(xx)    % first dfs0 file located!!!
% %         xx = strtrim(fgetl(fid));
% %         line = line+1;
% %         fprintf('%d:%s\n',line,xx);
%         break
%     end
% 
% xx = strtrim(fgetl(fid));
% line = line+1;
% fprintf('%d:%s\n',line,xx)
% 
% end
% 
% while ~feof(fid)
%     if ~isempty(strfind(xx,'LINE'))
%         xx = strtrim(fgetl(fid));
%         line = line+1;
%         
%         fprintf('%d:%s\n',line,xx)
%         
%         
%         
%         
%         
%         npoints = strtrim(fgetl(fid));
%         line = line+1;
%         
%         for i = 1:6   % reading x_first ... z_last
%             xx = strtrim(fgetl(fid));
%             if ~isempty(strfind(xx,'EndSect'))
%                 break
%             end
%             eval(sprintf('%s;',xx))
%             line = line+1;
%             fprintf('%d:%s\n',line,xx)
% 
%         end
%         
%         fprintf('%d:%s\n',line,xx)
%         
%         
%     end
%     
%     
%     
%     
%     xx = strtrim(fgetl(fid));
%     line = line+1;
%     fprintf('%d:%s\n',line,xx)
%     
%     
%     
% end

    
    
    
    

fclose(fid);