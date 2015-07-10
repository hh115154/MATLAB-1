if ispc
    cd('C:\Work\HNL_model\xls\csv_files')
else
    cd('/Users/sjbaek/WORK/AECOM/HNL_project/')
end

% cd('/Users/sjbaek/WORK/AECOM/HNL_project')
clear all
close all
home
tic
%% Read flowmeter
fidFM = fopen('MDWCalibrate_v2_FM.csv');
FM = textscan(fidFM,'%s%f%*s%*s','delimiter',',','headerlines',1);
fclose(fidFM);

%% Read Rain gauge
fidRG = fopen('MDWCalibrate_v2_RG.csv');
RG = textscan(fidRG,'%s%f%*s%*s','delimiter',',','headerlines',1);
fclose(fidRG);

%% identifying storm event and exclude

% No. of Precedent Dry Weather Days
iInteraceDaysSinceRain = 3;

% Estimated base GWI
iInterfacePercentageBaseGWI = 0.8;
iInterfaceDataTimeInterval = 5;         % minutes
%% identifying weekdays/weekend
% [N,S]=weekday(FM{1});
% dNumFM1 = zeros(length(FM{1}),1);


% ### need improve below
dNumFM = datenum(FM{1});
dNumRG = datenum(RG{1});
% ########

toc 

% find the indices for 00:00 for each day
indHrFM = find(mod(dNumFM,1)==0);
indHrRG = find(mod(dNumRG,1)==0);

% check if the timeseries for FM and RG are the same or not
% if same use indHr, otherwise repeat separate indices

%% Calculate daily statistics: total rain, avg, minimum

%% step 1 & 3
pDailyRain = zeros(length(indHrRG),1);
pDaysSinceRain = zeros(length(indHrRG),1);

for i = 1:length(indHrRG)
    if i == length(indHrRG)
        pDailyRain(i) = sum(RG{2}(indHrRG(i):end));
        if pDailyRain(i) <= 0.01
            pDaysSinceRain(i) = 1;
        end
    else
        pDailyRain(i) = sum(RG{2}(indHrRG(i):indHrRG(i+1)-1));
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
pTotalFlow = zeros(length(indHrFM),1);
pAvgFlow = zeros(length(indHrFM),1);
pMinFlow = zeros(length(indHrFM),1);
for i = 1:length(indHrFM)
    if i == length(indHrFM)
        pTotalFlow(i) = sum(FM{2}(indHrFM(i):end));
        pAvgFlow(i) = mean(FM{2}(indHrFM(i):end));
        pMinFlow(i) = min(FM{2}(indHrFM(i):end));
    else
        pTotalFlow(i) = sum(FM{2}(indHrFM(i):indHrFM(i+1)-1));
        pAvgFlow(i) = mean(FM{2}(indHrFM(i):indHrFM(i+1)-1));
        pMinFlow(i) = min(FM{2}(indHrFM(i):indHrFM(i+1)-1));
    end
    
end

%% step 4: calculate weekdays/weekend
[N,S]=weekday(FM{1}(indHrRG));
weekendInd = find(N == 1 | N == 7);

%% step 5: Base GWI and Base DSF

% initialize variables
pBaseGWI = zeros(length(indHrFM),1);
pBaseDSF = zeros(length(indHrFM),1);

% define threshold
indBFWI = find(pDaysSinceRain > iInteraceDaysSinceRain); % above threshold dry days.
indNegAvgFlow = find(pAvgFlow <= 0);  % check negative (unreal) average flow

% calculations
pBaseGWI(indBFWI) = pMinFlow(indBFWI).*iInterfacePercentageBaseGWI;
pBaseGWI(indNegAvgFlow) = 0;

pBaseDSF(indBFWI) = pAvgFlow(indBFWI) - pBaseGWI(indBFWI);

%% step 6
yy = pBaseGWI(indBFWI);
indBaseGWInonZero = find(yy~=0);  % exclude dates with GWI = 0

% pBaseGWInonZero = yy(yy~=0);

pDiurnalFlow = zeros(length(indBFWI),24); % preallocate [No. of dry days x 24 hour]
for j = 1:length(indBFWI)
    indDryDayStartRaw = indHrFM(indBFWI(j));  % start hour index of Dry days
    indDryDayEndRaw = indHrFM(indBFWI(j))+24*60/iInterfaceDataTimeInterval-1; % end hour index of Dry days
    
    indSelectedDate = indDryDayStartRaw:indDryDayEndRaw;
    
    if length(indSelectedDate) ~= 24*60/iInterfaceDataTimeInterval % check raw data equidistant in time
        warning('MATLAB:timeseries', ...
            '--------    irregular raw data time interval detected')
    else
        pHourlyFlowRaw = FM{2}(indSelectedDate);
        
        xx = reshape(pHourlyFlowRaw,length(pHourlyFlowRaw)/24,24);  % reshape into [data for each hour bock x 24]
        pHourlyFlow = mean(xx,1);  % average for each hour block
        
        pDiurnalFlow(j,:) = (pHourlyFlow - pBaseGWI(indBFWI(j)))/pBaseDSF(indBFWI(j));
        
        clear xx
        
    end
end

% RawDateVec = datevec(FM{1}(indSelectedDate));

DryDateStr = datestr(FM{1}(indHrFM(indBFWI(indBaseGWInonZero))));

pDiurnalFlow = pDiurnalFlow(indBaseGWInonZero,:)';


%% step 7  - weekend/weekday average
[Ndry,Sdry]=weekday(DryDateStr);
DryWeekendInd = find(Ndry == 1 | Ndry == 7);
DryWeekdayInd = find(Ndry ~= 1 & Ndry ~= 7);

pWeekendArray = pDiurnalFlow(:,DryWeekendInd);
pWeekdayArray = pDiurnalFlow(:,DryWeekdayInd);

WeekendAvg = mean(pWeekendArray,2);
WeekdayAvg = mean(pWeekdayArray,2);

hourseries = 0:23;
plot(hourseries,WeekdayAvg,'.-',hourseries,WeekendAvg,'r.-')
legend('Weekday','Weekend')
xlabel('Time(hour)')
ylabel('Diurnal Factor')
grid
toc
