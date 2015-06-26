clear all
close all


%% Which to plot (depth or WSE)
plot_item = 'd';

curr_folder = 'E:\Work\Projects\13-1027_Yolo_Bypass_Fish_Passage\MATLAB\cfg_for_Fig7';
cd(curr_folder)

%% Read snapshots date
fids = fopen('Fig7_9_time_stamps.txt');
SN = textscan(fids,'%f%f%f');
% SN = textscan(fids,'%10c');

fclose(fids);

model_year = 1997:2012;
% model_year = 2000:2012;
alt_options = {'FreSm', 'FreLg', 'FreMed', 'SacW'};
% alt_options = {'SacW'};

% HDD_loc = {'i','j'};
HDD_loc = {'k','k'};
for i = 1:length(model_year)
        if model_year(i) <=2004
            HDD = HDD_loc{1};
        else
            HDD = HDD_loc{2};
        end
%         if k == 2 
%             if i == 1
%                 continue
%             end
%         end
        %% PART I: create cfg file
        cfg_name = sprintf('Fig_7-9_%d_Kdrive_auto.cfg',model_year(i));
        fidw = fopen(fullfile(curr_folder,cfg_name),'wt');
        % 1st
        fprintf(fidw,'** Alt type: (FreSm, FreLg, FreMed, SacW)\n');
        fprintf(fidw,'%s, %s, %s, %s\n','FreSm', 'FreLg', 'FreMed', 'SacW');
        
        % 2nd
        fprintf(fidw,'** FLT path (Alt)\n');
        
        if model_year(i) == 1997;
            fltAlt_path = '\\Cbecm11\i\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\%d\NearBypass\grids';
            fprintf(fidw,[regexprep(fltAlt_path,'\\','\\\') '\n'],model_year(i));
        else
            fltAlt_path = '\\Cbecm11\%s\Raw Results\%d\NearBypass\grids';
            fprintf(fidw,[regexprep(fltAlt_path,'\\','\\\') '\n'],HDD,model_year(i));
        end
        
        
        
        % 3rd
        fprintf(fidw,'** FLT path (Existing)\n');
        % fltExg_path = '\\Cbecm11\%s\Raw Results\%d\NearBypass\grids';
        fltExg_path = fltAlt_path;
        if model_year(i) == 1997
            fprintf(fidw,[regexprep(fltExg_path,'\\','\\\') '\n'],model_year(i));
        else
            fprintf(fidw,[regexprep(fltExg_path,'\\','\\\') '\n'],HDD,model_year(i));
        end
        
        
        fprintf(fidw,'** what to plot? (h: WSE, d: depth, V: velocity)\n');
        fprintf(fidw,'%s\n',plot_item);
        fprintf(fidw,'** aerial image path & location | shp outline location\n');
        image_path = '\\Cbecm11\j\Work\Projects\13-1027_YBM\LT_Model\TUFLOW\results\Aerial\Arc10_topo_basemap_v5_600dpi.jpg';
        
        fprintf(fidw,[regexprep(image_path,'\\','\\\') '\n']);
        
        
        fprintf(fidw,'** West Trib Flow file location\n');
        trib_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\bc dbase\years';
        
        fprintf(fidw,[regexprep(trib_path,'\\','\\\') '\n']);
        
        fprintf(fidw,'** other Observed data location (.MAT)\n');
        OBS_path = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\results\OBS_data';
        
        fprintf(fidw,[regexprep(OBS_path,'\\','\\\') '\n']);
        
        fprintf(fidw,'** Area Tabulation file location\n');
        AreaTab_path = ...
            '\\Cbecm11\%s\Results - Post Processed\Ag Econ\%d\Results';
        
        fprintf(fidw,[regexprep(AreaTab_path,'\\','\\\') '\n'],HDD,model_year(i));

        % Last item
        fprintf(fidw,'** Snapshot date\n');
        ind_y = find(SN{1} == model_year(i));
        
%         fprintf(fidw,'%d %d %d',SN{1}(ind_y),SN{2}(ind_y),SN{3}(ind_y));
        fprintf(fidw,'%d %d %d',SN{1}(i),SN{2}(i),SN{3}(i));
        
        
        fclose(fidw);
        
        %% PART II: run animation script
        Fig_7_10_animation_snapshots_doubleYaxis(cfg_name)
        cd(curr_folder)
        
    
end