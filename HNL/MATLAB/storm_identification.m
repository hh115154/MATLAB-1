% Storm identification

if ispc
    cd('C:\Work\HNL_model\from_ZFM')
else
    cd('/Users/sjbaek/WORK/AECOM/HNL_project/from_ZFM/')
end
    
clear all; close all; home
tic

%% constant variables
DateTime_Adjust = 693960; % add this to Excel datenum to get MATLAB datenum
dt = 5; % in minutes - this is to check the quality of time series
% windowSize = 12*60/dt;
storm_duration = 24; % hours
inter_event = 12;  % hours
storm_volume = 0.15; % inches
%% Read flowmeter
RG_name = 'RG-187580.csv';
fidRG = fopen(RG_name);
RG = textscan(fidRG,'%*s%s%f%f%*s%*s','delimiter',',','headerlines',1);
% RG = {Date string; Gauge data; Date number in xls}

fclose(fidRG);

% % running average with windows size 12 hours or specified by user
RainRaw = RG{2};
RainRaw(RainRaw == 0) = NaN;
% windowAvg = filter(ones(1,windowSize)/windowSize,1,RG{2});
% windowAvg(windowAvg == 0) = NaN;
% %% plot
% plot(RainRaw,'.-')
% hold
% plot(windowAvg,'r.-')
% grid


%%

indgap = find(isnan(RainRaw));
diffIndGap = diff(indgap);
diffIndGap(diffIndGap == 1) = NaN;


% plot(indgap(1:end-1),diffIndGap,'r.-')
% grid
% hold on
% plot(RainRaw,'.')
% title('red dots identify start of each storm')

%%
indstorm = find(~isnan(diffIndGap));
indStormStart = indgap(indstorm) + 1;  % index for original rain data

stormLength = diffIndGap(indstorm)-1;

% preallocate memory for cell
% StormIdAll = cell(length(indstorm),2);
% StormIdAll{length(indstorm),2} = [];

StormIdAll(1,:) = datenum(RG{1}(indStormStart));

StormIdAll(2,:) = datenum(RG{1}(indStormStart)) + (stormLength-1)*dt/60/24;
StormIdAllRow = reshape(StormIdAll,1,[]); % vectorize -> [start end start end, ...]
xx = diff(StormIdAllRow);

StormStartEndIndex = [indStormStart indStormStart+stormLength-1]; % INDEX for Original individual event
StormStartEndIndex = StormStartEndIndex';
StormStartEndIndexRow = reshape(StormStartEndIndex,1,[]);

%% gap between storms (e.g. separated by 12 hours of dry period)
gapxx = xx(2:2:end);

indDivStorm = find(gapxx>=inter_event/24);
StormIdDate = zeros(4,length(indDivStorm));
% StormIdRG   = zeros(2,length(indDivStorm));


StormIdDate(1,1) = StormIdAll(1,1);
StormIdDate(3,1) = StormStartEndIndex(1,1);

% StormIdRG(1,1) = 
for i = 1:length(indDivStorm)-1
    
    StormIdDate(2,i) = StormIdAllRow(indDivStorm(i).*2);
    StormIdDate(1,i+1) = StormIdAllRow(indDivStorm(i).*2+1);
    StormIdDate(4,i) = StormStartEndIndexRow(indDivStorm(i).*2);
    StormIdDate(3,i+1) = StormStartEndIndexRow(indDivStorm(i).*2+1);
end
StormIdDate(2,end) = StormIdAll(2,end);
StormIdDate(4,end) = StormStartEndIndex(2,end);
%% find only storms longer than threshold duration (e.g. 24 hr)

yy = StormIdDate(2,:) - StormIdDate(1,:);

StormIdEffective = StormIdDate(:,yy>=storm_duration/24);

%% find storms greater than threshold volume (e.g. 0.25 inch)
StormVolume = zeros(1,length(StormIdEffective));
for j = 1:length(StormIdEffective)
    StormVolume(j) = sum(RG{2}(StormIdEffective(3,j):StormIdEffective(4,j)));
end

StormIdFinal = find(StormVolume>=storm_volume);


%% write to text file

fidw = fopen(sprintf('Storm_ID_%s.txt',RG_name(1:end-4)),'w');
fprintf(fidw,'min. storm duration:\t %d hr\n',storm_duration);
fprintf(fidw,'inter event duration:\t %d hr\n',inter_event);
fprintf(fidw,'min. total rain:\t %.3f inch\n',storm_volume);

fprintf(fidw,'\n')

fprintf(fidw,'storm #\t start date\t end date\t total rain\n');
for k = 1:length(StormIdFinal)
    fprintf(fidw,'storm %d\t%s\t%s\t%.3f\n',k,datestr(StormIdEffective(1,StormIdFinal(k)),'mm/dd/yyyy HH:MM'), ...
        datestr(StormIdEffective(2,StormIdFinal(k)),'mm/dd/yyyy HH:MM'),StormVolume(StormIdFinal(k)));
    
    
    
end
fclose(fidw);