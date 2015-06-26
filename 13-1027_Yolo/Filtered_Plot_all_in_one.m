function Filtered_Plot_all_in_one
% LSHB, RYI, UCS filtered flow
% this script plots all figures on one window (using subplot)

% close all; clear all;
tic
% LSHB flow
cd('C:\Work\11-1031_Prospect_Island\Time Series Data');
RYI = 2;
LSHB = 7;
UCS = 14;
DOP = 1;
BKS = 1;

% [~, ~, ~, Data_RYI] = fun_ReadDfs0_binary('Flow_all_update_071912_gapFilled.dfs0',RYI,[]);

% [~, ~, ~, Data_LSHB] = fun_ReadDfs0_binary('Flow_all_update_071912_gapFilled.dfs0',LSHB,[]);

[~, ~, ~, Data_UCS] = fun_ReadDfs0_binary('Flow_all_update_071912_gapFilled.dfs0',UCS,[]);

[~, ~, ~, Data_DOP] = fun_ReadDfs0_binary('Flow_all_update_071912_gapFilled.dfs0',DOP,[]);

[~, ~, ~, Data_BKS] = fun_ReadDfs0_binary('BKS_pumping_flow.dfs0',BKS,[]);


% [Data_filt_RYI,Time_filt_RYI]=godin_filter(Data_RYI.Time,Data_RYI.Data);
% [Data_filt_LSHB,Time_filt_LSHB]=godin_filter(Data_LSHB.Time,Data_LSHB.Data);
[Data_filt_UCS,Time_filt_UCS]=godin_filter(Data_UCS.Time,Data_UCS.Data);
[Data_filt_DOP,Time_filt_DOP]=godin_filter(Data_DOP.Time,Data_DOP.Data);

% Data_filt_RYI(abs(Data_filt_RYI)<1e-29) = NaN;
% Data_filt_LSHB(abs(Data_filt_LSHB)<1e-29) = NaN;
Data_filt_UCS(abs(Data_filt_UCS)<1e-29) = NaN;
Data_filt_DOP(abs(Data_filt_DOP)<1e-29) = NaN;

% figure(1)

%% -------------------------------------------------------------                          BKS

load(fullfile('C:\Work\11-1031_Prospect_Island\Time Series Data','BKS_sine_fit.mat'));

h9 = figure('Position',[100 100 1200 800]);
clf
%% BKS
subplot(2,2,1)
data_BKS = Data_BKS.Data;
date_BKS = Data_BKS.Time;

plot(date_BKS,data_BKS,'r')
hold on
% plot(date_BKS,BKS_fit(date_BKS),'linewidth',2)

newT = datenum([2008 10 1]):1:datenum([2009 9 30]);
newBKS = BKS_fit(newT);

plot(newT,newBKS,'linewidth',2)

x_axis = datenum({'2004';'2005';'2006';'2007';'2008';'2009';'2010';'2011';'2012'},'yyyy');
set(gca,'xtick',x_axis);
datetick('x',10,'keeplimits','keepticks')

legend('tidally filtered Q','sine fit (WY 2009)')
title('BKS')
grid on

%% DOP
load(fullfile('C:\Work\11-1031_Prospect_Island\Time Series Data','DOP_sine_fit.mat'));

subplot(2,2,2)

[t_day,d_day] = daily_averaging(Time_filt_DOP,Data_filt_DOP);

% plot(Data_cut.Time,Data_cut.Data)
% hold on
% plot(Time_filt_DOP,Data_filt_DOP,'r')
plot(t_day,d_day,'r')
hold on

t_start = datenum([2007 10 1]);
t_end = datenum([2008 9 30]);
newT = t_start:1:t_end;

hold on
plot(newT,DOP_fit(newT),'linewidth',2)
grid
x_axis = datenum({'2004';'2005';'2006';'2007';'2008';'2009';'2010';'2011';'2012'},'yyyy');
set(gca,'xtick',x_axis);
datetick('x',10,'keeplimits','keepticks')
legend('tidally filtered Q','sine fit (WY 2008)')

title('DOP')


%% UCS
load(fullfile('C:\Work\11-1031_Prospect_Island\Time Series Data','UCS_sine_fit3.mat'));

