function [t_day,d_day] = Filter_LSHB_2011_2012_data
%% Filter new 2012 data from SCWA and DWR

% ***** USE corresponding sine fit for each station: C:\Work\11-1031_Prospect_Island\Time Series Data
%
%
% at DOP, LSHB and UCS

cd('C:\Work\13-1027_Yolo');
index = 1;

% [~, ~, ~, Data_LSHB] = fun_ReadDfs0_binary('LSHB_SCWA_2012.dfs0',index,[]);
% [~, ~, ~, Data_UCS] = fun_ReadDfs0_binary('UCS_DWR_2012.dfs0',index,[]);
[~, ~, ~, Data_RAW] = fun_ReadDfs0_binary('LSHB_UpToDate.dfs0',index,[]);

Data_cut.Time = Data_RAW.Time(137235:end);
Data_cut.Data = Data_RAW.Data(137235:end);

% [Data_filt_LSHB,Time_filt_LSHB]=godin_filter(Data_LSHB.Time,Data_LSHB.Data);
% [Data_filt_UCS,Time_filt_UCS]=godin_filter(Data_UCS.Time,Data_UCS.Data);
[Data_filt,Time_filt]=godin_filter(Data_cut.Time,Data_cut.Data);

%% 1) Filter
% Data_filt_LSHB(abs(Data_filt_LSHB)<1e-29) = NaN;
% Data_filt_UCS(abs(Data_filt_UCS)<1e-29) = NaN;
Data_filt(abs(Data_filt)<1e-29) = NaN;

%% 2) Daily averaging

% [t_LSHB,d_LSHB] = daily_averaging(Time_filt_LSHB,Data_filt_LSHB);
% [t_UCS,d_UCS] = daily_averaging(Time_filt_UCS,Data_filt_UCS);
[t_day,d_day] = daily_averaging(Time_filt,Data_filt);


%% plotting

disp('plotting')

h1 = figure('Position',[100 100 800 600]);
plot(Data_cut.Time,Data_cut.Data)
hold on
plot(Time_filt,Data_filt,'r')
plot(t_day,d_day,'g.')
datetick('x',10)

grid
legend('raw data','filtered','filtered daily averaged')

%%

load(fullfile('C:\Work\13-1027_Yolo','LSHB_recent_fit.mat'));
t2013 = datenum('2013','yyyy');
t2011 = datenum('2011','yyyy');
newT = t2011:1:t2013;
plot(newT,LSHB_recent(newT),'.-')
grid
datetick('x',10)
title('year 2010')




%% filling in the gaps

% load(fullfile('C:\Work\11-1031_Prospect_Island\Time Series Data','LSHB_sine_fit.mat'));
% 
% ind_nan = find(isnan(d_day));
% d_day(ind_nan) = LSHB_fit(t_day(ind_nan));

% title('RYI filtered flow (cms)')

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

