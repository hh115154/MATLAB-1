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
fig_text.source = 'TUFLOW model output: LIS modeled and observed data';
fig_text.proj_title='Yolo Bypass Fish Passage';
fig_text.proj_number='13-1027';
fig_text.created_by = 'SB';
% fig_text.description = ['Water surface profiles ' char(8212) ' 2' char(8211) 'year'];
fig_text.description = 'LIS Stage';
fig_text.fig_number = num2str(5);

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

lisH_time, lisH_data : 15 min
liyH_time, liyH_data : 15 min
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
    yby_Data = ybyH{3};  % 1: liy, 2: yby, 3: lis
    
    t_interval = 6; % modeled time interval
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
    [C,ia,ib] = intersect(lisH_time,yby_time_model);
    scatter(curr_axis,lisH_data(ia),yby_Data(ib),5,line_color{j},'filled')
    hold(curr_axis,'on')
    grid(curr_axis,'on')
        
    
    %% save data into a cell array for statistical analysis 'later': different years to be grouped
    
    if ~isempty(intersect(modelYear(j),dry_yr2))
        [~,wy_ind] = intersect(dry_yr2,modelYear(j));
        dry_mod{wy_ind} = yby_Data(ib);
        dry_obs{wy_ind} = lisH_data(ia);
        
        clear wy_ind
    elseif ~isempty(intersect(modelYear(j),norm_yr2))
        [~,wy_ind] = intersect(norm_yr2,modelYear(j));
        nor_mod{wy_ind} = yby_Data(ib);
        nor_obs{wy_ind} = lisH_data(ia);
        
        clear wy_ind
    else
        [~,wy_ind] = intersect(wet_yr2,modelYear(j));
        wet_mod{wy_ind} = yby_Data(ib); 
        wet_obs{wy_ind} = lisH_data(ia);
        
        clear wy_ind
    end


end
%% R-square and RMSE

%% year category
% dry_yr  = [2001 2002 2007 2008 2009];
% norm_yr = [2000 2003 2004 2005 2010 2012];
% wet_yr  = [1997:1999 2006 2011];

