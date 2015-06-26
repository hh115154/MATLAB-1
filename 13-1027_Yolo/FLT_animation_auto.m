clear all
close all


%% Which to plot (depth or WSE)
plot_item = 'd';

curr_folder = pwd;

% %% run [Load_FLT_animation.m] using loop
% 
% % model_year = [1999:2004 2007:2010 2012];
% model_year = 2005:2012;
model_year = 2003:2004;
for i = 1:length(model_year)
    if model_year(i) == 1999
        continue
    end
    %% PART I: create cfg file
    cfg_name = sprintf('Load_FLT_animation%d.cfg',model_year(i));
    fidw = fopen(fullfile(curr_folder,cfg_name),'wt');
    
    fprintf(fidw,'** FLT path\n');
    
%     if model_year(i) == 2008 || model_year(i) == 2012
        flt_path = 'J:\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\%d\NearBypass\grids';
%     else
%         flt_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\%d\NearBypass\grids';
%     end
    
    fprintf(fidw,[regexprep(flt_path,'\\','\\\') '\n'],model_year(i));
    fprintf(fidw,'** what to plot? (h: WSE, d: depth, V: velocity)\n');
    fprintf(fidw,'%s\n',plot_item);
    fprintf(fidw,'** aerial image path & location\n');
    image_path = 'E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\LT Model\TUFLOW\results\aerial\1D_Bypass3.jpg';
    
    fprintf(fidw,[regexprep(image_path,'\\','\\\') '\n']);
    
    
    fprintf(fidw,'** West Trib Flow file location\n');
    trib_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\bc dbase\years';
    
    fprintf(fidw,[regexprep(trib_path,'\\','\\\') '\n']);
    
    fprintf(fidw,'** other Observed data location (.MAT)\n');
    OBS_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\OBS_data';

    fprintf(fidw,[regexprep(OBS_path,'\\','\\\') '\n']);

    fclose(fidw);
    
    %% PART II: run animation script
    Load_FLT_animation(cfg_name)
    cd(curr_folder)
 
end

%%
clear i

model_year = 1997:2012;

plot_item = 'h';
%%
for i = 1:length(model_year)
    
    %% PART I: create cfg file
    cfg_name = sprintf('Load_FLT_animation%d.cfg',model_year(i));
    fidw = fopen(fullfile(curr_folder,cfg_name),'wt');
    
    fprintf(fidw,'** FLT path\n');
    
%     if model_year(i) == 2008 || model_year(i) == 2012
        flt_path = 'J:\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\%d\NearBypass\grids';
%     else
%         flt_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\%d\NearBypass\grids';
%     end
    
    fprintf(fidw,[regexprep(flt_path,'\\','\\\') '\n'],model_year(i));
    fprintf(fidw,'** what to plot? (h: WSE, d: depth, V: velocity)\n');
    fprintf(fidw,'%s\n',plot_item);
    fprintf(fidw,'** aerial image path & location\n');
    image_path = 'E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\LT Model\TUFLOW\results\aerial\1D_Bypass3.jpg';
    
    fprintf(fidw,[regexprep(image_path,'\\','\\\') '\n']);
    
    
    fprintf(fidw,'** West Trib Flow file location\n');
    trib_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\bc dbase\years';
    
    fprintf(fidw,[regexprep(trib_path,'\\','\\\') '\n']);
    
    fprintf(fidw,'** other Observed data location (.MAT)\n');
    OBS_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\OBS_data';

    fprintf(fidw,[regexprep(OBS_path,'\\','\\\') '\n']);

    fclose(fidw);
    
    %% PART II: run animation script
    Load_FLT_animation(cfg_name)
    cd(curr_folder)

end