% This script uses template function file; NOT a stand-alone script

clear all; close all;
orientation = 'portrait';  % 'landscape'/'portrait'
figure_type = 'Letter';    % 'Letter'/'Legal'



cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\Time_Series_plot')

path_PO = 'PO_files';
PO = dir([path_PO '\*.csv']);

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

j = 1;
modelYear(j) = 1997;

    fname_PO = PO(j).name;
    fidPO = fopen(fullfile(path_PO,fname_PO));
    readfmt = ['%*s%f' repmat('%*f',1,23) '%f%*f%f%*f%*f%f'];
    PO_Model_data = textscan(fidPO,readfmt,'delimiter',',','headerlines',2);
    fclose(fidPO);
    
    TS_PO_hr = PO_Model_data{1};
    TS_PO = TS_PO_hr(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    
    % --------- plot data
    Data_FreWSE_w = PO_Model_data{2}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    Data_FreWSE_e = PO_Model_data{3}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    Data_FreQ = PO_Model_data{4}(TS_PO_hr>=startHr(j) & TS_PO_hr<=endHr(j));
    
        
    % in real time (datenum)
    dTS_PO = TS_PO - TS_PO(1);   % time(hour) differences from the 1st entry
    TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),TS_PO(1),'hour') + dTS_PO./24;
    
    %% Plotting
    
    bot_ax = 0.05;
    top_ax = 0.03;
%     rht_ax = 0.03;
    rht_ax = 0.05;
%     lft_ax = 0.07;
    lft_ax = 0.12;
    ax_width0 = 1-lft_ax-rht_ax;
    ax_height0 = 1-top_ax-bot_ax;
    
    
    sub_gap = 0.05;
    ax_height1 = (ax_height0-sub_gap)/2;
    ax_width1  = ax_width0;
    
    ax_height2 = ax_height1;
    ax_width2  = ax_width0;
    
    subplots = zeros(2,4);
    subplots(1,1:4) = [lft_ax bot_ax+ax_height2+sub_gap ax_width1 ax_height1];
    subplots(2,1:4) = [lft_ax bot_ax ax_width1 ax_height1];
    
    
    
    
    [hf_1,h_axes1]=cbec_fig_NO_text(figure_type,orientation,subplots);

    
    
    % -----------------
%% time series plot
denom_factor = 1;
plot(h_axes1(2),TS_PO_time,Data_FreQ./denom_factor)
hold(h_axes1(2),'on')
plot(h_axes1(2),freQ_time,freQ_data./denom_factor,'r')
set(h_axes1(2),'xlim',[datenum([modelYear(j)-1 10 1]) datenum([modelYear(j) 6 30])])
grid(h_axes1(2),'on')

legend(h_axes1(2),{'Modeled','Observed'},'location','northwest')
datetick(h_axes1(2),'x','mmm','keeplimits')

if denom_factor~=1
    ylabel(h_axes1(2),sprintf('Flow (%d cfs)',denom_factor),'fontsize',8)
else
    ylabel(h_axes1(2),'Flow (cfs)','fontsize',8)
end
set(h_axes1(2),'fontsize',8)

numtick = get(h_axes1(2),'ytick')';
strtick = cell(length(numtick),1);

for k = 1:length(strtick)
    strtick{k} = commaint(numtick(k));
end
    
set(h_axes1(2),'yticklabel',strtick)
clear numtick strtick 
%% Scatter plot

% make two dataset same in length and time scale
[C,ia,ib] = intersect(freQ_time,TS_PO_time);
scatter(h_axes1(1),freQ_data(ia)./denom_factor,Data_FreQ(ib)./denom_factor,10,'b','filled')
hold(h_axes1(1),'on')
grid(h_axes1(1),'on')




legend(h_axes1(1),num2str(1997),'location','northwest')

x_lim = get(h_axes1(1),'xlim');
y_lim = get(h_axes1(1),'ylim');
end_point = max(x_lim(1),y_lim(2));



set(h_axes1(1),'xlim',[0 end_point]);
set(h_axes1(1),'ylim',[0 end_point]);
plot(h_axes1(1),[0 end_point],[0 end_point],'k')
set(h_axes1(1),'fontsize',8)
if denom_factor ~=1
    xlabel(h_axes1(1),sprintf('Observed Flow (%d cfs)',denom_factor),'fontsize',8) % bottom figure
    ylabel(h_axes1(1),sprintf('Modeled Flow (%d cfs)',denom_factor),'fontsize',8)
else
    xlabel(h_axes1(1),'Observed Flow (cfs)','fontsize',8) % bottom figure
    ylabel(h_axes1(1),'Modeled Flow (cfs)','fontsize',8)
    
end
% title(h_axes1(2),sprintf('WY %d',modelYear(j)))

numticky = get(h_axes1(1),'ytick')';
numtickx = get(h_axes1(1),'xtick')';
strticky = cell(length(numticky),1);
strtickx = cell(length(numtickx),1);

for k = 1:length(strticky)
    strticky{k} = commaint(numticky(k));
end
for kk = 1:length(strtickx)
    strtickx{kk} = commaint(numtickx(kk));
end
    
set(h_axes1(1),'yticklabel',strticky)
set(h_axes1(1),'xticklabel',strtickx)
% clear numtick strtick 



%% R square statistic

obs_xx = freQ_data(ia); obs_xx(obs_xx==0) = NaN;
mod_yy = Data_FreQ(ib); mod_yy(mod_yy==0) = NaN;

R2 = regstats(mod_yy,obs_xx,'linear','rsquare');
Mean_OBS = nanmean(freQ_data(ia));
Mean_Comp = nanmean(Data_FreQ(ib));

RMSE = sqrt(nanmean((mod_yy-obs_xx).^2));

Sc_legend_raw = sprintf('Mean Obs = %.3f\nMean Mod = %.3f',Mean_OBS,Mean_Comp);
RMSE_c = commaint(RMSE);
Sc_legend_RMSE = sprintf('RMSE %s',RMSE_c);
Sc_legend_fit = sprintf('R2 = %.3f',R2.rsquare);
% % h_legend = legend(h_axes(ScatterPanelAxes),Sc_legend_raw,Sc_legend_fit,'Location','NorthWest');
% % h_legend = legend(h_axes(ScatterPanelAxes),h_line,Sc_legend_fit,'Location','NorthWest');
h_legend = legend(h_axes1(1),Sc_legend_RMSE,Sc_legend_fit,'Location','NorthWest');

% set(h_legend,'Box','off')
% set(h_legend,'EdgeColor',[1 1 1])
set(h_legend,'FontSize',8)

print(hf_1,'-dpng','Fremont_Q_test4')