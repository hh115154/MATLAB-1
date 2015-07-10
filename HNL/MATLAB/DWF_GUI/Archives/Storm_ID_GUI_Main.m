function varargout = Storm_ID_GUI_Main(varargin)
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

% Last Modified by GUIDE v2.5 06-Apr-2011 00:41:37

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

handles.EmptyTable = get(handles.uitable_StormID, 'Data');
handles.EmptyTable2 = get(handles.uitable_Rfactor, 'Data');
handles.EmptyTable3 = get(handles.uitable_FM_UpStrm,'Data');

% % Set toggle button 'unselected'
% set(handles.pushbutton_ResponseEnd,'Value',0)

% ------- fix the position
Main_position = get(hObject,'position');

set(hObject,'position',[5 5 Main_position(3) Main_position(4)]);

% set(hObject,'units',default_unit);

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
default_position = get(handles.figure1,'position');
set(handles.figure1,'position',[5 5 default_position(3) default_position(4)]);
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_FileSelect.
function pushbutton_FileSelect_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_FileSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ResetTablesFigures(handles);

% ------------------------------ select setup file

% select setup - OLD way using an external excel file
%{
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
%}


% ------------handles.Input must be provided by clicking 'Setup' pushbotton.
% handles.Input = fun_read_RDI_input_GUI(FileName_setup,PathName_setup);

% disp(handles.InputSetup)

