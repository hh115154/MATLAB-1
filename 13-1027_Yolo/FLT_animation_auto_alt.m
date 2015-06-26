clear all
close all


%% Which to plot (depth or WSE)
plot_item = 'd';

curr_folder = 'E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\MATLAB\cfg_Alts';
cd(curr_folder)

% model_year = 1997:2012;
% model_year = [2000:2009 2011 2012];
%model_year = [1997:1999 2004 2007 2009:2012];
% model_year = [1999 2004 2005 2007:2009 2012];
% model_year = [2007:2009 2012];
model_year = [2003 2004];
% alt_options = {'FreSm', 'FreLg', 'FreMed', 'SacW'};
alt_options = {'SacW'};

% alt_options = {'FreSm', 'FreLg', 'FreMed'};
%alt_options = {'SacW'};
HDD_loc = {'i','j'};

for i = 1:length(model_year)
    for k = 1:length(alt_options)
        if model_year(i) <=2004
            HDD = HDD_loc{1};
        else
            HDD = HDD_loc{2};
        end
        if k == 2 
            if i == 1
                continue
            end
        end
        %% PART I: create cfg file
        cfg_name = sprintf('Load_FLT_animation%d_%s_auto.cfg',model_year(i),alt_options{k});
        fidw = fopen(fullfile(curr_folder,cfg_name),'wt');
        % 1st
        fprintf(fidw,'** Alt type: (FreSm, FreLg, FreMed, SacW)\n');
        fprintf(fidw,'%s\n',alt_options{k});
        
        % 2nd
        fprintf(fidw,'** FLT path (Alt)\n');
        fltAlt_path = '\\Cbecm11\%s\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\%d\NearBypass\grids';
        fprintf(fidw,[regexprep(fltAlt_path,'\\','\\\') '\n'],HDD,model_year(i));
        
        % 3rd
        fprintf(fidw,'** FLT path (Existing)\n');
        fltExg_path = '\\Cbecm11\%s\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\%d\NearBypass\grids';
        fprintf(fidw,[regexprep(fltExg_path,'\\','\\\') '\n'],HDD,model_year(i));
        
        
        fprintf(fidw,'** what to plot? (h: WSE, d: depth, V: velocity)\n');
        fprintf(fidw,'%s\n',plot_item);
        fprintf(fidw,'** aerial image path & location\n');
        image_path = '\\Cbecm11\j\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\aerial\1D_Bypass3.jpg';
        
        fprintf(fidw,[regexprep(image_path,'\\','\\\') '\n']);
        
        
        fprintf(fidw,'** West Trib Flow file location\n');
        trib_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\bc dbase\years';
        
        fprintf(fidw,[regexprep(trib_path,'\\','\\\') '\n']);
        
        fprintf(fidw,'** other Observed data location (.MAT)\n');
        OBS_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\OBS_data';
        
        fprintf(fidw,[regexprep(OBS_path,'\\','\\\') '\n']);
        
        % Last item
        
        fprintf(fidw,'** Area Tabulation file location\n');
        AreaTab_path = ...
            '\\Cbecm11\%s\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\Post_Processed_2014\AgEcon\%d\Results';
        
        fprintf(fidw,[regexprep(AreaTab_path,'\\','\\\') '\n'],HDD,model_year(i));
        
        
        fclose(fidw);
        
        %% PART II: run animation script
        Load_FLT_animation_Alt1(cfg_name)
        cd(curr_folder)
        
    end
    
end