subplot(2,2,3)

[t_day,d_day] = daily_averaging(Time_filt_UCS,Data_filt_UCS);

% plot(Data_cut.Time,Data_cut.Data)
% hold on
% plot(Time_filt_DOP,Data_filt_DOP,'r')
plot(t_day,d_day,'r')
hold on

t_start = datenum([2008 10 1]);
t_end = datenum([2009 9 30]);
newT = t_start:1:t_end;

hold on
plot(newT,UCS_sine3(newT),'linewidth',2)
grid
x_axis = datenum({'2004';'2005';'2006';'2007';'2008';'2009';'2010';'2011';'2012'},'yyyy');
set(gca,'xtick',x_axis);
datetick('x',10,'keeplimits','keepticks')
legend('tidally filtered Q','sine fit (WY 2009)')

title('UCS')

%% LSHB
cd('C:\Work\13-1027_Yolo');
index = 1;
[~, ~, ~, Data_RAW] = fun_ReadDfs0_binary('LSHB_UpToDate.dfs0',index,[]);

Data_cut.Time = Data_RAW.Time(137235:end);
Data_cut.Data = Data_RAW.Data(137235:end);

% [Data_filt_LSHB,Time_filt_LSHB]=godin_filter(Data_LSHB.Time,Data_LSHB.Data);
% [Data_filt_UCS,Time_filt_UCS]=godin_filter(Data_UCS.Time,Data_UCS.Data);
[Data_filt,Time_filt]=godin_filter(Data_cut.Time,Data_cut.Data);

% 1) Filter
% Data_filt_LSHB(abs(Data_filt_LSHB)<1e-29) = NaN;
% Data_filt_UCS(abs(Data_filt_UCS)<1e-29) = NaN;
Data_filt(abs(Data_filt)<1e-29) = NaN;

% 2) Daily averaging

% [t_LSHB,d_LSHB] = daily_averaging(Time_filt_LSHB,Data_filt_LSHB);
% [t_UCS,d_UCS] = daily_averaging(Time_filt_UCS,Data_filt_UCS);
[t_day,d_day] = daily_averaging(Time_filt,Data_filt);


% plotting
subplot(2,2,4)

plot(t_day,d_day,'r')
hold on
%

load(fullfile('C:\Work\13-1027_Yolo','LSHB_recent_fit.mat'));
t_start = datenum([2011 10 1]);
t_end = datenum([2012 9 30]);
newT = t_start:1:t_end;

plot(newT,LSHB_recent(newT),'linewidth',2)
grid on
x_axis = datenum({'2004';'2005';'2006';'2007';'2008';'2009';'2010';'2011';'2012';'2013'},'yyyy');
set(gca,'xtick',x_axis);
datetick('x',10,'keeplimits','keepticks')
legend('tidally filtered Q','sine fit (WY 2012)')

title('LSHB')
toc



function [t_day,d_day] = daily_averaging(Time_filt,Data_filt)

dd = floor(Time_filt);  % days in integer
[dq,ia,id] = unique(dd);    % meaning dd(ia) == dq

% filtered time starting the first 'full' day; cutting off the first & last day which are incomplete.
% date1 = Time_filt_RYI(ia(1):ia(end-1)-1);
date1 = Time_filt(ia(1):end);

dUCS = Data_filt(ia(1):end);


% compute how many data in ONE day by taking diff of index 'ia'
d_ia = diff(ia);
date_avail = floor(length(date1)/d_ia(1));

date2 = date1(1:date_avail*d_ia(1));
dUCS2 = dUCS(1:date_avail*d_ia(1));


date3 = reshape(date2,d_ia(1),date_avail);
dUCS3 = reshape(dUCS2,d_ia(1),date_avail);

date_ind_num = date3(1,:);  % first time entry of each date
date_data = ceil(date_ind_num);  % because the first date is 23:52:30 - 15min/2 before the midnight

data_mean = mean(dUCS3,1);

ind_1st_valid = find(~isnan(data_mean),1,'first');
d_day = data_mean(ind_1st_valid:end);
t_day = date_data(ind_1st_valid:end);