% ------------------------------ select data file 
%{
% [FileNameDATA,PathName] = uigetfile( ...
%     {'*.csv',  'comma separated variables (*.csv)'; ...
%     '*.xlsx','Excel file (*.xlsx)'; ...
%     '*.*',  'All Files (*.*)'}, ...
%     'Pick a DATA file');
% cd(PathName)
% 
% if ispc
%     st_nameId = regexp(PathName, '\\', 'split');
%     handles.Input.st_name = st_nameId{end-1};
%     
%     st_numId = regexp(FileNameDATA,' ','split');
%     handles.Input.st_num = st_numId{1};  % str variable
% else
%     st_nameId = regexp(PathName, '/', 'split');
%     handles.Input.st_name = st_nameId{end-1};
%     
%     st_numId = regexp(FileNameDATA,' ','split');
%     handles.Input.st_num = st_numId{1};  % str variable
% end
% 
% 
% set(handles.FileLocation,'string',[pwd '\' FileNameDATA]);  % 'Edit Text' object
% 
% handles.Input.PathName = PathName;
% handles.Input.FileNameDATA = FileNameDATA;
% handles.Input.StormSpecificBSF = False;

% cd(PathName_setup)
%}
cd(handles.InputSetup.PathName)
guidata(hObject, handles);

% --- Executes on button press in pushbutton_StormID.
function pushbutton_StormID_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StormID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global RG FM DW StormID StormInfo stats BaseSanitaryFlow

% set(handles.pushbutton_ResponseEnd,'Value',0)

ResetTablesFigures(handles);

%{

By clicking '2) Identify Storm', we should achieve
1. populate table of storm list
2. plot the 1st storm RDI/I
3. plot DWF

%}

% ------------------------------ DWF analysis
if isfield(handles,'ResponsePeriod')
    handles = rmfield(handles,'ResponsePeriod');
end

[RG,FM,DW] = fun_MDW_Calibrate_GUI(handles.InputSetup);

% if round(mode(diff(FM{3}))*60*24) ~= handles.Input.RG.dt
    dGap = round(mode(diff(FM{3}))*60*24);  % 'mode' of dt in data
%     handles.Input.RG.dt = dGap;
%     handles.Input.FM.iInterfaceDataTimeInterval = dGap;
% else
%     dGap = handles.Input.RG.dt;
% end


% ------------------------------ plot DWF

hourseries = 0:24;

plot(handles.axes_DWF,hourseries,[DW.WeekdayAvg; DW.WeekdayAvg(1)],'.-',hourseries,[DW.WeekendAvg; DW.WeekendAvg(1)],'r.-')
legend(handles.axes_DWF,'Weekday','Weekend','Location','SouthEast')

if strcmp(handles.InputSetup.BSF_period{1},'All')
    title(handles.axes_DWF,sprintf('%s (%s): %s~%s',handles.InputSetup.st_name,handles.InputSetup.st_num, ...
        datestr(FM{1}(1),'mm/dd/yy'), datestr(FM{1}(end),'mm/dd/yy')))
    
else
    title(handles.axes_DWF,sprintf('%s (%s): %s~%s',handles.InputSetup.st_name,handles.InputSetup.st_num, ...
        datestr(handles.InputSetup.BSF_period{1},'mm/dd/yy'), datestr(handles.InputSetup.BSF_period{2},'mm/dd/yy')))
end
xlabel(handles.axes_DWF,'Time(hour)')
% ylabel(handles.axes_DWF,'Diurnal Factor')
% ylim(gca,[0 2])
grid(handles.axes_DWF)

% ------------------------------ Storm Identification

StormID = fun_storm_identification_GUI(handles.InputSetup,RG);

% populate the table with storm ID

% ------------------------------ plot RDI/I

% fun_plot_RDI_GUI(StormID,RG(3:4),FM(3:4),DW)

% read place holder
stats = get(handles.uitable_StormID, 'Data');
xxx = StormID.StormIdEffective(1:2,:)';
% startdate = xxx(:,1);

Storm_Extended_Days = 5;

if isempty(StormID.StormVolume)
    stats{1,1} = 'NO STORM';
    stats{1,2} = 'NO STORM';
else
    BaseSanitaryFlow{length(StormID.StormVolume),1} = [];
           StormInfo{length(StormID.StormVolume),1} = [];
    
    for i = 1:length(StormID.StormVolume)
        % storm start
        stats{i,1} = datestr(xxx(i,1),'mm/dd/yyyy HH:MM');
        % storm end
        stats{i,2} = datestr(xxx(i,2),'mm/dd/yyyy HH:MM');
        
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
       
        if StormStartDay-Storm_Extended_Days < FM{3}(1)  % if 1st storm starts withing the 3 days of existing data
%             StormWindowStartInd = ceil(FM{3}(1)); % the first midnight of the data
            StormWindowStartInd = find(FM{3} == ceil(FM{3}(1))); % the first midnight of the data
            StormWindowEndInd = find(FM{3} == StormEndDay+Storm_Extended_Days);
        elseif StormEndDay+Storm_Extended_Days > FM{3}(end) % if the last storm ends withing the last 3 days of existing data
            StormWindowStartInd = find(FM{3} == StormStartDay-Storm_Extended_Days);
            StormWindowEndInd = find(FM{3} == floor(FM{3}(end))); % the last midnight of the data
        else
            StormWindowStartInd = find(FM{3} == StormStartDay-Storm_Extended_Days);
            StormWindowEndInd = find(FM{3} == StormEndDay+Storm_Extended_Days);
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
        
%         disp(i)
        disp('----------------------------------')
        disp(sprintf('Storm %d',i))
        
        % ========================================================================
        % Storm Base Sanitary Flow (BSF)
        [~,~,BSF] = fun_MDW_Calibrate_GUI(handles.InputSetup,1,StormSpec);
        disp('----------------------------------')
        
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
            dGap/24/60;
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
        C_stege = textscan(fid,readData,'delimiter',',','headerlines',1);
        ind_C_nan = isnan(C_stege{2});  
        
        C{1} = C_stege{1}(~ind_C_nan);
        C{2} = C_stege{2}(~ind_C_nan);
        C{3} = C_stege{3}(~ind_C_nan);
        
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
    
    %{
    % remove 'folder creation'
    
    PathFigures = [IN.PathName 'Figures'];
    if exist(PathFigures,'dir')==0
        mkdir(PathFigures)
    end
    PathTables = [IN.PathName 'Tables'];
    if exist(PathTables,'dir')==0
        mkdir(PathTables)
    end
    %}
    
    %
    % ts: equidistant time series
    fclose(fid);

    % limit data usage for DWF
    
    SummerOnly = 1;
    
    %{
    if round(mode(diff(tsRaw))*60*24) ~= IN.RG.dt
        dGap = round(mode(diff(tsRaw))*60*24);  % 'mode' of dt in data
        IN.RG.dt = dGap;
        IN.FM.iInterfaceDataTimeInterval = dGap;
    else
        dGap = IN.RG.dt;
    end
    %}
    
    % NEW -- No predefined dt; find the dt based on data
    
    dGap = round(mode(diff(tsRaw))*60*24);  % 'mode' of dt in data
%         IN.RG.dt = dGap;
%         IN.FM.iInterfaceDataTimeInterval = dGap;
    
    if length(SMColon) == 1  % hardwired to Stege project
        
        tsEqu = tsRaw(1):dGap/60/24:tsRaw(end);
        
        StartSelection = tsEqu(1);
        EndSelection = tsEqu(end);
        
    elseif length(SMColon) == 2
        
        tsEqu = datenum(D(1,:)):dGap/60/24:datenum(D(end,:));
        
        if strcmp(IN.BSF_period{1},'All')   % if BSF period is selected 'all'
            StartSelection = tsEqu(1);
            EndSelection = tsEqu(end);
            
            IN.BSF_period = {datestr(StartSelection,'dd-mmm-yyyy') datestr(EndSelection,'dd-mmm-yyyy')};
        else
            StartSelection = datenum(IN.BSF_period{1});
            EndSelection = datenum(IN.BSF_period{end});
        end
%         StartSelection = datenum([2010 7 1 0 0 0]);
%         EndSelection = datenum([2010 10 1 0 0 0]);
        
    end
    
    FMraw = C{end-1}(1:length(tsRaw));
    RGraw = C{end}(1:length(tsRaw));
    
    % display BSF selection days
    disp(datestr(IN.BSF_period{1}))
    disp(datestr(IN.BSF_period{end}))
    
else
    SummerOnly = 0;

    tsRaw = StormSpec.ts;
    
%     if round(mode(diff(tsRaw))*60*24) ~= IN.RG.dt
    dGap = round(mode(diff(tsRaw))*60*24);  % 'mode' of dt in data
%         IN.RG.dt = dGap;
%         IN.FM.iInterfaceDataTimeInterval = dGap;
%     else
%         dGap = IN.RG.dt;
%     end

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
indHrRG = indHrRG_1st:24*60/dGap:length(tsEqu);
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
        if all(isnan(FMDailyBlock)) || isempty(FMDailyBlock) % either all zero or all NoData for the day!
            pTotalFlow(i) = 0;
            pAvgFlow(i) = 0;
            pMinFlow(i) = 0;
        else
            pTotalFlow(i) = sum(FMDailyBlock(~isnan(FMDailyBlock)));
            pAvgFlow(i)   = nanmean(FMDailyBlock);
            disp(i)
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
        if all(isnan(FMDailyBlock)) || isempty(FMDailyBlock) % either all zero or all NoData for the day!
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
weekdayInd = find(N ~= 1 & N ~= 7);
% ------------------------------ step 5: Base GWI and Base DSF

% initialize variables
pBaseGWI = zeros(length(indHrFM),1);
pBaseDSF = zeros(length(indHrFM),1);

% define threshold
if SummerOnly
    indBFWI = find(pDaysSinceRain > IN.GUI_iInterfaceDaysSinceRain); % above threshold dry days.
else  % if storm specific - remove the threshold for consecutive dry days
      % instead it uses total rain threshold to find 'non-rainy' storm
      % event days (+- 3 days around a storm event).
      indBFWI = find(pDailyRain <= 0.1);
%       disp('Non-rainy day during storm')
%       disp(datestr(StormSpec.ts(indHrRG(indBFWI))))

end

indNegAvgFlow = find(pAvgFlow <= 0);  % check negative (unreal) average flow

% calculations
pBaseGWI(indBFWI) = pMinFlow(indBFWI).*IN.GUI_estBaseGWI;
pBaseGWI(indNegAvgFlow) = 0;
if SummerOnly
    pBaseDSF(indBFWI) = pAvgFlow(indBFWI) - pBaseGWI(indBFWI);
else
    pBaseDSF(indBFWI) = pAvgFlow(indBFWI); % remove GWI for storm BSF
end

% ###### weighted average for BSF/GWI
avg_weighted = true;

if SummerOnly && avg_weighted
    DW.AverageBaseGWI = (mean(nonzeros(pBaseGWI(weekdayInd))) * 5 + mean(nonzeros(pBaseGWI(weekendInd))) * 2)/7;
    DW.AverageBaseDSF = (mean(nonzeros(pBaseDSF(weekdayInd))) * 5 + mean(nonzeros(pBaseDSF(weekendInd))) * 2)/7;
else
    DW.AverageBaseGWI = mean(nonzeros(pBaseGWI));
    DW.AverageBaseDSF = mean(nonzeros(pBaseDSF));
end
% ------------------------------ step 6
yy = pBaseGWI(indBFWI);
indBaseGWInonZero = find(yy~=0);  % exclude dates with GWI = 0

% pBaseGWInonZero = yy(yy~=0);

pDiurnalFlow = zeros(length(indBFWI),24); % preallocate [No. of dry days x 24 hour]
for j = 1:length(indBFWI)
    indDryDayStartRaw = indHrFM(indBFWI(j));  % start hour index of Dry days
    indDryDayEndRaw = indHrFM(indBFWI(j))+24*60/dGap-1; % end hour index of Dry days
    
    indSelectedDate = indDryDayStartRaw:indDryDayEndRaw;
    
    if length(indSelectedDate) ~= 24*60/dGap % check raw data equidistant in time
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
    %{
    % NOT writing an ASCII output

    DWF_ASCII_name = sprintf('%s_%s_DWF_table.txt',IN.st_num,regexprep(IN.st_name,' ','_'));
    
    fidw = fopen(fullfile(PathTables,DWF_ASCII_name),'w');
    fprintf(fidw,'TITLE\n');
    fprintf(fidw,'%s at %s\n',IN.st_name,IN.st_num);
    fprintf(fidw,'CALIBRATION_WEEKDAY\nTIME,FLOW,POLLUTANT\n');
    fprintf(fidw,'%2d:00,%.2f,1\n',[0:23; DW.WeekdayAvg']);
    fprintf(fidw,'CALIBRATION_WEEKEND\nTIME,FLOW,POLLUTANT\n');
    fprintf(fidw,'%2d:00,%.2f,1\n',[0:23; DW.WeekendAvg']);
    
    fclose(fidw);
    %}
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

dGap = round(mode(diff(RainT))*60*24);  % 'mode' of dt in data

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

StormIdAll(2,:) = RainT(indStormStart) + (stormLength-1)*dGap/60/24;
StormIdAllRow = reshape(StormIdAll,1,[]); % vectorize -> [start end start end, ...]
xx = diff(StormIdAllRow);

qq = indStormStart+stormLength-1;
StormStartEndIndex = [indStormStart' qq']; % INDEX for Original individual event
StormStartEndIndex = StormStartEndIndex';
StormStartEndIndexRow = reshape(StormStartEndIndex,1,[]);

% ------------------------------ 
% gap between storms (e.g. separated by 12 hours of dry period)
gapxx = xx(2:2:end);

indDivStorm = find(gapxx>=IN.GUI_inter_event/24);
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

StormIdEffective = StormIdDate(:,yy>=IN.GUI_storm_duration/24);

% ------------------------------ 
% find storms greater than threshold volume (e.g. 0.25 inch)
[~,NumOfStorm] = size(StormIdEffective);
StormVolume = zeros(1,NumOfStorm);
for j = 1:NumOfStorm
    StormVolume(j) = sum(RG{4}(StormIdEffective(3,j):StormIdEffective(4,j)));
end

StormIdFinal = find(StormVolume>=IN.GUI_storm_volume);

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
%{
% remove 'folder creation'

PathFigures = [handles.InputSetup.PathName 'Figures'];
if exist(PathFigures,'dir')==0
    mkdir(PathFigures)
end
PathTables = [handles.InputSetup.PathName 'Tables'];
if exist(PathTables,'dir')==0
    mkdir(PathTables)
end
%}
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
        StormPlotIdExt3d = ExtStart:ExtEnd;
        ExcludePrecedDays = 2;
        
        % plot 10 days more: 1/26/11 sjb
        ExtraDaysToPlot = 10;
        ExtEnd10d = handles.StormInfo{StormNum}.ts(end)+ExtraDaysToPlot;

        if ExtEnd10d > FM{1}(end)
            ExtEnd10ind = find(FM{1} == floor(FM{1}(end))); % the last midnight of the data
        else
            ExtEnd10ind = find(FM{1} == ExtEnd10d);
        end
        StormPlotIdExt = ExtStart:ExtEnd10ind;
        
        
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
    set(handles.axes_Rain,'xlim',[FM{1}(StormPlotIdExt3d(1))+ExcludePrecedDays FM{1}(StormPlotIdExt3d(end))])
    %         set(handles.axes_Rain,'position',[0.13 .728 .775 .2]);
    set(handles.axes_Rain,'ydir','reverse')
    ylabel(handles.axes_Rain,'inch')
    title(handles.axes_Rain,sprintf('Basin: %s, Meter number: %s, Storm %d',handles.InputSetup.st_name,handles.InputSetup.st_num,figId))
    
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
        DayNumbersBSF = weekday(handles.StormInfo{StormNum}.ts(1):handles.StormInfo{StormNum}.ts(end-1));
        
        % for 10 days extension: 1/26/11 sjb
        DayNumbers = weekday(handles.StormInfo{StormNum}.ts(1): FM{1}(ExtEnd10ind-1));
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
    BSFtseries = cell2mat(BSFpattern(1:length(DayNumbersBSF)));  % confine +-3 days around storm: 1/26/11 sjb
    % DWpattern starts at 00:00
    
    % ------------------------------ Work on plotting in a same axis!!!
    
    if Plot_3days_BeforeAfter
        DWPlotStartHH = str2double(datestr(FM{1}(StormPlotIdExt(1)),'HH'));
        % ts{end} indicate the 00:00 of the last day; need to add another
        % day after this 00:00 to include the last day.
        
        % 1/26/11 - sjb
        DWTimeAxis = handles.StormInfo{StormNum}.ts(1):1/24:handles.StormInfo{StormNum}.ts(end-1);
        DWTimeAxisDBSF = handles.StormInfo{StormNum}.ts(1):1/24:FM{1}(ExtEnd10ind-1);
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
    pDBSF = DWHourlyData .* DW.AverageBaseDSF + DW.AverageBaseGWI;
    pBSF  = BSFHourlyData.*BSF.AverageBaseDSF;
    
    pDBSFInterp = interp1(DWTimeAxisDBSF,pDBSF,FM{1}(StormPlotIdExt));
    pBSFInterp = interp1(DWTimeAxis,pBSF,FM{1}(StormPlotIdExt));
    % pFlowInterp = pFlowInterp';
    
    % BSF
    p(2) = plot(handles.axes_RDII,FM{1}(StormPlotIdExt),pBSFInterp,'m','linewidth',1);
    % DBSF
    p(3) = plot(handles.axes_RDII,FM{1}(StormPlotIdExt),pDBSFInterp,'g','linewidth',1);
    % RDI/I
    p(4) = plot(handles.axes_RDII,FM{1}(StormPlotIdExt),FM{2}(StormPlotIdExt) - pBSFInterp,'r','linewidth',1);
    
    %plot zero line
    plot(handles.axes_RDII,[FM{1}(StormPlotIdExt(1))+ExcludePrecedDays FM{1}(StormPlotIdExt(end))],[0 0],'k')
    % hold on
    
    % [ExcludePrecedDays] means; -3+(2) = -1: plot one day earlier only as [StormPlotIdExt] starts 3 days earlier than the actual storm event
    set(handles.axes_RDII,'xtick',FM{1}(StormPlotIdExt(1))+ExcludePrecedDays:FM{1}(StormPlotIdExt(end)))
    set(handles.axes_RDII,'xlim',[FM{1}(StormPlotIdExt3d(1))+ExcludePrecedDays FM{1}(StormPlotIdExt3d(end))])
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
    RfactorTable{i,3} = handles.InputSetup.GUI_Area;
    RfactorTable{i,4} = handles.table1_stats{StormRind(i),7}*handles.InputSetup.GUI_Area*27154.285/10^6;
    if ~isempty(handles.table1_stats{StormRind(i),3})  % if [user defined response time] exists
        storm_duration_days = datenum(handles.table1_stats{StormRind(i),3}) - ...
            datenum(handles.table1_stats{StormRind(i),1});
    else
        storm_duration_days = datenum(handles.table1_stats{StormRind(i),2}) - ...
            datenum(handles.table1_stats{StormRind(i),1});
    end
    RfactorTable{i,5} = storm_duration_days*24;
    RfactorTable{i,6} = RfactorTable{i,2}/RfactorTable{i,4}*100;
end

set(handles.uitable_Rfactor, 'Data', RfactorTable);
scatter(handles.axes_Rfactor,cell2mat(RfactorTable(:,2)),cell2mat(RfactorTable(:,4)),'square','filled')
ylabel(handles.axes_Rfactor,'Rainfall (MG)')
xlabel(handles.axes_Rfactor,'RDI/I Volume (MG)')
title(handles.axes_Rfactor,sprintf('RDI/I Separation: Avg R %.2f%%',mean(cell2mat(RfactorTable(:,6)))))
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
    
    
    % ---------------------
    % read parameters from sub-GUI window
    
%     setup_GUI = guidata(Storm_ID_GUI_Setup);
%     disp(setup_GUI);
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




% ------ toggle button 'off'
set(handles.togglebutton_onoff,'value',1)
set(handles.togglebutton_onoff,'string','Turn Off')
if ~isfield(handles,'ResponsePeriod')
    handles.ResponsePeriod{length(handles.StormInfo)} = [];
end
handles.ResponsePeriod{handles.StormNum} = [tResponseStart tResponseEnd];  % in datenum - used in [fun_plot_RDI_GUI]


% ------------------- UPDATE table -------------------
% stats = get(handles.uitable_StormID, 'Data');


% stats{handles.StormNum,3} = datestr(tResponseEnd,'yyyy/mm/dd HH:MM');

% once table updated - it reverts the table display to (1,1) cell. BAD!

stats = UpdateTable1(handles);

set(handles.uitable_StormID, 'Data', stats);





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

set(handles.uitable_StormID, 'Data', handles.EmptyTable);
set(handles.uitable_Rfactor, 'Data', handles.EmptyTable2);
% set(handles.uitable_FM_UpStrm, 'Data', handles.EmptyTable3);

% if ~isfield(handles,'EmptyTable')   % the first file selection
%     
%     EmptyTable{1} = get(handles.uitable_StormID, 'Data');
%     % end
%     % if ~isfield(handles,'EmptyTable2')
%     EmptyTable{2} = get(handles.uitable_Rfactor, 'Data');
% %     set(handles.uitable_StormID, 'Data', EmptyTable{1});
% %     set(handles.uitable_Rfactor, 'Data', EmptyTable{2});
% else
%     % if emptytable already exist, but only need to remove its  content
%     % only when there is data on Table 1 and 2
%     
%     set(handles.uitable_StormID, 'Data', handles.EmptyTable{1});
%     set(handles.uitable_Rfactor, 'Data', handles.EmptyTable{2});
% end

% % remove previous titles
% delete(get(handles.axes_Rfactor,'title'))
% delete(get(handles.axes_Rain,'title'))
% delete(get(handles.axes_DWF,'title'))

legend(handles.axes_RDII,'off')
legend(handles.axes_DWF,'off')

cla(handles.axes_RDII,'reset')
cla(handles.axes_Rain,'reset')
cla(handles.axes_DWF,'reset')

cla(handles.axes_Rfactor,'reset')


function stats = UpdateTable1(handles)

stats = get(handles.uitable_StormID, 'Data');
dGap = round(mode(diff(handles.FM{3}))*60*24);


StormStart = handles.ResponsePeriod{handles.StormNum}(1);
StormStartDay = floor(StormStart);
StormEnd = handles.ResponsePeriod{handles.StormNum}(2);
StormEndDay = ceil(StormEnd);

StormStartInd = find(handles.FM{3} == StormStart);
StormEndInd = find(handles.FM{3} == StormEnd);
StormIndices = StormStartInd:StormEndInd;
% respone end is selected by user
tResponseEnd = StormEnd;


DW = handles.DW;
BSF = handles.BSF{handles.StormNum};


DayNumbers = weekday(floor(StormStart):floor(StormEnd));
DW_series = repmat(DW.WeekdayAvg,length(DayNumbers),1);

indWeekends = find(DayNumbers==1 | DayNumbers==7);
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

DWtseries = cell2mat(DWpattern);
BSFtseries = cell2mat(BSFpattern);
HourlyTseries = StormStartDay:1/24:StormEndDay-1/24;

if length(DWtseries) ~= length(HourlyTseries)
    disp('Diurnal Data not matched with hourly time series.');
end

DiurnalInd = find(HourlyTseries>=StormStart & HourlyTseries<=StormEnd);

StormGWI = sum(BSFtseries(DiurnalInd).*BSF.AverageBaseDSF) - ...
    sum(DWtseries(DiurnalInd).*DW.AverageBaseDSF + DW.AverageBaseGWI);
StormGWI = StormGWI/24;

i = handles.StormNum;
stats{i,3} = datestr(tResponseEnd,'mm/dd/yyyy HH:MM');

stats{i,4} = StormGWI;  % unit in MGD - hourly data must be devided by 24 to get daily value

% Total Volume
stats{i,5} = sum(handles.FM{4}(StormIndices)) * dGap/24/60;
% Storm Volume
stats{i,6} = stats{i,5} - sum(BSFtseries(DiurnalInd).*BSF.AverageBaseDSF)/24;

% Total Rain (inch)
% - change total rain based on a user input: 2/3/11, sjb
StormVolume = sum(handles.RG{4}(StormStartInd:StormEndInd));

% stats{i,7} = handles.StormID.StormVolume(i);
stats{i,7} = StormVolume;
stats{i,8} = true;  % default: non-selected
        
        


% --- Executes on button press in pushbutton_setup.
function pushbutton_setup_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_setup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ResetTablesFigures(handles);

set(handles.uitable_FM_UpStrm, 'Data', handles.EmptyTable3);

% % ----------- previous opening command
% setup_GUI = guidata(Storm_ID_GUI_Setup);
% % disp(handles)

% % disp(setup_GUI);

% % This is to pass Main handles to Sub. Is it necessary? 
% % Does Sub need to know the Main handles?
Storm_ID_GUI_Setup('Storm_ID_GUI_Main', handles.figure1);
disp('Setup window closed')


% guidata(hObject, handles);


% --- Executes on button press in pushbutton_export.
function pushbutton_export_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% disp(handles)

% Select only checked storms from Storm Table
col_namex = get(handles.uitable_StormID,'columnName');
col_namex = regexprep(col_namex,'\|',' ');  % replace line change symbols in column names
col_name = regexprep(col_namex,'  ',' ');  % replace line change symbols in column names

stats = get(handles.uitable_StormID, 'Data');

col_name_Rfactorx = get(handles.uitable_Rfactor,'columnName');
col_name_Rfactorx = regexprep(col_name_Rfactorx,'\|',' ');
col_name_Rfactor = regexprep(col_name_Rfactorx,'  ',' ');

Rfactor_stats = get(handles.uitable_Rfactor,'Data');

Storm_logical = cell2mat(stats(:,end));
StormRind = find(Storm_logical == 1);

% data to export ...
stats_selected = stats(StormRind,:);  % cell array

% let user select the file location
Manual_path = true;

if ~isempty(StormRind)
    filename_export = sprintf('R_factor_%s_%s_%s.xlsx', ...
        regexprep(handles.InputSetup.st_name,' ','_'),handles.InputSetup.st_num,datestr(now,'mmmdd_HHMM'));

    if Manual_path
        [filename_excel,PathExcel] = ...
            uiputfile('*.xlsx','Export to Excel',fullfile(handles.InputSetup.PathName,filename_export));
    else
        PathExcel = [handles.InputSetup.PathName 'export'];
        if exist(PathExcel,'dir')==0
            mkdir(PathExcel)
        end
    end
    
    % ------------------------------------------ Writes Input parameters
    % Parameter_label = fieldnames(handles.InputSetup);
    Parameter_label2 = {'Sewershed';'Meter No.';'Data path';'File name'; ...
        'Min. Storm Duration';'Min. Inter-event Duration';'Min. Storm Volume'; ...
        'No. of Precedent Dry Days';'Estimated Base GWI';'Tributary Area'};
    Parameter_value = struct2cell(handles.InputSetup);
    Parameter_unit = {'hours';'hours';'inches';'days';'of Qmin';'Acres'};
    
    xlswrite(fullfile(PathExcel,filename_excel),Parameter_label2,'Parameters','A1');
    xlswrite(fullfile(PathExcel,filename_excel),Parameter_value,'Parameters','B1');
    xlswrite(fullfile(PathExcel,filename_excel),Parameter_unit,'Parameters','C5');
    
    
    % ------------------------------------------ Writes Dry Weather diurnal
%     xlswrite(fullfile(PathExcel,filename_excel),{'DBSF'},'Diurnal','A1');
    xlswrite(fullfile(PathExcel,filename_excel),{'Hour','Weekday','Weekend'},'Diurnal','A1');
    
    Average_values = {'Avg GWI',handles.DW.AverageBaseGWI,'MGD';'Avg DSF',handles.DW.AverageBaseDSF,'MGD'};
    xlswrite(fullfile(PathExcel,filename_excel),Average_values,'Diurnal','E1');

    hours_data = 0:23;
    Diurnal_data = [hours_data' handles.DW.WeekdayAvg handles.DW.WeekendAvg];
    xlswrite(fullfile(PathExcel,filename_excel),Diurnal_data,'Diurnal','A2');
    
            % ------------------------------------------ Writes upsteram FM info
                        
            upstream_FM = get(handles.uitable_FM_UpStrm,'data');
            
            if ~strcmp(upstream_FM{2},'N/A')   % Unless Upstream Flow Meter is 'N/A'
                
                upstream_ind = cell2mat(upstream_FM(:,4));
                if any(upstream_ind)  % if the 4th column (logical) has 1
                    xlswrite(fullfile(PathExcel,filename_excel),{'upstream FM','Avg GWI'},'Diurnal','I1');
                    
                    upstream_data = cell2mat(upstream_FM(upstream_ind,2:3));  % column data except 1st and the logical column (4th)
                    xlswrite(fullfile(PathExcel,filename_excel),upstream_data,'Diurnal','I2');
                    
                    % adjusted Avg GWI for the selected meter
                    adjusted_GWI = {'Adj GWI',handles.DW.AverageBaseGWI - sum(upstream_data(:,2)),'MGD'};
                    xlswrite(fullfile(PathExcel,filename_excel),adjusted_GWI,'Diurnal','E4');
                    
                    
                end
            end
                
    
    
    % ------------------------------------------ Writes R-factor information
    % write header
    xlswrite(fullfile(PathExcel,filename_excel),{'Storm'},'R-factor','A1');
    xlswrite(fullfile(PathExcel,filename_excel),StormRind,'R-factor','A2');
    
    xlswrite(fullfile(PathExcel,filename_excel),col_name(1:end-1)','R-factor','B1');
    
    % write data
    xlswrite(fullfile(PathExcel,filename_excel),stats_selected(:,1:end-1),'R-factor','B2'); % remove the last column; logical variables
    
    xlswrite(fullfile(PathExcel,filename_excel),col_name_Rfactor(2:end)','R-factor','I1');
    xlswrite(fullfile(PathExcel,filename_excel),Rfactor_stats(:,2:end),'R-factor','I2');

end

% delete default worksheets (Sheet1, Sheet2 & Sheet3)
if ispc
    delete_default_excel_worksheet(fullfile(PathExcel,filename_excel))
end

% ---------------------------------------------- 
% ---------------------------------------------- EXPORT FIGURES
% ---------------------------------------------- 

stats = get(handles.uitable_StormID, 'Data');
ind_storms = cell2mat(stats(:,8));

if ~any(ind_storms)   % if non selected from the table
    errordlg('No Storm Selected')
else
    sel_storms = find(ind_storms~=0);
    save_loc = uigetdir('..\','Select location for figures');
   
    for k = 1:length(sel_storms)
        fig_storm_start = stats{sel_storms(k),1};
        
        handles.StormNum = sel_storms(k);
        
        % update figure
        fun_plot_RDI_GUI(handles)
        % plot each data NEW
        % and capture them.
        
        FigRain = figure('Name','test','position',[1300 100 720 520],'visible','off');
        axesRainCopy = copyobj(handles.axes_Rain,FigRain);
        set(FigRain,'renderer','zbuffer')
        axesFMCopy = copyobj(handles.axes_RDII,FigRain);
        
        fig_name = sprintf('%s_%s',handles.InputSetup.st_num,datestr(fig_storm_start,'yyyy-mm-dd_HHMM'));
        print(FigRain,'-dpng',fullfile(save_loc,fig_name))
        close(FigRain)

    end
    
    
    
    
end


function delete_default_excel_worksheet(XL_file,worksheet)
% This example operates on an Excel file called test.xls in the
% current directory. The test.xls file has 3 worksheets by default. This file can be 
% created by creating a new Excel file via Microsoft Excel and saving it as test.xls.
% 
% The original sample file is [delete_Excel_worksheets.m] in MATLAB Path.

if nargin < 2
    worksheet = 1:3; % indicating Sheet1 ~ Sheet3: default three worksheets
end
% Get information returned by XLSINFO on the workbook
% XL_file = fullfile(pwd, excel_file);
[~, sheet_names] = xlsfinfo(XL_file);

% First open Excel as a COM Automation server
Excel = actxserver('Excel.Application'); 

% Make the application invisible
set(Excel, 'Visible', 0);

% Make excel not display alerts
set(Excel,'DisplayAlerts',0);

% Get a handle to Excel's Workbooks
Workbooks = Excel.Workbooks; 

% Open an Excel Workbook and activate it
Workbook=Workbooks.Open(XL_file);

% Get the sheets in the active Workbook
Sheets = Excel.ActiveWorkBook.Sheets;

for i = 1:length(worksheet)
    if strcmp(sheet_names{i},sprintf('Sheet%d',i))
        current_sheet = get(Sheets, 'Item', 1); % remaining sheet always become the 'first' sheet
        invoke(current_sheet, 'Delete')
    end
end

% Now save the workbook
Workbook.Save;

% Close the workbook
Workbooks.Close;

% Quit Excel
invoke(Excel, 'Quit');

% Delete the handle to the ActiveX Object
delete(Excel);


% --------------------------------------------------------------------
function uitoggletool_Pan_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool_Pan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

linkaxes([handles.axes_RDII handles.axes_Rain],'x');


% --- Executes on button press in pushbutton_StormID_reload.
function pushbutton_StormID_reload_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_StormID_reload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global RG FM DW StormID StormInfo stats BaseSanitaryFlow

if isfield(handles,'ResponsePeriod')
    handles = rmfield(handles,'ResponsePeriod');
end

ResetTablesFigures(handles);


prev_export_str = sprintf('export\\*%s*.xlsx',handles.InputSetup.st_num);
[export_name, export_path, filter_index]=uigetfile(prev_export_str,'Select Previous Export file to read...');
export_name_path = fullfile(export_path,export_name);

if filter_index ~= 0  % if previous results exist
    
    % ---- read previous parameters
    prev_param = xlsread(export_name_path,'Parameters','B5:B10');
    curr_param = [handles.InputSetup.GUI_storm_duration; handles.InputSetup.GUI_inter_event; ...
        handles.InputSetup.GUI_storm_volume; handles.InputSetup.GUI_iInterfaceDaysSinceRain; ...
        handles.InputSetup.GUI_estBaseGWI; handles.InputSetup.GUI_Area];
    
    if ~all(prev_param == curr_param)  % if not identical parameters
        
        % ---- open Warning message -----
        user_response = Storm_ID_GUI_modal('Title','Warning !');
        
        switch user_response
            case 'Re-select'   % Re-select another export
                warndlg('Please use ''Reload'' button')
                
                
            case 'Start NEW'
                pushbutton_StormID_Callback(hObject, eventdata, handles)
                         
        end
        
    else    % identical parameters
    
    % #### ----- Read the Storm ID results from previous excel results and show
    pushbutton_StormID_Callback(hObject, eventdata, handles)
    
    handles.RG = RG;
    handles.FM = FM;
    handles.DW = DW;
    handles.StormID = StormID;
    handles.StormInfo = StormInfo;
    handles.table1_stats = stats;
    handles.BSF = BaseSanitaryFlow;
    
%     [num,txt,raw] = Read_Previous_session(export_name_path,hObject, eventdata, handles);
    handles = Read_Previous_session(export_name_path,hObject, eventdata, handles);
    
    end
    
else   % if no previous export exists
    
    warndlg('Canceled or No file found. Please click ''NEW'' to process')
    
    
end
guidata(hObject, handles);

% function [num,txt,raw] = Read_Previous_session(file,hObject, eventdata, handles)
function handles = Read_Previous_session(file,hObject, eventdata, handles)




% -- read OLD parameters
prev_param = xlsread(file,'Parameters','B5:B10');
%    read R-factor tab
[num,txt,raw] = xlsread(file,'R-factor');

% -- read ALL storm from UI table
exist_table1 = get(handles.uitable_StormID,'data');
update_table = exist_table1;
update_table(:,3) = {''};  % Start with No response


prev_storm_num = num(:,1);
new_storm = txt(2:end,2:4);  % Only the date string part of the table

for i = 1:numel(new_storm)
    if ~isempty(new_storm{i})
        new_storm{i} = datestr(new_storm{i},'mm/dd/yyyy HH:MM');
        
    end
end

% -- update the storm DATES
update_table(prev_storm_num,1:3) = new_storm;

% -- update the logical column & Response End
% tResponseEnd_old(1:length(prev_storm_num)) = nan;

% -- update Response Period in [handles] for plotting
if ~isfield(handles,'ResponsePeriod')
    handles.ResponsePeriod{size(exist_table1,1)} = [];
end

for j = 1:length(prev_storm_num)
    % update logical column
    update_table{prev_storm_num(j),end} = true;  
    
    % update ResponsePeriod for plotting
    if ~isempty(new_storm{j,3})
        handles.ResponsePeriod{prev_storm_num(j)} = [datenum(new_storm{j,1}) datenum(new_storm{j,3})];
    end
    
end

prev_Table1_info = num2cell(num(:,5:8)); % column 5~8 from Table 1 of GUI: GWI, Total Volume, Storm Vol, Total Rain
update_table(prev_storm_num,4:7) = prev_Table1_info;  % UPDATE existing (OLD) table

set(handles.uitable_StormID, 'Data', update_table);


% handles.ResponsePeriod{                
                
                

%{
1. update Storm ID table
  a.  Run storm ID first with OLD parameter set
  b.  Update table with the excel import (OLD storm selections)
  c.  



%}

% 1-a. Run storm ID



% 2) update R-factor table 
for k = 1:length(prev_storm_num)
    prev_RfactorTable{k,1} = prev_storm_num(k);
    prev_RfactorTable{k,2} = num(k,7);  % StormVolume
    prev_RfactorTable{k,3} = num(k,10);  % area
    prev_RfactorTable{k,4} = num(k,11);  % Rainfall
    prev_RfactorTable{k,5} = num(k,12);   % from direct excel reading
    prev_RfactorTable{k,6} = num(k,13);   % return ratio
end

set(handles.uitable_Rfactor, 'Data', prev_RfactorTable);


% 3) diurnal pattern plot - done


% 4) update scatter plot

scatter(handles.axes_Rfactor,cell2mat(prev_RfactorTable(:,2)),cell2mat(prev_RfactorTable(:,4)),'square','filled')
ylabel(handles.axes_Rfactor,'Rainfall (MG)')
xlabel(handles.axes_Rfactor,'RDI/I Volume (MG)')
title(handles.axes_Rfactor,sprintf('RDI/I Separation: Avg R %.2f%%',mean(cell2mat(prev_RfactorTable(:,6)))))
grid(handles.axes_Rfactor,'on')
ylim_Rfactor = get(handles.axes_Rfactor,'ylim');
set(handles.axes_Rfactor,'ylim',[0 ylim_Rfactor(2)])



guidata(hObject, handles);


% --- Executes on button press in pushbutton_export_fig.
function pushbutton_export_fig_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_export_fig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

stats = get(handles.uitable_StormID, 'Data');
ind_storms = cell2mat(stats(:,8));

if ~any(ind_storms)   % if non selected from the table
    errordlg('No Storm Selected')
else
    sel_storms = find(ind_storms~=0);
    save_loc = uigetdir('..\','Select location for figures');
   
    for k = 1:length(sel_storms)
        fig_storm_start = stats{sel_storms(k),1};
        
        handles.StormNum = sel_storms(k);
        
        % update figure
        fun_plot_RDI_GUI(handles)
        % plot each data NEW
        % and capture them.
        
        FigRain = figure('Name','test','position',[1300 100 720 520],'visible','off');
        axesRainCopy = copyobj(handles.axes_Rain,FigRain);
        set(FigRain,'renderer','zbuffer')
        axesFMCopy = copyobj(handles.axes_RDII,FigRain);
        
        fig_name = sprintf('%s_%s',handles.InputSetup.st_num,datestr(fig_storm_start,'yyyy-mm-dd_HHMM'));
        print(FigRain,'-dpng',fullfile(save_loc,fig_name))
        close(FigRain)

    end
    
    
    
    
end