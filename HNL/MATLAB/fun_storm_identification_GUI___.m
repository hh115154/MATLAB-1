function StormID = fun_storm_identification_GUI(IN,RG)
% Storm identification
% global st_name st_num PathName

%% folder verification
% PathFigures = [PathName 'Figures'];
% if exist(PathFigures,'dir')==0
%     mkdir(PathFigures)
% end
% PathTables = [PathName 'Tables'];
% if exist(PathTables,'dir')==0
%     mkdir(PathTables)
% end
%% Read Rain data

% 1 hr data: Stege_Site_N_RDI_plots_Rain_1hr.csv
% 5 min data: 
% fidRG = fopen(fullfile(IN.RG.path,IN.RG.name));
% readRGId = '%*s%s%f%*[^\n]';
% RG = textscan(fidRG,readRGId,'delimiter',',','headerlines',1);
% 
% % RG = {Date string; Gauge data; Date number in xls}
% 
% fclose(fidRG);

RainT = RG{3};   % datenum
RainRaw = RG{4}; % double array
% RG{1:2} is for the 'Summer' data

RainRaw(RainRaw == 0) = NaN;


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

StormIdAll(1,:) = RainT(indStormStart);

StormIdAll(2,:) = RainT(indStormStart) + (stormLength-1)*IN.RG.dt/60/24;
StormIdAllRow = reshape(StormIdAll,1,[]); % vectorize -> [start end start end, ...]
xx = diff(StormIdAllRow);

qq = indStormStart+stormLength-1;
StormStartEndIndex = [indStormStart' qq']; % INDEX for Original individual event
StormStartEndIndex = StormStartEndIndex';
StormStartEndIndexRow = reshape(StormStartEndIndex,1,[]);

%% gap between storms (e.g. separated by 12 hours of dry period)
gapxx = xx(2:2:end);

indDivStorm = find(gapxx>=IN.RG.inter_event/24);
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

StormIdEffective = StormIdDate(:,yy>=IN.RG.storm_duration/24);

%% find storms greater than threshold volume (e.g. 0.25 inch)
[~,NumOfStorm] = size(StormIdEffective);
StormVolume = zeros(1,NumOfStorm);
for j = 1:NumOfStorm
    StormVolume(j) = sum(RG{4}(StormIdEffective(3,j):StormIdEffective(4,j)));
end

StormIdFinal = find(StormVolume>=IN.RG.storm_volume);


%% write to text file
% StormID_ASCII_name = sprintf('%s_%s_Storm_ID.txt',st_num,regexprep(st_name,' ','_'));
% 
% fidw = fopen(fullfile(PathTables,StormID_ASCII_name),'w');
% fprintf(fidw,'min. storm duration:\t %d hr\n',IN.RG.storm_duration);
% fprintf(fidw,'inter event duration:\t %d hr\n',IN.RG.inter_event);
% fprintf(fidw,'min. total rain:\t %.3f inch\n',IN.RG.storm_volume);
% 
% fprintf(fidw,'\n');
% 
% fprintf(fidw,'storm #\t start date\t end date\t total rain\n');
% for k = 1:length(StormIdFinal)
%     fprintf(fidw,'storm %d\t%s\t%s\t%.3f\n',k,datestr(StormIdEffective(1,StormIdFinal(k)),'mm/dd/yyyy HH:MM'), ...
%         datestr(StormIdEffective(2,StormIdFinal(k)),'mm/dd/yyyy HH:MM'),StormVolume(StormIdFinal(k)));
%     
%     
%     
% end
% fclose(fidw);

%% plot a sample storm

% for l = 1:length(StormIdFinal)
%     figure(l+1)
%     
%     plotPeriodInd = StormIdEffective(3,StormIdFinal(l)):StormIdEffective(4,StormIdFinal(l));
%     bar(datenum(RainT(plotPeriodInd)),RainRaw(plotPeriodInd))
%     axis tight
%     set(gca,'ydir','reverse')
%     datetick('x',2,'keeplimits')
%     grid
% end
StormID.StormIdEffective = StormIdEffective(:,StormIdFinal);
% StormID.StormIdFinal = StormIdFinal;
StormID.StormVolume = StormVolume(StormIdFinal);