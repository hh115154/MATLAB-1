clear all; close all
% only when debugging
cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\Time_Series_plot')

path_QH = 'Q_and_H_files';
H = dir([path_QH '\*H.csv']);
% Q = dir([path_QH '\*Q.csv']);

path_OBS = 'OBS_data';
OBS = dir([path_OBS '\*.mat']);

%% Read Model Run length file (hardwired)
% [fn,pn] = uigetfile('*.cfg', 'Pick a configuration file ...');
% 
fidc = fopen('Model_Run_length.txt');
% 
% C_cfg = textscan(fidc,'%s','delimiter',sprintf('\n'));
Output = textscan(fidc,'%f%f%s%f%s','delimiter','\t','headerlines',1);
modelYear = Output{1};
startHr   = Output{2};
endHr     = Output{4};
startDate = Output{3};
endDate   = Output{5};
% 
fclose(fidc);
%%

% cd(path_PO)
% flt_path = pwd;
% 
% s = regexp(pwd,'\','split');
% model_year = str2double(s{end-2});

%%
% modelYear = 1997:2012;

%% plot setup
% Figure template
fig_text.source = 'TUFLOW model output: YBY modeled and observed data';
fig_text.proj_title='Yolo Bypass Fish Passage';
fig_text.proj_number='13-1027';
fig_text.created_by = 'SB';
% fig_text.description = ['Water surface profiles ' char(8212) ' 2' char(8211) 'year'];
fig_text.description = 'YBY Stage';
fig_text.fig_number = num2str(4);

%% -------------------- template without text box (for MS WORD template paste)
bot_ax = 0.05;
top_ax = 0.03;
rht_ax = 0.03;
% rht_ax = 0.05;
lft_ax = 0.07;
% lft_ax = 0.12;
ax_width0 = 1-lft_ax-rht_ax;
ax_height0 = 1-top_ax-bot_ax;


sub_gap = 0.05;
ax_height1 = (ax_height0-sub_gap*2)/3;
ax_width1  = ax_width0;

ax_height2 = ax_height1;
ax_width2  = ax_width0;

subplots = zeros(2,4);
subplots(3,1:4) = [lft_ax bot_ax+ax_height1*2+sub_gap*2 ax_width1 ax_height1];
subplots(2,1:4) = [lft_ax bot_ax+ax_height1+sub_gap ax_width1 ax_height1];
subplots(1,1:4) = [lft_ax bot_ax ax_width1 ax_height1];



orientation = 'portrait';  % 'landscape'/'portrait'
figure_type = 'Letter';    % 'Letter'/'Legal'


[hf_1,h_axes1]=cbec_fig_NO_text(figure_type,orientation,subplots);



%% TS: OBS data

for j = 1:length(OBS)   % read MAT files for OBS data
    load([path_OBS '\' OBS(j).name])
end

%{
variable names
freH_time, freH_data : hourly
freQ_time, freQ_data : daily
vonQ_time, vonQ_data : daily
yby_time, yby_data   : hourly
%}

%% TS: PO files (model results)
% line_color = ...
%     {'b','r','g','c','k','m','b','r','g','c','k','m','b','r','g','c','k','m'};
line_color = {'b','r','g','b','b','r','r','g','c','c','g','c','k','k','k','m'};

min_value_old = 0;
max_value_old = 0;

%% year category
dry_yr  = [2001 2002 2007 2008 2009];
norm_yr = [2000 2003 2004 2005 2010 2012];
wet_yr  = [1997:1999 2006 2011];

dry_yr2 = dry_yr;
norm_yr2 = norm_yr;
wet_yr2 = wet_yr;
%% Modeled data

for j = 1:length(modelYear)
    
    fname_Q = H(j).name;
    fidQ = fopen(fullfile(path_QH,fname_Q));
    readfmth = ['%*f%*s' repmat('%*f',1,828) '%f' repmat('%*f',1,168) '%f%*f%*f%*f%f%*[^\n]' ];
    ybyH = textscan(fidQ,readfmth,'delimiter',',','headerlines',1,'bufsize',100000);
    fclose(fidQ);
    yby_Data = ybyH{2};
    
    t_interval = 6;
    yby_time_model = datenum(startDate{j}):t_interval/24:datenum(endDate{j});
    yby_time_model = yby_time_model';
%     TS_PO_hr = VON_Q_1D{1};
%     TS_PO = TS_PO_hr(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
%     
%     % --------- plot data
%     Data_FreWSE_w = VON_Q_1D{2}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
%     Data_FreWSE_e = VON_Q_1D{3}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
%     Data_FreQ = VON_Q_1D{4}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    
        
%     % in real time (datenum)
%     dTS_PO = TS_PO - TS_PO(1);   % time(hour) differences from the 1st entry
%     TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),TS_PO(1),'hour') + dTS_PO./24;
    
    if ~isempty(intersect(modelYear(j),dry_yr))
        curr_axis = h_axes1(1);
    elseif ~isempty(intersect(modelYear(j),norm_yr))
        curr_axis = h_axes1(2);
    else
        curr_axis = h_axes1(3);
    end
    
    %% make two dataset same in length and time scale
    [C,ia,ib] = intersect(yby_time,yby_time_model);
    scatter(curr_axis,yby_data(ia),yby_Data(ib),5,line_color{j},'filled')
    hold(curr_axis,'on')
    grid(curr_axis,'on')
    
    %% save data into a cell array for statistical analysis 'later': different years to be grouped
    
    if ~isempty(intersect(modelYear(j),dry_yr2))
        [~,wy_ind] = intersect(dry_yr2,modelYear(j));
        dry_mod{wy_ind} = yby_Data(ib);
        dry_obs{wy_ind} = yby_data(ia);
        
        clear wy_ind
    elseif ~isempty(intersect(modelYear(j),norm_yr2))
        [~,wy_ind] = intersect(norm_yr2,modelYear(j));
        nor_mod{wy_ind} = yby_Data(ib);
        nor_obs{wy_ind} = yby_data(ia);
        
        clear wy_ind
    else
        [~,wy_ind] = intersect(wet_yr2,modelYear(j));
        wet_mod{wy_ind} = yby_Data(ib); 
        wet_obs{wy_ind} = yby_data(ia);
        
        clear wy_ind
    end


end
%% R-square and RMSE

% Dry years
DRY_obs = cell2mat(dry_obs'); 
DRY_mod = cell2mat(dry_mod'); 

NOR_obs = cell2mat(nor_obs');
NOR_mod = cell2mat(nor_mod'); 

WET_obs = cell2mat(wet_obs');
WET_mod = cell2mat(wet_mod'); 

% R-square

% DRY years
obs_xx_dry = DRY_obs; obs_xx_dry(obs_xx_dry==0) = NaN;
mod_yy_dry = DRY_mod; mod_yy_dry(mod_yy_dry==0) = NaN;
R2_dry = regstats(mod_yy_dry,obs_xx_dry,'linear','rsquare');
RMSE_dry = sqrt(nanmean((mod_yy_dry-obs_xx_dry).^2));

% NORM years
obs_xx_norm = NOR_obs; obs_xx_norm(obs_xx_norm==0) = NaN;
mod_yy_norm = NOR_mod; mod_yy_norm(mod_yy_norm==0) = NaN;
R2_norm = regstats(mod_yy_norm,obs_xx_norm,'linear','rsquare');
RMSE_norm = sqrt(nanmean((mod_yy_norm-obs_xx_norm).^2));

% WET years
obs_xx_wet = WET_obs; obs_xx_wet(obs_xx_wet==0) = NaN;
mod_yy_wet = WET_mod; mod_yy_wet(mod_yy_wet==0) = NaN;
R2_wet = regstats(mod_yy_wet,obs_xx_wet,'linear','rsquare');
RMSE_wet = sqrt(nanmean((mod_yy_wet-obs_xx_wet).^2));


%% Scatter plot
    
xlabel(h_axes1(3),'Modeled Stage (ft)','fontsize',8) % bottom figure

legend(h_axes1(1),num2str(dry_yr'),'location','northwest')
legend(h_axes1(2),num2str(norm_yr'),'location','northwest')
legend(h_axes1(3),num2str(wet_yr'),'location','northwest')

x_lim = get(h_axes1(3),'xlim');
y_lim = get(h_axes1(3),'ylim');
end_point = max(x_lim(2),y_lim(2));


patch_y_low = end_point*.03;
gap_inside_box = end_point*.006;

t_x = end_point*.84;
t_y = end_point*.15;

patch_xs = [t_x-gap_inside_box t_x-gap_inside_box end_point-patch_y_low*.5 end_point-patch_y_low*.5];
patch_ys = [patch_y_low t_y+gap_inside_box t_y+gap_inside_box patch_y_low];

for k = 1:3  % number of subplots
    curr_axis = h_axes1(k);
    set(curr_axis,'xlim',[0 end_point]);
    set(curr_axis,'ylim',[0 end_point]);
    plot(curr_axis,[0 end_point],[0 end_point],'k')
    set(curr_axis,'fontsize',8)
    ylabel(curr_axis,'Modeled Stage (ft)','fontsize',8)
    
    
    if k == 1
        text_axes1 = {sprintf('R2 = %.3f',R2_dry.rsquare); ...
            sprintf('RMSE = %.3f',RMSE_dry)};
        
        C = [0 0 0 0];
        patch(patch_xs,patch_ys,C,'facecolor','w')
        text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',8)
        
        
    elseif k == 2
        set(gcf,'CurrentAxes',h_axes1(k))
        
        text_axes1 = {sprintf('R2 = %.3f',R2_norm.rsquare); ...
            sprintf('RMSE = %.3f',RMSE_norm)};
        % text(20.3,13,text_axes1,'VerticalAlignment','top','fontsize',8)
        
        C = [0 0 0 0];
        patch(patch_xs,patch_ys,C,'facecolor','w')
        text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',8)
        
    else
        set(gcf,'CurrentAxes',h_axes1(k))
        
        text_axes1 = {sprintf('R2 = %.3f',R2_wet.rsquare); ...
            sprintf('RMSE = %.3f',RMSE_wet)};
        % text(20.3,13,text_axes1,'VerticalAlignment','top','fontsize',8)

        C = [0 0 0 0];
        patch(patch_xs,patch_ys,C,'facecolor','w')
        text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',8)

        
    end

end

% title(h_axes1(1),sprintf('Dry years: R^2 = %.3f, RMSE = %.3f',R2_dry.rsquare,RMSE_dry))
% title(h_axes1(2),sprintf('Normal years: R^2 = %.3f, RMSE = %.3f',R2_norm.rsquare,RMSE_norm))
% title(h_axes1(3),sprintf('Wet years: R^2 = %.3f, RMSE = %.3f',R2_wet.rsquare,RMSE_wet))

title(h_axes1(1),'Dry years')
title(h_axes1(2),'Normal years')
title(h_axes1(3),'Wet years')

print(hf_1,'-dpng','Fig_6-4_YBY_WSE')




