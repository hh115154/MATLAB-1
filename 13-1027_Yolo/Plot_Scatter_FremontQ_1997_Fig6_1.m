clear all; close all;
orientation = 'portrait';  % 'landscape'/'portrait'
figure_type = 'Letter';    % 'Letter'/'Legal'


switch orientation
    case 'portrait'
        
        switch figure_type
            case 'Legal'
                PaperH = 14.5;
                PaperW = 10;
            case 'Letter'
                PaperH = 9;
                PaperW = 7;
        end
    case 'landscape'
        switch figure_type
            case 'Legal'
                PaperW = 15.5;
                PaperH = 9;
            case 'Letter'
                PaperW = 10;
                PaperH = 6;
        end
        
        PaperW = 15.5;
        PaperH = 9;
        %         fig_position = [20 400 800 620];
        %         fig_position = [20 50 1000 775];
end

bot_margin = 0.5;
top_margin = 0.25;
rht_margin = 0.25;
lft_margin = 0.5;

fig_position = [lft_margin bot_margin PaperW-lft_margin-rht_margin PaperH-top_margin-bot_margin];
paper_position = [.5 0 PaperW PaperH]; % controls paper margin


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
    
%     if ~isempty(intersect(modelYear(j),dry_yr))
%         curr_axis = h_axes1(1);
%     elseif ~isempty(intersect(modelYear(j),norm_yr))
%         curr_axis = h_axes1(2);
%     else
%         curr_axis = h_axes1(3);
%     end
    %% Plotting
    h_fig(j) = figure('Color','w');
    set(h_fig(j),'PaperUnits','inches','PaperSize',[PaperW PaperH], ...
        'PaperPosition',fig_position, ...
        'PaperOrientation',orientation);
    
    bot_ax = 0.05;
    top_ax = 0.03;
    rht_ax = 0.03;
    lft_ax = 0.07;
    ax_width0 = 1-lft_ax-rht_ax;
    ax_height0 = 1-top_ax-bot_ax;
    
    
    sub_gap = 0.05;
    ax_height1 = (ax_height0-sub_gap)/2;
    ax_width1  = ax_width0;
    
    ax_height2 = ax_height1;
    ax_width2  = ax_width0;
    
    
%     h_axes0 = axes('Parent',h_fig(j),'Visible','off','units','normalized', ...
%         'Position',[lft_ax bot_ax ax_width0 ax_height0]);
    
    h_axes1 = axes('Parent',h_fig(j),'Visible','off','units','normalized', ...
        'Position',[lft_ax bot_ax+ax_height2+sub_gap ax_width1 ax_height1]);
    
    h_axes2 = axes('Parent',h_fig(j),'Visible','off','units','normalized', ...
        'Position',[lft_ax bot_ax ax_width1 ax_height1]);
    
    
    
    
    
    
    
    % -----------------
%% time series plot
denom_factor = 10000;
plot(h_axes1,TS_PO_time,Data_FreQ./denom_factor)
hold(h_axes1,'on')
plot(h_axes1,freQ_time,freQ_data./denom_factor,'r')
set(h_axes1,'xlim',[datenum([modelYear(j)-1 10 1]) datenum([modelYear(j) 6 30])])
grid(h_axes1,'on')

legend(h_axes1,{'Modeled Q','Observed Q'},'location','northwest')
datetick(h_axes1,'x','mmm','keeplimits')
ylabel(h_axes1,sprintf('Q (%d cfs)',denom_factor),'fontsize',8)

set(h_axes1,'fontsize',8)


% set(h_axes1,'yticklabel',num2str(get(h_axes1,'ytick')'))
 
%% Scatter plot
curr_axis = h_axes2;

% make two dataset same in length and time scale
[C,ia,ib] = intersect(freQ_time,TS_PO_time);
scatter(curr_axis,freQ_data(ia)./denom_factor,Data_FreQ(ib)./denom_factor,10,'b','filled')
hold(curr_axis,'on')
grid(curr_axis,'on')


xlabel(h_axes2,sprintf('Observed Q (%d cfs)',denom_factor),'fontsize',8) % bottom figure

legend(h_axes2,num2str(1997),'location','northwest')

x_lim = get(h_axes2,'xlim');
y_lim = get(h_axes2,'ylim');
end_point = max(x_lim(2),y_lim(2));



set(curr_axis,'xlim',[0 end_point]);
set(curr_axis,'ylim',[0 end_point]);
plot(curr_axis,[0 end_point],[0 end_point],'k')
set(curr_axis,'fontsize',8)
ylabel(curr_axis,sprintf('Modeled Q (%d cfs)',denom_factor),'fontsize',8)

title(h_axes1,sprintf('WY %d',modelYear(j)))
print(h_fig,'-dpng','Fremont_Q_test1')