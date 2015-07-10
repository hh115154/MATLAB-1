function varargout = Storm_ID_GUI(varargin)
% STORM_ID_GUI M-file for Storm_ID_GUI.fig
%      STORM_ID_GUI, by itself, creates a new STORM_ID_GUI or raises the existing
%      singleton*.
%
%      H = STORM_ID_GUI returns the handle to a new STORM_ID_GUI or the handle to
%      the existing singleton*.
%
%      STORM_ID_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STORM_ID_GUI.M with the given input arguments.
%
%      STORM_ID_GUI('Property','Value',...) creates a new STORM_ID_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Storm_ID_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Storm_ID_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Storm_ID_GUI

% Last Modified by GUIDE v2.5 04-Jan-2011 16:11:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Storm_ID_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Storm_ID_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Storm_ID_GUI is made visible.
function Storm_ID_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Storm_ID_GUI (see VARARGIN)

% Choose default command line output for Storm_ID_GUI
handles.output = hObject;
home

% Plot radio button pre-selection: BSF & RDI/I
set(handles.radiobutton_BSF,'Value',1)
set(handles.radiobutton_DBSF,'Value',0)
set(handles.radiobutton_RDII,'Value',1)

% % Set toggle button 'unselected'
% set(handles.pushbutton_ResponseEnd,'Value',0)

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Storm_ID_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Storm_ID_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_FileSelect.
function pushbutton_FileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% ------------------------------ Initialize the table view
% set(handles.pushbutton_ResponseEnd,'Value',0)

ResetTablesFigures(handles)

% if ~isfield(handles,'EmptyTable')
%     handles.EmptyTable = get(handles.uitable_StormID, 'Data');
%     handles.EmptyTable2 = get(handles.uitable_Rfactor, 'Data');
% end
% 
% set(handles.uitable_StormID, 'Data', handles.EmptyTable);
% set(handles.uitable_Rfactor, 'Data', handles.EmptyTable2);
% cla(handles.axes_RDII)
% legend(handles.axes_RDII,'off')
% cla(handles.axes_Rain)
% cla(handles.axes_DWF)
% legend(handles.axes_DWF,'off')
% cla(handles.axes_Rfactor)
% 
% % remove previous titles
% delete(get(handles.axes_Rfactor,'title'))
% delete(get(handles.axes_Rain,'title'))

% ------------------------------ select setup file

if ispc
    FileName_setup = 'RDI_Setup_Telog.xlsx';
else
    FileName_setup = 'RDI_Setup_Telog.xls';
end

PathName_setup = pwd;

if ~exist(fullfile(PathName_setup,FileName_setup),'file') %&& isempty(handles.Input)
    
    [FileName_setup,PathName_setup] = uigetfile( ...
        {'*.inp;*.xlsx;*.xls','RDI Setup Files (*.inp,*.xlsx,*.xls)';
        '*.inp',  'Code files (*.m)'; ...
        '*.xlsx','Figures (*.fig)'; ...
        '*.xls','MAT-files (*.mat)'; ...
        '*.*',  'All Files (*.*)'}, ...
        'Pick a Setup file');
end


handles.Input = fun_read_RDI_input_GUI(FileName_setup,PathName_setup);

% ------------------------------ select data file 

