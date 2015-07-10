function [RG,FM,DW] = fun_MDW_Calibrate_v2(IN)

tic

%% Read input file


%% Read flowmeter
fidFM = fopen(fullfile(IN.FM.path,IN.FM.name));
readFMId = '%*s%s%*f%*f%f%*[^\n]';
FM = textscan(fidFM,readFMId,'delimiter',',','headerlines',1);
fclose(fidFM);

%% Read Rain gauge
fidRG = fopen(fullfile(IN.RG.path,IN.RG.name));
readRGId = '%*s%s%f%*[^\n]';
RG = textscan(fidRG,readRGId,'delimiter',',','headerlines',1);
fclose(fidRG);

%% identifying weekdays/weekend
% [N,S]=weekday(FM{1});
% dNumFM1 = zeros(length(FM{1}),1);


if datenum(RG{1}(1))+(length(RG{1})-1)*IN.RG.dt/60/24 == datenum(RG{1}(end))
    %check equidistant data: first time + length == end time
    indHrRG_1st = find(mod(datenum(RG{1}(1:24*60/IN.RG.dt*2)),1)==0,1);
    indHrRG = indHrRG_1st:24*60/IN.RG.dt:length(RG{1});
    if length(RG{1}) == length(FM{1})
        indHrFM = indHrRG;
    end
else
    fprintf(1,'Data not equidistant ...\n')
    dNumRG = datenum(RG{1});
    indHrRG = find(mod(dNumRG,1)==0);
    
    if (dNumRG(1) == datenum(FM{1}(1))) && (length(RG{1}) == length(FM{1}))
        dNumFM = dNumRG;
        indHrFM = indHrRG;
    else
        dNumFM = datenum(FM{1});
        indHrFM = find(mod(dNumFM,1)==0);
    end
    
end

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

DW.WeekendAvg = mean(pWeekendArray,2);
DW.WeekdayAvg = mean(pWeekdayArray,2);

hourseries = 0:24;
plot(hourseries,[DW.WeekdayAvg; DW.WeekdayAvg(1)],'.-',hourseries,[DW.WeekendAvg; DW.WeekendAvg(1)],'r.-')
legend('Weekday','Weekend')
xlabel('Time(hour)')
ylabel('Diurnal Factor')
grid
toc