% --------------------------------------------separate pre- 2005 years
% Pre-2005
DRY_obs1 = cell2mat(dry_obs(1:2)'); 
DRY_mod1 = cell2mat(dry_mod(1:2)'); 

NOR_obs1 = cell2mat(nor_obs(1:4)');
NOR_mod1 = cell2mat(nor_mod(1:4)'); 

WET_obs1 = cell2mat(wet_obs(1:3)');
WET_mod1 = cell2mat(wet_mod(1:3)'); 

% R-square

% DRY years
obs_xx_dry1 = DRY_obs1; obs_xx_dry1(obs_xx_dry1==0) = NaN;
mod_yy_dry1 = DRY_mod1; mod_yy_dry1(mod_yy_dry1==0) = NaN;
R2_dry1 = regstats(mod_yy_dry1,obs_xx_dry1,'linear','rsquare');
RMSE_dry1 = sqrt(nanmean((mod_yy_dry1-obs_xx_dry1).^2));

% NORM years
obs_xx_norm1 = NOR_obs1; obs_xx_norm1(obs_xx_norm1==0) = NaN;
mod_yy_norm1 = NOR_mod1; mod_yy_norm1(mod_yy_norm1==0) = NaN;
R2_norm1 = regstats(mod_yy_norm1,obs_xx_norm1,'linear','rsquare');
RMSE_norm1 = sqrt(nanmean((mod_yy_norm1-obs_xx_norm1).^2));

% WET years
obs_xx_wet1 = WET_obs1; obs_xx_wet1(obs_xx_wet1==0) = NaN;
mod_yy_wet1 = WET_mod1; mod_yy_wet1(mod_yy_wet1==0) = NaN;
R2_wet1 = regstats(mod_yy_wet1,obs_xx_wet1,'linear','rsquare');
RMSE_wet1 = sqrt(nanmean((mod_yy_wet1-obs_xx_wet1).^2));


% --------------------------------------------separate post- 2005 years
% Post-2005
DRY_obs2 = cell2mat(dry_obs(3:end)'); 
DRY_mod2 = cell2mat(dry_mod(3:end)'); 

NOR_obs2 = cell2mat(nor_obs(5:end)');
NOR_mod2 = cell2mat(nor_mod(5:end)'); 

WET_obs2 = cell2mat(wet_obs(4:end)');
WET_mod2 = cell2mat(wet_mod(4:end)'); 

% R-square

% DRY years
obs_xx_dry2 = DRY_obs2; obs_xx_dry2(obs_xx_dry2==0) = NaN;
mod_yy_dry2 = DRY_mod2; mod_yy_dry2(mod_yy_dry2==0) = NaN;
R2_dry2 = regstats(mod_yy_dry2,obs_xx_dry2,'linear','rsquare');
RMSE_dry2 = sqrt(nanmean((mod_yy_dry2-obs_xx_dry2).^2));

% NORM years
obs_xx_norm2 = NOR_obs2; obs_xx_norm2(obs_xx_norm2==0) = NaN;
mod_yy_norm2 = NOR_mod2; mod_yy_norm2(mod_yy_norm2==0) = NaN;
R2_norm2 = regstats(mod_yy_norm2,obs_xx_norm2,'linear','rsquare');
RMSE_norm2 = sqrt(nanmean((mod_yy_norm2-obs_xx_norm2).^2));

% WET years
obs_xx_wet2 = WET_obs2; obs_xx_wet2(obs_xx_wet2==0) = NaN;
mod_yy_wet2 = WET_mod2; mod_yy_wet2(mod_yy_wet2==0) = NaN;
R2_wet2 = regstats(mod_yy_wet2,obs_xx_wet2,'linear','rsquare');
RMSE_wet2 = sqrt(nanmean((mod_yy_wet2-obs_xx_wet2).^2));




%% Scatter plot
    
xlabel(h_axes1(3),'Observed Stage (ft)','fontsize',8) % bottom figure

legend(h_axes1(1),num2str(dry_yr'),'location','northwest')
legend(h_axes1(2),num2str(norm_yr'),'location','northwest')
legend(h_axes1(3),num2str(wet_yr'),'location','northwest')

x_lim = get(h_axes1(3),'xlim');
y_lim = get(h_axes1(3),'ylim');
end_point = max(x_lim(2),y_lim(2));


%% patches 
patch_y_low = 1.1;
t_x = end_point*.82;
t_y = end_point*.4;

patch_xs = [t_x-.2 t_x-.2 end_point-.4 end_point-.4];
patch_ys = [patch_y_low t_y+.2 t_y+.2 patch_y_low];


for k = 1:3  % number of subplots
    curr_axis = h_axes1(k);
    set(curr_axis,'xlim',[0 end_point]);
    set(curr_axis,'ylim',[0 end_point]);
    plot(curr_axis,[0 end_point],[0 end_point],'k')
    set(curr_axis,'fontsize',8)
    ylabel(curr_axis,'Modeled Stage (ft)','fontsize',8)
    
    % Statistical info
    
    if k == 1
        text_axes1 = {'2005 and prior:'; ...
            sprintf('   R2 = %.3f',R2_dry1.rsquare); ...
            sprintf('   RMSE = %.3f',RMSE_dry1); ...
            'Post-2005:'; ...
            sprintf('   R2 = %.3f',R2_dry2.rsquare); ...
            sprintf('   RMSE = %.3f',RMSE_dry2)};
        
        
        C = [0 0 0 0];
        patch(patch_xs,patch_ys,C,'facecolor','w')
        text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',8)
        
        
    elseif k == 2
        set(gcf,'CurrentAxes',h_axes1(k))
        
        text_axes1 = {'2005 and prior:'; ...
            sprintf('   R2 = %.3f',R2_norm1.rsquare); ...
            sprintf('   RMSE = %.3f',RMSE_norm1); ...
            'Post-2005:'; ...
            sprintf('   R2 = %.3f',R2_norm2.rsquare); ...
            sprintf('   RMSE = %.3f',RMSE_norm2)};
        % text(20.3,13,text_axes1,'VerticalAlignment','top','fontsize',8)
        
        C = [0 0 0 0];
        patch(patch_xs,patch_ys,C,'facecolor','w')
        text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',8)

        
    else
        set(gcf,'CurrentAxes',h_axes1(k))
        
        text_axes1 = {'2005 and prior:'; ...
            sprintf('   R2 = %.3f',R2_wet1.rsquare); ...
            sprintf('   RMSE = %.3f',RMSE_wet1); ...
            'Post-2005:'; ...
            sprintf('   R2 = %.3f',R2_wet2.rsquare); ...
            sprintf('   RMSE = %.3f',RMSE_wet2)};
        % text(20.3,13,text_axes1,'VerticalAlignment','top','fontsize',8)
        
        C = [0 0 0 0];
        patch(patch_xs,patch_ys,C,'facecolor','w')
        text(t_x,t_y,text_axes1,'VerticalAlignment','top','fontsize',8)

        
    end

end
% title1 = sprintf('Dry years: R^2 = %.3f, RMSE = %.3f (pre-2005) R^2 = %.3f, RMSE = %.3f (post-2005)', ...
%     R2_dry1.rsquare,RMSE_dry1,R2_dry2.rsquare,RMSE_dry2);
% title2 = sprintf('Normal years: R^2 = %.3f, RMSE = %.3f (pre-2005) R^2 = %.3f, RMSE = %.3f (post-2005)', ...
%     R2_norm1.rsquare,RMSE_norm1,R2_norm2.rsquare,RMSE_norm2);
% title3 = sprintf('Wet years: R^2 = %.3f, RMSE = %.3f (pre-2005) R^2 = %.3f, RMSE = %.3f (post-2005)', ...
%     R2_wet1.rsquare,RMSE_wet1,R2_wet2.rsquare,RMSE_wet2);
% 
% title(h_axes1(1),title1)
% title(h_axes1(2),title2)
% title(h_axes1(3),title3)

title(h_axes1(1),'Dry years')
title(h_axes1(2),'Normal years')
title(h_axes1(3),'Wet years')

print(hf_1,'-dpng','Fig_6-5_LIS_WSE')