[FileNameDATA,PathName] = uigetfile( ...
    {'*.csv',  'comma separated variables (*.csv)'; ...
    '*.xlsx','Excel file (*.xlsx)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick a DATA file');
cd(PathName)

if ispc
    st_nameId = regexp(PathName, '\\', 'split');
    handles.Input.st_name = st_nameId{end-1};
    
    st_numId = regexp(FileNameDATA,' ','split');
    handles.Input.st_num = st_numId{1};  % str variable
else
    st_nameId = regexp(PathName, '/', 'split');
    handles.Input.st_name = st_nameId{end-1};
    
    st_numId = regexp(FileNameDATA,' ','split');
    handles.Input.st_num = st_numId{1};  % str variable
end


set(handles.FileLocation,'string',[pwd '\' FileNameDATA]);  % 'Edit Text' object

handles.Input.PathName = PathName;
handles.Input.FileNameDATA = FileNameDATA;
% handles.Input.StormSpecificBSF = False;

cd(PathName_setup)

guidata(hObject, handles);

% --- Executes on button press in pushbutton_StormID.
function pushbutton_StormID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StormID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set(handles.pushbutton_ResponseEnd,'Value',0)

ResetTablesFigures(handles)

% if ~isfield(handles,'EmptyTable')
%     handles.EmptyTable = get(handles.uitable_StormID, 'Data');
% end
% 
% set(handles.uitable_StormID, 'Data', handles.EmptyTable);
% cla(handles.axes_RDII)
% cla(handles.axes_Rain)
% cla(handles.axes_DWF)
% --------------------------

%{

By clicking '2) Identify Storm', we should achieve
1. populate table of storm list
2. plot the 1st storm RDI/I
3. plot DWF

%}

% ------------------------------ DWF analysis

[RG,FM,DW] = fun_MDW_Calibrate_GUI(handles.Input);


% ------------------------------ plot DWF

hourseries = 0:24;

plot(handles.axes_DWF,hourseries,[DW.WeekdayAvg; DW.WeekdayAvg(1)],'.-',hourseries,[DW.WeekendAvg; DW.WeekendAvg(1)],'r.-')
legend(handles.axes_DWF,'Weekday','Weekend','Location','SouthEast')
title(handles.axes_DWF,sprintf('Diurnal Factor at %s (%s)',handles.Input.st_name,handles.Input.st_num))
xlabel(handles.axes_DWF,'Time(hour)')
% ylabel(handles.axes_DWF,'Diurnal Factor')
% ylim(gca,[0 2])
grid(handles.axes_DWF)

% ------------------------------ Storm Identification

StormID = fun_storm_identification_GUI(handles.Input,RG);

% populate the table with storm ID

% ------------------------------ plot RDI/I

% fun_plot_RDI_GUI(StormID,RG(3:4),FM(3:4),DW)

% read place holder
stats = get(handles.uitable_StormID, 'Data');
xxx = StormID.StormIdEffective(1:2,:)';
% startdate = xxx(:,1);


if isempty(StormID.StormVolume)
    stats{1,1} = 'NO STORM';
    stats{1,2} = 'NO STORM';
else
    BaseSanitaryFlow{length(StormID.StormVolume),1} = [];
           StormInfo{length(StormID.StormVolume),1} = [];
    
    for i = 1:length(StormID.StormVolume)
        % storm start
        stats{i,1} = datestr(xxx(i,1),'yyyy/mm/dd HH:MM');
        % storm end
        stats{i,2} = datestr(xxx(i,2),'yyyy/mm/dd HH:MM');
        
        % by default response end = storm end
%         stats{i,3} = datestr(xxx(i,2),'yyyy/mm/dd HH:MM');  
        
        % ------------------------------ Storm Specific Base Sanitary Flow
        
%         StormWindows = 3*24*60/handles.Input.RG.dt; % indices for [+- 3 days] of a storm window
%         
%         StormIndices = ...
%             StormID.StormIdEffective(3,i)-StormWindows:StormID.StormIdEffective(4,i)+StormWindows;

        StormStart = FM{3}(StormID.StormIdEffective(3,i));
        StormStartDay = floor(StormStart);
        StormEnd = FM{3}(StormID.StormIdEffective(4,i));
        StormEndDay = ceil(StormEnd);
       
        if StormStartDay-3 < FM{3}(1)  % if 1st storm starts withing the 3 days of existing data
            StormWindowStartInd = ceil(FM{3}(1)); % the first midnight of the data
            StormWindowEndInd = find(FM{3} == StormEndDay+3);
        elseif StormEndDay+3 > FM{3}(end) % if the last storm ends withing the last 3 days of existing data
            StormWindowStartInd = find(FM{3} == StormStartDay-3);
            StormWindowEndInd = floor(FM{3}(end)); % the last midnight of the data
        else
            StormWindowStartInd = find(FM{3} == StormStartDay-3);
            StormWindowEndInd = find(FM{3} == StormEndDay+3);
        end
        StormStartInd = find(FM{3} == StormStart);
        StormEndInd = find(FM{3} == StormEnd);
        
%{        
%         % if the last storm ends withing the last 3 days of existing data
%         if StormID.StormIdEffective(4,i)+StormWindows > length(FM{1})
%             StormIndices = StormID.StormIdEffective(3,i)-StormWindows:length(FM{1});
%         end
%         
%         % if 1st storm starts withing the 3 days of existing data
%         if StormID.StormIdEffective(3,i)-StormWindows < 1
%            StormIndices = 1:StormID.StormIdEffective(4,i)+StormWindows; 
%         end
%}        
        StormIndices = StormStartInd:StormEndInd;
        StormWindowIndices = StormWindowStartInd:StormWindowEndInd;
        
        StormSpec.ts = FM{3}(StormWindowIndices);  % time number
        StormSpec.FM = FM{4}(StormWindowIndices);  % flow data
        StormSpec.RG = RG{4}(StormWindowIndices);  % rain data
        
        disp(i)
        
        % ========================================================================
        % Storm Base Sanitary Flow (BSF)
        [~,~,BSF] = fun_MDW_Calibrate_GUI(handles.Input,1,StormSpec);
        
        % ------------------------------------------------------------------------
        DayNumbers = weekday(floor(StormStart):floor(StormEnd));
        % DayNumbers = [4:7 1:7 1:3];  % sample
        
        % repeat weekday data for the length of storm REGARDLESS of weekend (yet).
        DW_series = repmat(DW.WeekdayAvg,length(DayNumbers),1);
        
        indWeekends = find(DayNumbers==1 | DayNumbers==7);
        % if any(DayNumbers==1 & DayNumbers==7) % if there are weekend days
        %     indWeekends = find(DayNumbers==1 | DayNumbers==7);
        %     DWcell{indWeekends} = DW.WeekendAvg;
        % end
        
        DWpattern{length(DayNumbers),1} = [];
        BSFpattern{length(DayNumbers),1} = [];
        
        for k = 1:length(DayNumbers)
            if ~isempty(indWeekends) && any(k==indWeekends)
                DWpattern{k} = DW.WeekendAvg;
                
                % if Weekend has NO DATA
                % there are bigger chance that BSF weekend be empty due to
                % smaller sample size (+-3 days around a storm)
                if all(isnan(BSF.WeekendAvg))
                    BSFpattern{k} = BSF.WeekdayAvg;
                else
                    BSFpattern{k} = BSF.WeekendAvg;
                end
            else
                DWpattern{k} = DW.WeekdayAvg;
                BSFpattern{k} = BSF.WeekdayAvg;
            end
        end
        
        % ------------------------------ use cell!!!
        DWtseries = cell2mat(DWpattern);
        BSFtseries = cell2mat(BSFpattern);
        HourlyTseries = StormStartDay:1/24:StormEndDay-1/24;
        
        if length(DWtseries) ~= length(HourlyTseries)
            disp('Diurnal Data not matched with hourly time series.');
        end
        DiurnalInd = find(HourlyTseries>=StormStart & HourlyTseries<=StormEnd);
%         StormStartVec = datevec(StormStart);
%         StormEndVec = datevec(StormEnd);
%         
%         if StormEndVec(5) ~= 0  % if storm end minutes is b/w 05 ~ 55 then include the next top of the hour
%                                 % e.g. a storm ends at 3:50, then diurnal
%                                 % includes 4:00
%             DiurnalInd = [DiurnalInd DiurnalInd(end)+1];
%         end
        
        % -------------------------------------------------------------------------- TABLE CONTENTS
        StormGWI = sum(BSFtseries(DiurnalInd).*BSF.AverageBaseDSF) - ...
            sum(DWtseries(DiurnalInd).*DW.AverageBaseDSF + DW.AverageBaseGWI);
        StormGWI = StormGWI/24;
        % Storm GWI (MG)
        stats{i,4} = StormGWI;  % unit in MGD - hourly data must be devided by 24 to get daily value

        % Total Volume
        stats{i,5} = sum(FM{4}(StormIndices)) * ...
            handles.Input.FM.iInterfaceDataTimeInterval /24/60;
        % Storm Volume
        stats{i,6} = stats{i,5} - sum(BSFtseries(DiurnalInd).*BSF.AverageBaseDSF)/24;
        
        % Total Rain (inch)
        stats{i,7} = StormID.StormVolume(i);
        stats{i,8} = false;  % default: non-selected
        
        BaseSanitaryFlow{i} = BSF;
        StormInfo{i} = StormSpec;
        
        clear DWpattern BSFpattern BSF StormSpec
    end
    handles.BSF = BaseSanitaryFlow;
end
set(handles.uitable_StormID, 'Data', stats);


handles.RG = RG;
handles.FM = FM;
handles.DW = DW;
handles.StormID = StormID;
handles.StormInfo = StormInfo;
handles.table1_stats = stats;
%
guidata(hObject, handles);

% --------------------------------------------------------------------
function [RGcell,FMcell,DW] = fun_MDW_Calibrate_GUI(IN,StormSpecific,StormSpec)
% global st_name st_num PathName
% Read input file
% [FileNameDATA,PathName] = uigetfile( ...
%     {'*.csv',  'comma separated variables (*.csv)'; ...
%     '*.xlsx','Excel file (*.xlsx)'; ...
%     '*.*',  'All Files (*.*)'}, ...
%     'Pick a DATA file');
if nargin < 2
    StormSpecific = false;
    StormSpec = [];
end

if ~StormSpecific
    fid = fopen(fullfile(IN.PathName,IN.FileNameDATA));
    % readData = '%s%f%*f%*f%f';
    
    
    % read date string from csv
    fgetl(fid); FirstLine = fgetl(fid);
    SMColon = regexp(FirstLine,':');
    frewind(fid);
    
    if length(SMColon) == 1
        readData = '%s%f%*f%*f%f';
        C = textscan(fid,readData,'delimiter',',','headerlines',1);
        
        tsRaw = datenum(C{1});
        
        
    elseif length(SMColon) == 2
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
        tsRaw = datenum(D);
        

    end
    
    
    PathFigures = [IN.PathName 'Figures'];
    if exist(PathFigures,'dir')==0
        mkdir(PathFigures)
    end
    PathTables = [IN.PathName 'Tables'];
    if exist(PathTables,'dir')==0
        mkdir(PathTables)
    end
    
    
    %
    % ts: equidistant time series
    fclose(fid);

    % limit data usage for DWF
    
    SummerOnly = 1;

    if round(mode(diff(tsRaw))*60*24) ~= IN.RG.dt
        dGap = round(mode(diff(tsRaw))*60*24);  % 'mode' of dt in data
        IN.RG.dt = dGap;
        IN.FM.iInterfaceDataTimeInterval = dGap;
    else
        dGap = IN.RG.dt;
    end
    
    if length(SMColon) == 1
        tsEqu = tsRaw(1):dGap/60/24:tsRaw(end);
        
        StartSelection = tsEqu(1);
        EndSelection = tsEqu(end);
        
    elseif length(SMColon) == 2
        
        tsEqu = datenum(D(1,:)):dGap/60/24:datenum(D(end,:));
        
        StartSelection = datenum([2010 7 1 0 0 0]);
        EndSelection = datenum([2010 10 1 0 0 0]);
        
    end
    
    FMraw = C{end-1}(1:length(tsRaw));
    RGraw = C{end}(1:length(tsRaw));
    
    
else
    SummerOnly = 0;

    tsRaw = StormSpec.ts;
    
    if round(mode(diff(tsRaw))*60*24) ~= IN.RG.dt
        dGap = round(mode(diff(tsRaw))*60*24);  % 'mode' of dt in data
        IN.RG.dt = dGap;
        IN.FM.iInterfaceDataTimeInterval = dGap;
    else
        dGap = IN.RG.dt;
    end

    tsEqu = tsRaw(1):dGap/60/24:tsRaw(end);
    
    FMraw = StormSpec.FM;
    RGraw = StormSpec.RG;
    
    StartSelection = tsEqu(1);
    EndSelection = tsEqu(end);


end

% replace NaN in RGraw with ZEROs for interpolation purpose
RGraw(isnan(RGraw)) = 0;

ind_nan = isnan(FMraw);
% plot only non-NaN


%{
%%%%%%   this is taken care of inside [Storm_ID_GUI.m]
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
%}



FM = interp1(tsRaw(~ind_nan),FMraw(~ind_nan),tsEqu);
RG = interp1(tsRaw,RGraw,tsEqu);  % NaN in RG has been replaced by zeros already

%{
% Exclude data gap (not the regular widened intervals)
%  DataSum = sum(a(~isnan(a))); % if there's NaN in the array

% [ai,bi] = intersect(tsEqu,tsRaw(ind_nan));
% %   [bi] is to find missing data when there are time string not missing
% %   FM(bi) = NaN;  will remove all interpolated data

% to remove gaps where time stamps are missing
% xxx = diff(tsRaw).*60*24;   % in minutes
% tsRawGapInd = find(xxx > dGap+1);  % 5 + 1 = 6 minutes
% for i = 1:length(tsRawGapInd)
%
% end

%}

% Find indices for 00:00 of each day

% save all data before replacing them with summer months (or storm specific) data

if SummerOnly
    FM_all = FM;
    RG_all = RG;
    tsEqu_all = tsEqu;
    
    
    % ====================================================================
    % This is stupid!! change this based on if the selection is only for
    % summer days or not
    % Or see if the data even has summer days at all!
    
    if length(SMColon) == 1
        indSelection = find(tsEqu>=StartSelection & tsEqu<=EndSelection);
    elseif length(SMColon) == 2
        
        indSelection = find(tsEqu>=StartSelection & tsEqu<EndSelection);
    end
    % ====================================================================
    
    FM = FM(indSelection);
    RG = RG(indSelection);
    tsEqu = tsEqu(indSelection);
elseif StormSpecific
    FM_all = FM;
    RG_all = RG;
    tsEqu_all = tsEqu;
    
    FM = FM(1:end-1);  % remove last 00:00 data
    RG = RG(1:end-1);
    tsEqu = tsEqu(1:end-1);
    
%     indSelection = find(tsEqu>=StartSelection & tsEqu<EndSelection);
%     FM = FM(indSelection);
%     RG = RG(indSelection);
%     tsEqu = tsEqu(indSelection);
%        
else
    FM_all = FM;
    RG_all = RG;
    tsEqu_all = tsEqu;
    
end

indHrRG_1st = find(mod(tsEqu(1:24*60/dGap*2),1)==0,1);
indHrRG = indHrRG_1st:24*60/IN.RG.dt:length(tsEqu);
indHrFM = indHrRG;

%{
% Hf_1 = figure('NumberTitle','off','Name',sprintf('Meter Data %s: %s',st_name,st_num));
% set(Hf_1,'Units','pixel','Position',[100 100 800 600]);
% 
% plot(tsRaw,FMraw,'ro')
% hold on
% plot(tsEqu,FM,'.-')
% title(sprintf('Flodar Meter, Basin: %s, Meter number: %s',st_name,st_num))
% legend('Data (raw)','Data (gap filled)')
% grid
% set(gca,'xlim',[StartSelection EndSelection]);
% 
% datetick('x',2,'keepticks')
% xlabel('day')
% ylabel('MGD')
% 
% FigName1 = sprintf('%s_%s_FM',st_num,st_name);
% print(Hf_1,'-dpng',fullfile(PathName,FigName1))

% Calculate daily statistics: total rain, avg, minimum
%}

% ------------------------------ step 1 & 3
if length(indHrRG) ~= EndSelection-StartSelection
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

% ------------------------------ step 2
if length(indHrFM) ~= EndSelection-StartSelection
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
%{        
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
%}
        
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

% ------------------------------ step 4: calculate weekdays/weekend
[N,S]=weekday(tsEqu(indHrRG));
weekendInd = find(N == 1 | N == 7);

% ------------------------------ step 5: Base GWI and Base DSF

% initialize variables
pBaseGWI = zeros(length(indHrFM),1);
pBaseDSF = zeros(length(indHrFM),1);

% define threshold
if SummerOnly
    indBFWI = find(pDaysSinceRain > IN.FM.iInterfaceDaysSinceRain); % above threshold dry days.
else  % if storm specific - remove the threshold for consecutive dry days
      % instead it uses total rain threshold to find 'non-rainy' storm
      % event days (+- 3 days around a storm event).
      indBFWI = find(pDailyRain <= 0.1);
      disp('----------------------------------')
      disp('Non-rainy day during storm')
      disp(datestr(StormSpec.ts(indHrRG(indBFWI))))

end

indNegAvgFlow = find(pAvgFlow <= 0);  % check negative (unreal) average flow

% calculations
pBaseGWI(indBFWI) = pMinFlow(indBFWI).*IN.FM.iInterfacePercentageBaseGWI;
pBaseGWI(indNegAvgFlow) = 0;
if SummerOnly
    pBaseDSF(indBFWI) = pAvgFlow(indBFWI) - pBaseGWI(indBFWI);
else
    pBaseDSF(indBFWI) = pAvgFlow(indBFWI); % remove GWI for storm BSF
end

DW.AverageBaseGWI = mean(nonzeros(pBaseGWI));
DW.AverageBaseDSF = mean(nonzeros(pBaseDSF));

% ------------------------------ step 6
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
        
        if SummerOnly
            pDiurnalFlow(j,:) = (pHourlyFlow - pBaseGWI(indBFWI(j)))/pBaseDSF(indBFWI(j));
        else
            pDiurnalFlow(j,:) = pHourlyFlow/pBaseDSF(indBFWI(j));
        end           
        
        clear xx
        
    end
end

% RawDateVec = datevec(FM{1}(indSelectedDate));

DryDateStr = datestr(tsEqu(indHrFM(indBFWI(indBaseGWInonZero))));

pDiurnalFlow = pDiurnalFlow(indBaseGWInonZero,:)';


% ------------------------------ step 7  - weekend/weekday average
[Ndry,Sdry]=weekday(DryDateStr);
DryWeekendInd = find(Ndry == 1 | Ndry == 7);
DryWeekdayInd = find(Ndry ~= 1 & Ndry ~= 7);

pWeekendArray = pDiurnalFlow(:,DryWeekendInd);
pWeekdayArray = pDiurnalFlow(:,DryWeekdayInd);

DW.WeekendAvg = mean(pWeekendArray,2);
DW.WeekdayAvg = mean(pWeekdayArray,2);

% hourseries = 0:24;

%{
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
%}   

% ------------------------------ Plot Rain
%{
    Hf_3 = figure('NumberTitle','off','Name',sprintf('Rain %s: %s',st_name,st_num));
    set(Hf_3,'Units','pixel','Position',[110 10 800 600]);

    %
    s1 = subplot(4,1,1);
    t1 = bar(tsEqu(indHrRG),pDailyRain);
    datetick('x',2)
    grid
    set(s1,'xtickLabel',{''})
    set(s1,'xlim',[StartSelection EndSelection])
    set(s1,'position',[0.13 .728 .775 .2]);
    set(s1,'ydir','reverse')
    ylabel('inch')
    set(gca,'xlim',[StartSelection EndSelection]);
    title(sprintf('Daily Rain, Flodar Meter - Basin: %s, Meter number: %s',st_name,st_num))

    %
    s2 = subplot(4,1,2:4);
    plot(tsRaw,FMraw,'r.')
    hold on
    plot(tsEqu,FM)
    legend('Data (raw)','Data (gap filled)')
    grid
    set(s2,'xlim',[StartSelection EndSelection]);

    datetick('x',2,'keepticks')
    xlabel('day')
    ylabel('MGD')

    FigName3 = sprintf('%s_%s_Rain_FM',st_num,regexprep(st_name,' ','_'));
    print(Hf_3,'-dpng',fullfile(PathFigures,FigName3))
%}

% ------------------------------ Output
FMcell{1} = tsEqu;
FMcell{2} = FM;
FMcell{3} = tsEqu_all;
FMcell{4} = FM_all;

RGcell{1} = tsEqu;
RGcell{2} = RG;
RGcell{3} = tsEqu_all;
RGcell{4} = RG_all;

% ------------------------------ Write DWF to ASCII
if SummerOnly
    DWF_ASCII_name = sprintf('%s_%s_DWF_table.txt',IN.st_num,regexprep(IN.st_name,' ','_'));
    fidw = fopen(fullfile(PathTables,DWF_ASCII_name),'w');
    fprintf(fidw,'TITLE\n');
    fprintf(fidw,'%s at %s\n',IN.st_name,IN.st_num);
    fprintf(fidw,'CALIBRATION_WEEKDAY\nTIME,FLOW,POLLUTANT\n');
    fprintf(fidw,'%2d:00,%.2f,1\n',[0:23; DW.WeekdayAvg']);
    fprintf(fidw,'CALIBRATION_WEEKEND\nTIME,FLOW,POLLUTANT\n');
    fprintf(fidw,'%2d:00,%.2f,1\n',[0:23; DW.WeekendAvg']);
    
    fclose(fidw);
end


% --------------------------------------------------------------------
function StormID = fun_storm_identification_GUI(IN,RG)
% Storm identification
% global st_name st_num PathName

RainT = RG{3};   % datenum
RainRaw = RG{4}; % double array
% RG{1:2} is for the 'Summer' data

RainRaw(RainRaw == 0) = NaN;


% ------------------------------ 
indgap = find(isnan(RainRaw));
diffIndGap = diff(indgap);
diffIndGap(diffIndGap == 1) = NaN;


% plot(indgap(1:end-1),diffIndGap,'r.-')
% grid
% hold on
% plot(RainRaw,'.')
% title('red dots identify start of each storm')

% ------------------------------ 
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

% ------------------------------ 
% gap between storms (e.g. separated by 12 hours of dry period)
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
% ------------------------------ 
% find only storms longer than threshold duration (e.g. 24 hr)

yy = StormIdDate(2,:) - StormIdDate(1,:);

StormIdEffective = StormIdDate(:,yy>=IN.RG.storm_duration/24);

% ------------------------------ 
% find storms greater than threshold volume (e.g. 0.25 inch)
[~,NumOfStorm] = size(StormIdEffective);
StormVolume = zeros(1,NumOfStorm);
for j = 1:NumOfStorm
    StormVolume(j) = sum(RG{4}(StormIdEffective(3,j):StormIdEffective(4,j)));
end

StormIdFinal = find(StormVolume>=IN.RG.storm_volume);

% ------------------------------ 
% write to text file

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

% ------------------------------ 
%plot a sample storm

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


% ------------------------------ 
function fun_plot_RDI_GUI(handles)

% cla(handles.axes_RDII)
% cla(handles.axes_Rain)
% cla(handles.axes_DWF)

StormID = handles.StormID;
RG = handles.RG(3:4);  % use the entire data
FM = handles.FM(3:4);
DW = handles.DW;

StormNum = handles.StormNum;
BSF = handles.BSF{StormNum};

% global st_name st_num PathName

Plot_3days_BeforeAfter = true;

PathFigures = [handles.Input.PathName 'Figures'];
if exist(PathFigures,'dir')==0
    mkdir(PathFigures)
end
PathTables = [handles.Input.PathName 'Tables'];
if exist(PathTables,'dir')==0
    mkdir(PathTables)
end

% ------------------------------ Plot RDI
if isempty(StormID.StormVolume)
    figId = 1;
%     Hf_ = figure(figId+3);
%     set(Hf_,'Units','pixel','Position',[110+5*figId 10 800 600]);
    
%     s1 = subplot(4,1,1);
    t1 = bar(handles.axes_Rain,RG{1},RG{2});
    %     datetick('x',2)
    grid
    datetick(handles.axes_Rain,'x',2)
    set(handles.axes_Rain,'xtickLabel',{''})
    set(handles.axes_Rain,'xlim',[FM{1}(1) FM{1}(end)])
%     set(handles.axes_Rain,'position',[0.13 .728 .775 .2]);
    set(handles.axes_Rain,'ydir','reverse')
    ylabel('inch')
%     title('No qualified storm event')
    title(sprintf('Basin: %s, Meter number: %s, No qualified storm',st_name,st_num))

%     s2 = subplot(4,1,2:4);
    plot(handles.axes_RDII,FM{1},FM{2},'.-','linewidth',1)
    
    hold on
    
    datetick(handles.axes_RDII,'x',2)
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
    BSFpattern{length(DayNumbers),1} = [];
    for k = 1:length(DayNumbers)
        if ~isempty(indWeekends) && any(k==indWeekends)
            DWpattern{k} = DW.WeekendAvg;
            if all(isnan(BSF.WeekendAvg))
                BSFpattern{k} = BSF.WeekdayAvg;
            else
                BSFpattern{k} = BSF.WeekendAvg;
            end
        else
            DWpattern{k} = DW.WeekdayAvg;
            BSFpattern{k} = BSF.WeekdayAvg;
        end
    end
    
    %
    % ------------------------------  use cell!!!
    
    DWtseries = cell2mat(DWpattern);
    BSFtseries = cell2mat(BSFpattern);
    % DWpattern starts at 00:00
    
    % ------------------------------ Work on plotting in a same axis!!!
    
    
    % plot(DWtseries,'g','linewidth',2)
    DWPlotStartHH = str2double(datestr(FM{1}(1),'HH'));
    
    % storm start Hour | DW starts midnight, e.g. 1:00 -> 2nd row
    
    DWHourlyData = DWtseries(DWPlotStartHH + 1:end,:);
    BSFHourlyData = BSFtseries(DWPlotStartHH + 1:end,:);
    DWTimeAxis = datenum(StormStartDay)+ [DWPlotStartHH/24:1/24:(length(DWtseries)-1)/24];
    
    % ------------------------------ PLOT
    %     pFlow = DWHourlyData .* Input.FM.Population * Input.FM.PerCapitaFlow /10^6 + Input.FM.iInterfaceBaseGWI; % hourly
    pFlow = DWHourlyData .* DW.AverageBaseDSF + DW.AverageBaseGWI;
    pBSF  = BSFHourlyData.*BSF.AverageBaseDSF;
    
    pFlowInterp = interp1(DWTimeAxis,pFlow,FM{1});
    pBSFInterp = interp1(DWTimeAxis,pBSF,FM{1});
    % pFlowInterp = pFlowInterp';
    
    plot(handles.axes_RDII,FM{1},pFlowInterp,'g','linewidth',1)
    plot(handles.axes_RDII,FM{1},pBSFInterp,'m','linewidth',1)
    %         plot(FM{1},FM{2} - pFlowInterp,'r','linewidth',2)
    % hold on
    % plot(DWTimeAxis,pFlow,'go-','linewidth',2)
    set(handles.axes_RDII,'xlim',[FM{1}(1) FM{1}(end)])
    xlabel(handles.axes_RDII,'date')
    ylabel(handles.axes_RDII,'MGD')
    legend(handles.axes_RDII,'Flow','Baseflow')
    
%     FigName = sprintf('%s_%s_Storm_Null',st_num,regexprep(st_name,' ','_'));
%     print(Hf_,'-dpng',fullfile(PathFigures,FigName))
else
    
    figId = StormNum;
    %     for figId = 1:size(StormID.StormIdEffective,2)
    
    StormPlotId = StormID.StormIdEffective(3,figId):StormID.StormIdEffective(4,figId);

    if Plot_3days_BeforeAfter
        ExtStart = find(FM{1} == handles.StormInfo{StormNum}.ts(1));
        ExtEnd   = find(FM{1} == handles.StormInfo{StormNum}.ts(end));
        StormPlotIdExt = ExtStart:ExtEnd;
        ExcludePrecedDays = 2;
    else
        % sort indices for storm
        
        % StormPlotIdExt needs to be determined based on RDI threshold!!!!!
        % -----
        if StormPlotId(end)+length(StormPlotId) > length(FM{1})
            StormPlotIdExt = StormPlotId(1):length(FM{1});
        else
            StormPlotIdExt = StormPlotId(1):StormPlotId(end)+length(StormPlotId);
        end
        % -----------------------------------------------------------------------
        
    end
    bar(handles.axes_Rain,RG{1}(StormPlotIdExt),RG{2}(StormPlotIdExt))
    %     datetick('x',2)
    grid(handles.axes_Rain)
    set(handles.axes_Rain,'xtickLabel',{''})
    set(handles.axes_Rain,'xlim',[FM{1}(StormPlotIdExt(1))+ExcludePrecedDays FM{1}(StormPlotIdExt(end))])
    %         set(handles.axes_Rain,'position',[0.13 .728 .775 .2]);
    set(handles.axes_Rain,'ydir','reverse')
    ylabel(handles.axes_Rain,'inch')
    title(handles.axes_Rain,sprintf('Basin: %s, Meter number: %s, Storm %d',handles.Input.st_name,handles.Input.st_num,figId))
    
    %         s2 = subplot(4,1,2:4);
    p(1) = plot(handles.axes_RDII,FM{1}(StormPlotIdExt),FM{2}(StormPlotIdExt),'color',[72 188 255]./255);
    hold(handles.axes_RDII,'on')
    plot(handles.axes_RDII,FM{1}(StormPlotId),FM{2}(StormPlotId),'b','linewidth',1);
    grid(handles.axes_RDII,'on')
    
    
    StormStartTime =  datevec(RG{1}(StormPlotId(1)));
    StormStartDay = [StormStartTime(1:3) 0 0 0];
    StormEndTime =  datevec(RG{1}(StormPlotId(end)));
    StormEndTimeExt =  datevec(RG{1}(StormPlotIdExt(end)));
    
    StormDuration = (datenum(StormEndTime)- datenum(StormStartTime))*24; % hours
    
    % 1-Sun, 2-Mon, 3-Tue, ..., 7-Sat
    if Plot_3days_BeforeAfter
        DayNumbers = weekday(handles.StormInfo{StormNum}.ts(1):handles.StormInfo{StormNum}.ts(end-1));
    else
        DayNumbers = weekday(datenum(StormStartTime):datenum(StormEndTimeExt));
    end
    % DayNumbers = [4:7 1:7 1:3];  % sample
    
    % repeat weekday data for the length of storm REGARDLESS of weekend (yet).
    DW_series = repmat(DW.WeekdayAvg,length(DayNumbers),1);
    
    indWeekends = find(DayNumbers==1 | DayNumbers==7);
    % if any(DayNumbers==1 & DayNumbers==7) % if there are weekend days
    %     indWeekends = find(DayNumbers==1 | DayNumbers==7);
    %     DWcell{indWeekends} = DW.WeekendAvg;
    % end
    
    DWpattern{length(DayNumbers),1} = [];
    BSFpattern{length(DayNumbers),1} = [];
    for k = 1:length(DayNumbers)
        if ~isempty(indWeekends) && any(k==indWeekends)
            DWpattern{k} = DW.WeekendAvg;
            if all(isnan(BSF.WeekendAvg))
                BSFpattern{k} = BSF.WeekdayAvg;
            else
                BSFpattern{k} = BSF.WeekendAvg;
            end
        else
            DWpattern{k} = DW.WeekdayAvg;
            BSFpattern{k} = BSF.WeekdayAvg;
        end
    end
    
    % ------------------------------ use cell!!!
    
    DWtseries = cell2mat(DWpattern);
    BSFtseries = cell2mat(BSFpattern);
    % DWpattern starts at 00:00
    
    % ------------------------------ Work on plotting in a same axis!!!
    
    if Plot_3days_BeforeAfter
        DWPlotStartHH = str2double(datestr(FM{1}(StormPlotIdExt(1)),'HH'));
        % ts{end} indicate the 00:00 of the last day; need to add another
        % day after this 00:00 to include the last day.
        DWTimeAxis = handles.StormInfo{StormNum}.ts(1):1/24:handles.StormInfo{StormNum}.ts(end-1);
        
    else
        % plot(DWtseries,'g','linewidth',2)
        DWPlotStartHH = str2double(datestr(FM{1}(StormPlotId(1)),'HH'));
        
        % storm start Hour | DW starts midnight, e.g. 1:00 -> 2nd row
        
        DWTimeAxis = datenum(StormStartDay)+ [DWPlotStartHH/24:1/24:(length(DWtseries)-1)/24];
    
    end
    DWHourlyData = DWtseries(DWPlotStartHH + 1:end,:);
    BSFHourlyData = BSFtseries(DWPlotStartHH + 1:end,:);
% plot(DWPlotTHour,DWHourlyData,'.-')
    
    % ------------------------------ PLOT
    %     pFlow = DWHourlyData .* Input.FM.Population * Input.FM.PerCapitaFlow /10^6 + Input.FM.iInterfaceBaseGWI; % hourly
    pFlow = DWHourlyData .* DW.AverageBaseDSF + DW.AverageBaseGWI;
    pBSF  = BSFHourlyData.*BSF.AverageBaseDSF;
    
    pFlowInterp = interp1(DWTimeAxis,pFlow,FM{1}(StormPlotIdExt));
    pBSFInterp = interp1(DWTimeAxis,pBSF,FM{1}(StormPlotIdExt));
    % pFlowInterp = pFlowInterp';
    
    % BSF
    p(2) = plot(handles.axes_RDII,FM{1}(StormPlotIdExt),pBSFInterp,'m','linewidth',1);
    % DBSF
    p(3) = plot(handles.axes_RDII,FM{1}(StormPlotIdExt),pFlowInterp,'g','linewidth',1);
    % RDI/I
    p(4) = plot(handles.axes_RDII,FM{1}(StormPlotIdExt),FM{2}(StormPlotIdExt) - pBSFInterp,'r','linewidth',1);
    
    %plot zero line
    plot(handles.axes_RDII,[FM{1}(StormPlotIdExt(1))+ExcludePrecedDays FM{1}(StormPlotIdExt(end))],[0 0],'k')
    % hold on
    
    % [ExcludePrecedDays] means; -3+(2) = -1: plot one day earlier only as [StormPlotIdExt] starts 3 days earlier than the actual storm event
    set(handles.axes_RDII,'xlim',[FM{1}(StormPlotIdExt(1))+ExcludePrecedDays FM{1}(StormPlotIdExt(end))])
    set(handles.axes_RDII,'xtick',FM{1}(StormPlotIdExt(1))+ExcludePrecedDays:FM{1}(StormPlotIdExt(end)))
    datetick(handles.axes_RDII,'x',2,'keeplimits','keepticks')
%{    
%     % patch draw
%     axes(handles.axes_RDII);
%     xxx = [FM{1}(StormPlotId(1)) FM{1}(StormPlotId(1)) FM{1}(StormPlotId(end)) FM{1}(StormPlotId(end))];
%     yyy = get(handles.axes_RDII,'ylim');
%     yyyy = [yyy(1) yyy(2) yyy(2) yyy(1)];
%     patch(xxx,yyyy,'red','faceAlpha',0.2)
%}    
    plotTF(1) = true; % plot 'flow' data always
    
    plotTF(2) = get(handles.radiobutton_BSF,'Value');
    if plotTF(2) ~= 1
        set(p(2),'visible','off')
    end
    
    plotTF(3) = get(handles.radiobutton_DBSF,'Value');
    if plotTF(3) ~= 1
        set(p(3),'visible','off')
    end
    
    plotTF(4) = get(handles.radiobutton_RDII,'Value');
    if plotTF(4) ~= 1
        set(p(4),'visible','off')
    end
    
    legend_labels = {'Flow';'BSF';'DBSF';'RDI/I'};
    
    xlabel(handles.axes_RDII,'date')
    ylabel(handles.axes_RDII,'MGD')
    legend(handles.axes_RDII,p(plotTF),legend_labels(plotTF))
    
    if isfield(handles,'ResponsePeriod')
        if ~isempty(handles.ResponsePeriod{StormNum})
            areaYlim = get(handles.axes_RDII,'ylim');
            
            StormAreaColor = [255 239 213]/255;
            h_area = area(handles.axes_RDII,handles.ResponsePeriod{StormNum},[areaYlim(2) areaYlim(2)],'facecolor',StormAreaColor, ...
                'edgecolor',StormAreaColor);
            set(h_area,'BaseValue',areaYlim(1))
            set(handles.axes_RDII,'layer','top')
        end
    end
    
    hold(handles.axes_RDII,'off')
    
%     handles.plot_lines = p;

end
% guidata(hObject, handles);


% --- Executes when selected cell(s) is changed in uitable_StormID.
function uitable_StormID_CellSelectionCallback(hObject, eventdata, handles)
% % hObject    handle to uitable_StormID (see GCBO)
% % eventdata  structure with the following fields (see UITABLE)
% %	Indices: row and column indices of the cell(s) currently selecteds
% % handles    structure with handles and user data (see GUIDATA)
% 
% % row selection:
if ~isempty(eventdata.Indices(:,1))  
    % when the table was updated from another function then event data
    % becomes empty
    selection = eventdata.Indices(:,1);
    handles.StormNum = selection;
else
    selection = handles.StormNum;
end
disp(sprintf('Processing Storm No. %d',selection))

fun_plot_RDI_GUI(handles)
%{
% if there's no previously assigned manual response end - turn off the
% toggle button
% if isempty(findobj(handles.axes_RDII,'Type','patch'))
%     set(handles.pushbutton_ResponseEnd,'value',0)  
% end
%}
guidata(hObject, handles);

% --- Executes on button press in pushbutton_Compute_Rfactor.
function pushbutton_Compute_Rfactor_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Compute_Rfactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stats = get(handles.uitable_StormID, 'Data');
Storm_logical = cell2mat(stats(:,end));
StormRind = find(Storm_logical == 1);

for i = 1:length(StormRind)
    RfactorTable{i,1} = StormRind(i);
    RfactorTable{i,2} = handles.table1_stats{StormRind(i),6};
    RfactorTable{i,3} = handles.Input.FM.Area;
    RfactorTable{i,4} = handles.table1_stats{StormRind(i),7}*handles.Input.FM.Area*27154.285/10^6;
    RfactorTable{i,5} = RfactorTable{i,2}/RfactorTable{i,4}*100;
end

set(handles.uitable_Rfactor, 'Data', RfactorTable);
scatter(handles.axes_Rfactor,cell2mat(RfactorTable(:,2)),cell2mat(RfactorTable(:,4)),'square','filled')
ylabel(handles.axes_Rfactor,'Rainfall (MG)')
xlabel(handles.axes_Rfactor,'RDI/I Volume (MG)')
title(handles.axes_Rfactor,sprintf('RDI/I Separation: Avg R %.2f%%',mean(cell2mat(RfactorTable(:,5)))))
grid(handles.axes_Rfactor,'on')
ylim_Rfactor = get(handles.axes_Rfactor,'ylim');
set(handles.axes_Rfactor,'ylim',[0 ylim_Rfactor(2)])

% guidata(hObject, handles);


function Input = fun_read_RDI_input_GUI(FileName,PathName)
% Read input file
% [FileName,PathName] = uigetfile('*.inp','Select the inp file');

if isempty(findstr(FileName,'xls'))
    % if file is NOT an excel file
    finp = fopen(fullfile(PathName,FileName));
    clear FileName PathName
    % ---- RG data
    fgetl(finp);fgetl(finp);
    Input.RG.path = fgetl(finp); fgetl(finp);
    Input.RG.name = fgetl(finp); fgetl(finp);
    
    Input.RG.dt = str2double(fgetl(finp)); fgetl(finp);
    Input.RG.storm_duration = str2double(fgetl(finp)); fgetl(finp);
    Input.RG.inter_event = str2double(fgetl(finp)); fgetl(finp);
    Input.RG.storm_volume = str2double(fgetl(finp)); fgetl(finp); fgetl(finp);
    % ---- FM data
    Input.FM.path = fgetl(finp); fgetl(finp);
    Input.FM.name = fgetl(finp); fgetl(finp);
    
    Input.FM.DateTime_Adjust = 693960; % add this to Excel datenum to get MATLAB datenum
    % No. of Precedent Dry Weather Days
    Input.FM.iInterfaceDaysSinceRain = str2double(fgetl(finp)); fgetl(finp);
    % Estimated base GWI
    Input.FM.iInterfacePercentageBaseGWI = str2double(fgetl(finp)); fgetl(finp);
    Input.FM.iInterfaceDataTimeInterval = str2double(fgetl(finp)); fgetl(finp);         % minutes
    fgetl(finp);fgetl(finp);
    
    Input.FM.PerCapitaFlow = str2double(fgetl(finp)); fgetl(finp); 
    Input.FM.Population = str2double(fgetl(finp)); fgetl(finp); 
    Input.FM.iInterfaceBaseGWI = str2double(fgetl(finp)); fgetl(finp); 
    Input.FM.AverageDrySanitaryFlow = str2double(fgetl(finp)); fgetl(finp); 
%     Input.FM.Area = num(19,3);

    fclose(finp);
    
    
else
    % if setup file IS an excel file
    
    [num,txt]=xlsread(fullfile(PathName,FileName));
    
    Input.RG.path = txt{1,3};
    Input.RG.name = txt{2,3};
    
    Input.RG.dt = num(3,3);
    Input.RG.storm_duration = num(4,3);
    Input.RG.inter_event = num(5,3);
    Input.RG.storm_volume = num(6,3);
    % ---- FM data
    Input.FM.path = txt{7,3};
    Input.FM.name = txt{8,3};
    
    Input.FM.DateTime_Adjust = 693960; % add this to Excel datenum to get MATLAB datenum
    % No. of Precedent Dry Weather Days
    Input.FM.iInterfaceDaysSinceRain = num(9,3);
    % Estimated base GWI
    Input.FM.iInterfacePercentageBaseGWI = num(10,3);
    Input.FM.iInterfaceDataTimeInterval = num(11,3);         % minutes
    
    Input.FM.PerCapitaFlow = num(13,3);
    Input.FM.Population = num(14,3);
    Input.FM.iInterfaceBaseGWI = num(17,3);
    Input.FM.AverageDrySanitaryFlow = num(18,3);
    Input.FM.Area = num(19,3);
    
end


% --- Executes on button press in radiobutton_DBSF.
function radiobutton_DBSF_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_DBSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    disp('DBSF on')
else
    disp('DBSF off')
end
% disp(get(hObject,'Value'))
fun_plot_RDI_GUI(handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_DBSF


% --- Executes on button press in radiobutton_BSF.
function radiobutton_BSF_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_BSF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    disp('BSF on')
else
    disp('BSF off')
end
fun_plot_RDI_GUI(handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_BSF


% --- Executes on button press in radiobutton_RDII.
function radiobutton_RDII_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_RDII (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(hObject,'Value') == 1
    disp('RDII on')
else
    disp('RDII off')
end
fun_plot_RDI_GUI(handles)
% Hint: get(hObject,'Value') returns toggle state of radiobutton_RDII


% --- Executes on button press in pushbutton_ResponseEnd.
function pushbutton_ResponseEnd_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_ResponseEnd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj(handles.axes_RDII,'Type','patch');
delete(h)
    
[t,~]=ginput(1);
StormResponseEnd = datevec(t);

NearestMinutes = round(diff(handles.FM{3}(1:2))*24*60);
StormResponseEndMM = round(StormResponseEnd(5)/NearestMinutes)*NearestMinutes; % round to nearest 15 minutes
StormResponseEnd(5) = StormResponseEndMM;   % minutes
StormResponseEnd(6) = 0;  % secones = 0

% 'Flow' data
h = findobj(gca,'Type','line');
DispName = get(h,'Displayname');
FlowDataInd = find(strcmp('Flow',DispName) == 1);
tStorm = get(h(FlowDataInd),'XData');
% fStorm = get(h(FlowDataInd),'YData');

tResponseStart = handles.StormID.StormIdEffective(1,handles.StormNum); % same as Storm Start
% tResponseEnd = tStorm(tStorm == datenum(StormResponseEnd));
tResponseEnd = tStorm(abs((tStorm - datenum(StormResponseEnd))) < 1/60/24); % find time string within 1 minutes of selected storm End

% areaXlim = get(handles.axes_RDII,'xlim');
areaYlim = get(handles.axes_RDII,'ylim');

hold(handles.axes_RDII,'on')
StormAreaColor = [255 239 213]/255;
h_area = area(handles.axes_RDII,[tResponseStart tResponseEnd],[areaYlim(2) areaYlim(2)],'facecolor',StormAreaColor, ...
    'edgecolor',StormAreaColor);
set(h_area,'BaseValue',areaYlim(1))

% plot(handles.axes_RDII,tStorm,fStorm,'color',[72 188 255]/255,'linewidth',2)
set(handles.axes_RDII,'layer','top')
hold(handles.axes_RDII,'off')

% ------------------- UPDATE table -------------------
stats = get(handles.uitable_StormID, 'Data');


stats{handles.StormNum,3} = datestr(tResponseEnd,'yyyy/mm/dd HH:MM');


% once table updated - it reverts the table display to (1,1) cell. BAD!
set(handles.uitable_StormID, 'Data', stats);

% ------
set(handles.togglebutton_onoff,'value',1)
set(handles.togglebutton_onoff,'string','Turn Off')
if ~isfield(handles,'ResponsePeriod')
    handles.ResponsePeriod{length(handles.StormInfo)} = [];
end
handles.ResponsePeriod{handles.StormNum} = [tResponseStart tResponseEnd];  % in datenum - used in [fun_plot_RDI_GUI]

handles.table1_stats = stats;
guidata(hObject, handles);

%{
% % re-plot RDI/I (red line) ------------------------------------------------
% StormID = handles.StormID;
% % RG = handles.RG(3:4);  % use the entire data
% FM = handles.FM(3:4);
% 
% StormNum = handles.StormNum;
% % figId = StormNum;
% 
% ExtStart = find(FM{1} == handles.StormInfo{StormNum}.ts(1));
% ExtEnd   = find(FM{1} == handles.StormInfo{StormNum}.ts(end));
% StormPlotIdExt = ExtStart:ExtEnd;
% ExcludePrecedDays = 2;
% 
%     pBSFInterp = interp1(DWTimeAxis,pBSF,FM{1}(StormPlotIdExt));
% 
% 
% hold(handles.axes_RDII,'on')
% 
% plot(handles.axes_RDII,FM{1}(StormPlotIdExt),FM{2}(StormPlotIdExt) - pBSFInterp,'r','linewidth',1);
% hold(handles.axes_RDII,'off')

% Hint: get(hObject,'Value') returns toggle state of pushbutton_ResponseEnd
%}

% --- Executes on button press in togglebutton_onoff.
function togglebutton_onoff_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton_onoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

h = findobj(handles.axes_RDII,'Type','patch');

if get(hObject,'Value') == 1
    
    % Show the Area
    
    set(hObject,'String','Turn Off');
    
    set(h,'visible','on')
    
elseif get(hObject,'Value') == 0
    
    % Hide the Area
    
    set(hObject,'String','Turn On');
    
    set(h,'visible','off')

    
    
end
% Hint: get(hObject,'Value') returns toggle state of togglebutton_onoff

function ResetTablesFigures(handles)

if ~isfield(handles,'EmptyTable')
    handles.EmptyTable = get(handles.uitable_StormID, 'Data');
end
if ~isfield(handles,'EmptyTable2')
    handles.EmptyTable2 = get(handles.uitable_Rfactor, 'Data');
end

set(handles.uitable_StormID, 'Data', handles.EmptyTable);
set(handles.uitable_Rfactor, 'Data', handles.EmptyTable2);
cla(handles.axes_RDII)
legend(handles.axes_RDII,'off')
cla(handles.axes_Rain)
cla(handles.axes_DWF)
legend(handles.axes_DWF,'off')
cla(handles.axes_Rfactor)

% remove previous titles
delete(get(handles.axes_Rfactor,'title'))
delete(get(handles.axes_Rain,'title'))
delete(get(handles.axes_DWF,'title'))