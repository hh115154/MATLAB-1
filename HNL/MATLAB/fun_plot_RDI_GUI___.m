function fun_plot_RDI_GUI(StormID,RG,FM,DW)

global st_name st_num PathName

PathFigures = [PathName 'Figures'];
if exist(PathFigures,'dir')==0
    mkdir(PathFigures)
end
PathTables = [PathName 'Tables'];
if exist(PathTables,'dir')==0
    mkdir(PathTables)
end

% ------------------------------ Plot RDI
if isempty(StormID.StormVolume)
    figId = 1;
    Hf_ = figure(figId+3);
    set(Hf_,'Units','pixel','Position',[110+5*figId 10 800 600]);
    
    s1 = subplot(4,1,1);
    t1 = bar(RG{1},RG{2});
    %     datetick('x',2)
    grid
    datetick('x',2)
    set(s1,'xtickLabel',{''})
    set(s1,'xlim',[FM{1}(1) FM{1}(end)])
    set(s1,'position',[0.13 .728 .775 .2]);
    set(s1,'ydir','reverse')
    ylabel('inch')
%     title('No qualified storm event')
    title(sprintf('Basin: %s, Meter number: %s, No qualified storm',st_name,st_num))

    s2 = subplot(4,1,2:4);
    plot(FM{1},FM{2},'.-','linewidth',1)
    
    hold on
    
    datetick('x',2)
    grid
    
    
    %
    StormStartTime =  datevec(RG{1}(1));
    StormStartDay = [StormStartTime(1:3) 0 0 0];
    StormEndTime =  datevec(RG{1}(end));
    StormEndTimeExt =  datevec(RG{1}(end));
    
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
    
    %
    % ------------------------------  use cell!!!
    
    DWtseries = cell2mat(DWpattern);
    % DWpattern starts at 00:00
    
    % ------------------------------ Work on plotting in a same axis!!!
    
    
    % plot(DWtseries,'g','linewidth',2)
    DWPlotStartHH = str2double(datestr(FM{1}(1),'HH'));
    
    % storm start Hour | DW starts midnight, e.g. 1:00 -> 2nd row
    
    DWHourlyData = DWtseries(DWPlotStartHH + 1:end,:);
    DWTimeAxis = datenum(StormStartDay)+ [DWPlotStartHH/24:1/24:(length(DWtseries)-1)/24];
    
    % plot(DWPlotTHour,DWHourlyData,'.-')
    
    % ------------------------------ PLOT
    %     pFlow = DWHourlyData .* Input.FM.Population * Input.FM.PerCapitaFlow /10^6 + Input.FM.iInterfaceBaseGWI; % hourly
    pFlow = DWHourlyData .* DW.AverageBaseDSF + DW.AverageBaseGWI;
    
    pFlowInterp = interp1(DWTimeAxis,pFlow,FM{1});
    % pFlowInterp = pFlowInterp';
    
    plot(FM{1},pFlowInterp,'g','linewidth',2)
    %         plot(FM{1},FM{2} - pFlowInterp,'r','linewidth',2)
    % hold on
    % plot(DWTimeAxis,pFlow,'go-','linewidth',2)
    set(s2,'xlim',[FM{1}(1) FM{1}(end)])
    xlabel('date')
    ylabel('MGD')
    legend('Flow','Baseflow')
    
    FigName = sprintf('%s_%s_Storm_Null',st_num,regexprep(st_name,' ','_'));
    print(Hf_,'-dpng',fullfile(PathFigures,FigName))
else
    
    % figId = 1;
    for figId = 1:size(StormID.StormIdEffective,2)
        
        
        % sort indices for storm
        StormPlotId = StormID.StormIdEffective(3,figId):StormID.StormIdEffective(4,figId);
        
        % StormPlotIdExt needs to be determined based on RDI threshold!!!!!
        % -----
        if StormPlotId(end)+length(StormPlotId) > length(FM{1})
            StormPlotIdExt = StormPlotId(1):length(FM{1});
        else
            StormPlotIdExt = StormPlotId(1):StormPlotId(end)+length(StormPlotId);
        end
        % -----------------------------------------------------------------------
        Hf_ = figure(figId+3);
        set(Hf_,'Units','pixel','Position',[110+5*figId 10 800 600]);
        
%         figure(figId+3)
        s1 = subplot(4,1,1);
        t1 = bar(RG{1}(StormPlotId),RG{2}(StormPlotId));
        %     datetick('x',2)
        grid
        set(s1,'xtickLabel',{''})
        set(s1,'xlim',[FM{1}(StormPlotIdExt(1)) FM{1}(StormPlotIdExt(end))])
        set(s1,'position',[0.13 .728 .775 .2]);
        set(s1,'ydir','reverse')
        ylabel('inch')
        title(sprintf('Basin: %s, Meter number: %s, Storm %d',st_name,st_num,figId))

        s2 = subplot(4,1,2:4);
        plot(FM{1}(StormPlotIdExt),FM{2}(StormPlotIdExt),'.-','linewidth',1)
        
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
        
        % ------------------------------ use cell!!!
        
        DWtseries = cell2mat(DWpattern);
        % DWpattern starts at 00:00
        
        % ------------------------------ Work on plotting in a same axis!!!
        
        
        % plot(DWtseries,'g','linewidth',2)
        DWPlotStartHH = str2double(datestr(FM{1}(StormPlotId(1)),'HH'));
        
        % storm start Hour | DW starts midnight, e.g. 1:00 -> 2nd row
        
        DWHourlyData = DWtseries(DWPlotStartHH + 1:end,:);
        DWTimeAxis = datenum(StormStartDay)+ [DWPlotStartHH/24:1/24:(length(DWtseries)-1)/24];
        
        % plot(DWPlotTHour,DWHourlyData,'.-')
        
        % ------------------------------ PLOT
        %     pFlow = DWHourlyData .* Input.FM.Population * Input.FM.PerCapitaFlow /10^6 + Input.FM.iInterfaceBaseGWI; % hourly
        pFlow = DWHourlyData .* DW.AverageBaseDSF + DW.AverageBaseGWI;
        
        pFlowInterp = interp1(DWTimeAxis,pFlow,FM{1}(StormPlotIdExt));
        % pFlowInterp = pFlowInterp';
        
        plot(FM{1}(StormPlotIdExt),pFlowInterp,'g','linewidth',2)
        plot(FM{1}(StormPlotIdExt),FM{2}(StormPlotIdExt) - pFlowInterp,'r','linewidth',2)
        % hold on
        % plot(DWTimeAxis,pFlow,'go-','linewidth',2)
        set(s2,'xlim',[FM{1}(StormPlotIdExt(1)) FM{1}(StormPlotIdExt(end))])
        xlabel('date')
        ylabel('MGD')
        legend('Flow','Baseflow','RDI/I')
        
        FigName = sprintf('%s_%s_Storm_%d',st_num,regexprep(st_name,' ','_'),figId);
        print(Hf_,'-dpng',fullfile(PathFigures,FigName))
        
    end
end