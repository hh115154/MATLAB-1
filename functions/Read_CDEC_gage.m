function [time_cdec, data_cdec] = Read_CDEC_gage(csv_name)

% ts_all: continuous time step
% cdec_data: raw data as in cdec csv file (no unit conversion)

% Reading CDEC gage data (Dos Rios data)

% fid = fopen('SJp_07012011_to07312011_updated.txt');
% fid = fopen('MRB_July2011_Stage.csv');

fid = fopen(csv_name);
% C = textscan(fid,'%*s%*f%s%s%*s%f%*s','headerlines',26);
C = textscan(fid,'%13c%f','headerlines',2,'delimiter',',');

YMDHM = C{1};

ts = datenum(YMDHM,'yyyymmdd,HHMM');
ts_diff = diff(ts);

dt = mode(ts_diff);  % data time interval (in day)
dt = dt*24;          % (in hour)
time_gap = round(dt*60);

ts_all = ts(1)*60*24:time_gap:ts(end)*60*24;
ts_all = ts_all';

data_cdec = zeros(length(ts_all),1);
%% filling the gaps

ts_ = ts.*60*24;


[int_ts,ia,ib] = intersect(ts_,ts_all);

data_cdec(ib) = C{2};
data_cdec(data_cdec==0) = NaN;
data_cdec(data_cdec<-5000) = NaN;


new_Q_cms = data_cdec.*(1200/3937)^3;

plot(ts_all./24/60,data_cdec,'.')

time_cdec = ts_all./24/60;

x_axis = datenum({'1995';'1996';'1997';'1998'; ...
    '1999';'2000';'2001';'2002';'2003';'2004'; ...
    '2005';'2006';'2007';'2008';'2009';'2010'; ...
    '2011';'2012'},'yyyy');
set(gca,'xtick',x_axis);
datetick('x',10,'keeplimits','keepticks')

axis tight
% datetick('x',6,'keeplimits','keepticks')
grid
