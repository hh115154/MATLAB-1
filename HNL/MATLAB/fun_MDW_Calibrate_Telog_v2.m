function [RGcell,FMcell,DW] = fun_MDW_Calibrate_Telog_v2(IN)

global st_name st_num PathName
%% Read input file
[FileNameDATA,PathName] = uigetfile( ...
    {'*.csv',  'comma separated variables (*.csv)'; ...
    '*.xlsx','Excel file (*.xlsx)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick a DATA file');

fid = fopen(fullfile(PathName,FileNameDATA));
% readData = '%s%f%*f%*f%f';
readData = '%2c/%2c/%2c\t%2c:%2c:%2c%f%*f%*f%f';
C = textscan(fid,readData,'delimiter',',','headerlines',1);

tic
if length(C{1}) ~= length(C{2})
    D = [str2num(C{3}) str2num(C{1}(1:length(C{2}),:)) str2num(C{2}) str2num(C{4}) str2num(C{5}) str2num(C{6})];
else
    D = [str2num(C{3}) str2num(C{1}) str2num(C{2}) str2num(C{4}) str2num(C{5}) str2num(C{6})];
end
toc
D(:,1) = D(:,1) + 2000;


fclose(fid);

PathFigures = [PathName 'Figures'];
if exist(PathFigures,'dir')==0
    mkdir(PathFigures)
end
PathTables = [PathName 'Tables'];
if exist(PathTables,'dir')==0
    mkdir(PathTables)
end
%% limit data usage for DWF
SummerOnly = 1;

% fidData = fopen(fullfile(DataFile.PN,DataFile.FN));

%% Read flowmeter
% fidFM = fopen(fullfile(IN.FM.path,IN.FM.name));
% readFMId = '%*s%s%*f%*f%f%*[^\n]';
% FM = textscan(fidFM,readFMId,'delimiter',',','headerlines',1);
% fclose(fidFM);
% 
% %% Read Rain gauge
% fidRG = fopen(fullfile(IN.RG.path,IN.RG.name));
% readRGId = '%*s%s%f%*[^\n]';
% RG = textscan(fidRG,readRGId,'delimiter',',','headerlines',1);
% fclose(fidRG);

%%
% ts: equidistant time series
tsRaw = datenum(D);

if round(mode(diff(tsRaw))*60*24) ~= IN.RG.dt
    dGap = round(mode(diff(tsRaw))*60*24);  % 'mode' of dt in data
else
    dGap = IN.RG.dt;
end
tsEqu = datenum(D(1,:)):dGap/60/24:datenum(D(end,:));

FMraw = C{end-1}(1:length(tsRaw));
RGraw = C{end}(1:length(tsRaw));

% replace NaN in RGraw with ZEROs for interpolation purpose
RGraw(isnan(RGraw)) = 0;

ind_nan = isnan(FMraw);
% plot only non-NaN
if ispc
    st_nameId = regexp(PathName, '\\', 'split');
    st_name = st_nameId{end-1};
    
    st_numId = regexp(FileNameDATA,' ','split');
    st_num = st_numId{1};  % str variable
else
    st_nameId = regexp(PathName, '/', 'split');
    st_name = st_nameId{end-1};
    
    st_numId = regexp(FileNameDATA,' ','split');
    st_num = st_numId{1};  % str variable
end

FM = interp1(tsRaw(~ind_nan),FMraw(~ind_nan),tsEqu);
RG = interp1(tsRaw,RGraw,tsEqu);  % NaN in RG has been replaced by zeros already

%% Exclude data gap (not the regular widened intervals)
%  DataSum = sum(a(~isnan(a))); % if there's NaN in the array

% [ai,bi] = intersect(tsEqu,tsRaw(ind_nan));  
% %   [bi] is to find missing data when there are time string not missing
% %   FM(bi) = NaN;  will remove all interpolated data

%% to remove gaps where time stamps are missing
% xxx = diff(tsRaw).*60*24;   % in minutes
% tsRawGapInd = find(xxx > dGap+1);  % 5 + 1 = 6 minutes
% for i = 1:length(tsRawGapInd)
%     
%     
%     
%     
%     
% end

%% Find indices for 00:00 of each day

% save all data before replacing them with summer months data

StartSummer = datenum([2010 7 1 0 0 0]);
EndSummer = datenum([2010 10 1 0 0 0]);
if SummerOnly
    FM_all = FM;
    RG_all = RG;
    tsEqu_all = tsEqu;
    
    indSummer = find(tsEqu>=StartSummer & tsEqu<EndSummer);
    FM = FM(indSummer);
    RG = RG(indSummer);
    tsEqu = tsEqu(indSummer);
else
    FM_all = FM;
    RG_all = RG;
    tsEqu_all = tsEqu;
    
end

indHrRG_1st = find(mod(tsEqu(1:24*60/dGap*2),1)==0,1);
indHrRG = indHrRG_1st:24*60/IN.RG.dt:length(tsEqu);
indHrFM = indHrRG;

%%
% Hf_1 = figure('NumberTitle','off','Name',sprintf('Meter Data %s: %s',st_name,st_num));
% set(Hf_1,'Units','pixel','Position',[100 100 800 600]);
% 
% plot(tsRaw,FMraw,'ro')
% hold on
% plot(tsEqu,FM,'.-')
% title(sprintf('Flodar Meter, Basin: %s, Meter number: %s',st_name,st_num))
% legend('Data (raw)','Data (gap filled)')
% grid
% set(gca,'xlim',[StartSummer EndSummer]);
% 
% datetick('x',2,'keepticks')
% xlabel('day')
% ylabel('MGD')
% 
% FigName1 = sprintf('%s_%s_FM',st_num,st_name);
% print(Hf_1,'-dpng',fullfile(PathName,FigName1))

%% Calculate daily statistics: total rain, avg, minimum

%% step 1 & 3
if length(indHrRG) ~= EndSummer-StartSummer
    fprintf(1,'Date missing from original data\n')
end

pDailyRain = zeros(length(indHrRG),1);
pDaysSinceRain = zeros(length(indHrRG),1);

for i = 1:length(indHrRG)
    if i == length(indHrRG)
        pDailyRain(i) = sum(RG(indHrRG(i):end));
        if pDailyRain(i) <= 0.01
            pDaysSinceRain(i) = 1;
        end
    else
        pDailyRain(i) = sum(RG(indHrRG(i):indHrRG(i+1)-1));
        if pDailyRain(i) <= 0.01
            if i == 1
                pDaysSinceRain(i) = 1;
            else
                pDaysSinceRain(i) = pDaysSinceRain(i-1) + 1;
            end
        end
    end
    
end

%% step 2
if length(indHrFM) ~= EndSummer-StartSummer
    fprintf(1,'Date missing from original data\n')
end

pTotalFlow = zeros(length(indHrFM),1);
pAvgFlow = zeros(length(indHrFM),1);
pMinFlow = zeros(length(indHrFM),1);
for i = 1:length(indHrFM)
    if i == length(indHrFM)  % last day
%         FMDailyBlock = FM(indHrFM(i):end);
        FMDailyBlock = FMraw(tsRaw>=tsEqu(indHrFM(i)) & tsRaw<tsEqu(indHrFM(end)) +1);
        FMDailyBlock(FMDailyBlock == 0) = NaN;
        if isnan(FMDailyBlock)
            pTotalFlow(i) = 0;
            pAvgFlow(i) = 0;
            pMinFlow(i) = 0;
        else
            pTotalFlow(i) = sum(FMDailyBlock(~isnan(FMDailyBlock)));
            pAvgFlow(i)   = nanmean(FMDailyBlock);
            pMinFlow(i)   = min(FMDailyBlock);
        end
    else
%         if tsEqu(indHrFM(i+1))-tsEqu(indHrFM(i)) == 1   % if no gaps in time stamps
% %             tsDailyNum = tsEqu(indHrFM(i)):indHrFM(i+1)-1;
%             DailyInd = indHrFM(i):indHrFM(i+1)-1;
% %             FMDailyBlock = FM(DailyInd);
% 
%             FMDailyBlock = FM(DailyInd);
%             FMDailyBlock(FMDailyBlock == 0) = NaN;
%             pTotalFlow(i) = sum(FMDailyBlock(~isnan(FMDailyBlock)));
%             pAvgFlow(i)   = nanmean(FMDailyBlock);
%             pMinFlow(i)   = min(FMDailyBlock);
%         else
%             FMDailyBlock = FM(indHrFM(i):indHrFM(i+1)-1);
%             FMDailyBlock(FMDailyBlock == 0) = NaN;
%             pTotalFlow(i) = sum(FMDailyBlock(~isnan(FMDailyBlock)));
%             pAvgFlow(i)   = nanmean(FMDailyBlock);
%             pMinFlow(i)   = min(FMDailyBlock);
%             
%         end
        
        % identify each day from the raw data array. tsEqu is equidistant time stamps 
        FMDailyBlock = FMraw(tsRaw>=tsEqu(indHrFM(i)) & tsRaw<tsEqu(indHrFM(i+1)));
        FMDailyBlock(FMDailyBlock == 0) = NaN;
        if isnan(FMDailyBlock)
            pTotalFlow(i) = 0;
            pAvgFlow(i) = 0;
            pMinFlow(i) = 0;
        else
            pTotalFlow(i) = sum(FMDailyBlock(~isnan(FMDailyBlock)));
            pAvgFlow(i)   = nanmean(FMDailyBlock);
            pMinFlow(i)   = min(FMDailyBlock);
        end
    end
end

%% step 4: calculate weekdays/weekend
[N,S]=weekday(tsEqu(indHrRG));
weekendInd = find(N == 1 | N == 7);

%% step 5: Base GWI and Base DSF

% initialize variables
pBaseGWI = zeros(length(indHrFM),1);
pBaseDSF = zeros(length(indHrFM),1);

% define threshold
indBFWI = find(pDaysSinceRain > IN.FM.iInterfaceDaysSinceRain); % above threshold dry days.
indNegAvgFlow = find(pAvgFlow <= 0);  % check negative (unreal) average flow

% calculations
pBaseGWI(indBFWI) = pMinFlow(indBFWI).*IN.FM.iInterfacePercentageBaseGWI;
pBaseGWI(indNegAvgFlow) = 0;

pBaseDSF(indBFWI) = pAvgFlow(indBFWI) - pBaseGWI(indBFWI);

DW.AverageBaseGWI = mean(nonzeros(pBaseGWI));
DW.AverageBaseDSF = mean(nonzeros(pBaseDSF));
%% step 6
yy = pBaseGWI(indBFWI);
indBaseGWInonZero = find(yy~=0);  % exclude dates with GWI = 0

% pBaseGWInonZero = yy(yy~=0);

pDiurnalFlow = zeros(length(indBFWI),24); % preallocate [No. of dry days x 24 hour]
for j = 1:length(indBFWI)
    indDryDayStartRaw = indHrFM(indBFWI(j));  % start hour index of Dry days
    indDryDayEndRaw = indHrFM(indBFWI(j))+24*60/IN.FM.iInterfaceDataTimeInterval-1; % end hour index of Dry days
    
    indSelectedDate = indDryDayStartRaw:indDryDayEndRaw;
    
    if length(indSelectedDate) ~= 24*60/IN.FM.iInterfaceDataTimeInterval % check raw data equidistant in time
        warning('MATLAB:timeseries', ...
            '--------    irregular raw data time interval detected')
    else
        pHourlyFlowRaw = FM(indSelectedDate);
        
        xx = reshape(pHourlyFlowRaw,length(pHourlyFlowRaw)/24,24);  % reshape into [data for each hour bock x 24]
        pHourlyFlow = mean(xx,1);  % average for each hour block
        
        pDiurnalFlow(j,:) = (pHourlyFlow - pBaseGWI(indBFWI(j)))/pBaseDSF(indBFWI(j));
        
        clear xx
        
    end
end

% RawDateVec = datevec(FM{1}(indSelectedDate));

DryDateStr = datestr(tsEqu(indHrFM(indBFWI(indBaseGWInonZero))));

pDiurnalFlow = pDiurnalFlow(indBaseGWInonZero,:)';


%% step 7  - weekend/weekday average
[Ndry,Sdry]=weekday(DryDateStr);
DryWeekendInd = find(Ndry == 1 | Ndry == 7);
DryWeekdayInd = find(Ndry ~= 1 & Ndry ~= 7);

pWeekendArray = pDiurnalFlow(:,DryWeekendInd);
pWeekdayArray = pDiurnalFlow(:,DryWeekdayInd);

DW.WeekendAvg = mean(pWeekendArray,2);
DW.WeekdayAvg = mean(pWeekdayArray,2);

hourseries = 0:24;

Hf_2 = figure('NumberTitle','off','Name',sprintf('DWF %s: %s',st_name,st_num));
set(Hf_2,'Units','pixel','Position',[120 10 800 600]);

plot(hourseries,[DW.WeekdayAvg; DW.WeekdayAvg(1)],'.-',hourseries,[DW.WeekendAvg; DW.WeekendAvg(1)],'r.-')
legend('Weekday','Weekend','Location','NorthWest')
title(sprintf('DWF at %s (%s)',st_name,st_num))
xlabel('Time(hour)')
ylabel('Diurnal Factor')
ylim(gca,[0 2])
grid

FigName2 = sprintf('%s_%s_DWF',st_num,regexprep(st_name,' ','_'));

print(Hf_2,'-dpng',fullfile(PathFigures,FigName2))
   
%% Plot Rain
Hf_3 = figure('NumberTitle','off','Name',sprintf('Rain %s: %s',st_name,st_num));
set(Hf_3,'Units','pixel','Position',[110 10 800 600]);

%
s1 = subplot(4,1,1);
t1 = bar(tsEqu(indHrRG),pDailyRain);
datetick('x',2)
grid
set(s1,'xtickLabel',{''})
set(s1,'xlim',[StartSummer EndSummer])
set(s1,'position',[0.13 .728 .775 .2]);
set(s1,'ydir','reverse')
ylabel('inch')
set(gca,'xlim',[StartSummer EndSummer]);
title(sprintf('Daily Rain, Flodar Meter - Basin: %s, Meter number: %s',st_name,st_num))

%
s2 = subplot(4,1,2:4);
plot(tsRaw,FMraw,'r.')
hold on
plot(tsEqu,FM)
legend('Data (raw)','Data (gap filled)')
grid
set(s2,'xlim',[StartSummer EndSummer]);

datetick('x',2,'keepticks')
xlabel('day')
ylabel('MGD')

FigName3 = sprintf('%s_%s_Rain_FM',st_num,regexprep(st_name,' ','_'));
print(Hf_3,'-dpng',fullfile(PathFigures,FigName3))

%% Output
FMcell{1} = tsEqu;
FMcell{2} = FM;
FMcell{3} = tsEqu_all;
FMcell{4} = FM_all;

RGcell{1} = tsEqu;
RGcell{2} = RG;
RGcell{3} = tsEqu_all;
RGcell{4} = RG_all;

%% Write DWF to ASCII
DWF_ASCII_name = sprintf('%s_%s_DWF_table.txt',st_num,regexprep(st_name,' ','_'));
fidw = fopen(fullfile(PathTables,DWF_ASCII_name),'w');
fprintf(fidw,'TITLE\n');
fprintf(fidw,'%s at %s\n',st_name,st_num);
fprintf(fidw,'CALIBRATION_WEEKDAY\nTIME,FLOW,POLLUTANT\n');
fprintf(fidw,'%2d:00,%.2f,1\n',[0:23; DW.WeekdayAvg']);
fprintf(fidw,'CALIBRATION_WEEKEND\nTIME,FLOW,POLLUTANT\n');
fprintf(fidw,'%2d:00,%.2f,1\n',[0:23; DW.WeekendAvg']);

fclose(fidw);
% toc
