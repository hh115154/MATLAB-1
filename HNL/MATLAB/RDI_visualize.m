%% plot RDI
clear all; close all; home

FileName = 'RDI_Setup.xlsx';
PathName = pwd;

if ~exist(FileName,'file')
    
    [FileName,PathName] = uigetfile( ...
        {'*.inp;*.xlsx;*.xls','RDI Setup Files (*.inp,*.xlsx,*.xls)';
        '*.inp',  'Code files (*.m)'; ...
        '*.xlsx','Figures (*.fig)'; ...
        '*.xls','MAT-files (*.mat)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Pick a file (and Have fun!!)');
end

cd(PathName)

% PathName = 'C:\Work\HNL_model\from_ZFM\';

Input = fun_read_RDI_input(FileName,PathName);

%% Dry flow
% RG: Rain Gauge data <1x2 cell>: {date string} [rain data]
% FM: Flow meter data <1x2 cell>: {date string} [rain data]
% DW: dry flow pattern (weekdays/weekends)

[RG,FM,DW] = fun_MDW_Calibrate_v2(Input);

%% Storm identification
% StormID:                   Storm1  Storm2  Storm3 ... 
%           Start datenum -> [  ___    ___     ___
%            End  datenum ->    ___    ___     ___
%           Start index   ->    ___    ___     ___
%            End  index   ->    ___    ___     ___ ]

StormID = fun_storm_identification_v2(Input,RG);

%% Plot RDI

% figId = 1;
for figId = 1:size(StormID.StormIdEffective,2)
    
    
    % sort indices for storm
    StormPlotId = StormID.StormIdEffective(3,figId):StormID.StormIdEffective(4,figId);
    
    % StormPlotIdExt needs to be determined based on RDI threshold!!!!! -----
    if StormPlotId(end)+length(StormPlotId) > length(FM{1})
        StormPlotIdExt = StormPlotId(1):length(FM{1});
    else
        StormPlotIdExt = StormPlotId(1):StormPlotId(end)+length(StormPlotId);
    end
    % -----------------------------------------------------------------------
    
    figure(figId+1)
    s1 = subplot(4,1,1);
    t1 = bar(datenum(RG{1}(StormPlotId)),RG{2}(StormPlotId));
    datetick('x',2)
    grid
    set(s1,'xtickLabel',{''})
    set(s1,'xlim',[datenum(FM{1}(StormPlotIdExt(1))) datenum(FM{1}(StormPlotIdExt(end)))])
    set(s1,'position',[0.13 .728 .775 .2]);
    set(s1,'ydir','reverse')
    ylabel('inch')
    
    s2 = subplot(4,1,2:4);
    plot(datenum(FM{1}(StormPlotIdExt)),FM{2}(StormPlotIdExt),'linewidth',2)
    
    hold on
    
    datetick('x',2)
    grid
    
    
    StormStartTime =  datevec(RG{1}(StormPlotId(1)));
    StormStartDay = [StormStartTime(1:3) 0 0 0];
    StormEndTime =  datevec(RG{1}(StormPlotId(end)));
    StormEndTimeExt =  datevec(RG{1}(StormPlotIdExt(end)));
    
    StormDuration = (datenum(StormEndTime)- datenum(StormStartTime))*24; % hours
    
    % 1-Sun, 2-Mon, 3-Tue, ..., 7-Sat
    DayNumbers = weekday(datenum(StormStartTime):datenum(StormEndTimeExt));
    % DayNumbers = [4:7 1:7 1:3];  % sample
    
    % repeat weekday data for the length of storm REGARDLESS of weekend (yet).
    DW_series = repmat(DW.WeekdayAvg,length(DayNumbers),1);
    
    indWeekends = find(DayNumbers==1 | DayNumbers==7);
    % if any(DayNumbers==1 & DayNumbers==7) % if there are weekend days
    %     indWeekends = find(DayNumbers==1 | DayNumbers==7);
    %     DWcell{indWeekends} = DW.WeekendAvg;
    % end
    
    DWpattern{length(DayNumbers),1} = [];
    for i = 1:length(DayNumbers)
        if ~isempty(indWeekends) && any(i==indWeekends)
            DWpattern{i} = DW.WeekendAvg;
        else
            DWpattern{i} = DW.WeekdayAvg;
        end
        
        
    end
    
    %% use cell!!!
    
    DWtseries = cell2mat(DWpattern);
    % DWpattern starts at 00:00
    
    %% Work on plotting in a same axis!!!
    
    
    % plot(DWtseries,'g','linewidth',2)
    DWPlotStartHH = str2double(datestr(FM{1}(StormPlotId(1)),'HH'));
    
    % storm start Hour | DW starts midnight, e.g. 1:00 -> 2nd row
    
    DWHourlyData = DWtseries(DWPlotStartHH + 1:end,:);
    DWTimeAxis = datenum(StormStartDay)+ [DWPlotStartHH/24:1/24:(length(DWtseries)-1)/24];
    
    % plot(DWPlotTHour,DWHourlyData,'.-')
    
    %% PLOT
%     pFlow = DWHourlyData .* Input.FM.Population * Input.FM.PerCapitaFlow /10^6 + Input.FM.iInterfaceBaseGWI; % hourly
    pFlow = DWHourlyData .* DW.AverageBaseDSF + DW.AverageBaseGWI;

    pFlowInterp = interp1(DWTimeAxis,pFlow,datenum(FM{1}(StormPlotIdExt)),'cubic');
    % pFlowInterp = pFlowInterp';
    
    plot(datenum(FM{1}(StormPlotIdExt)),pFlowInterp,'g','linewidth',2)
    plot(datenum(FM{1}(StormPlotIdExt)),FM{2}(StormPlotIdExt) - pFlowInterp,'r','linewidth',2)
    % hold on
    % plot(DWTimeAxis,pFlow,'go-','linewidth',2)
    set(s2,'xlim',[datenum(FM{1}(StormPlotIdExt(1))) datenum(FM{1}(StormPlotIdExt(end)))])
    xlabel('date')
    ylabel('MGD')
    legend('Flow','Baseflow','RDI/I')

    
end
toc