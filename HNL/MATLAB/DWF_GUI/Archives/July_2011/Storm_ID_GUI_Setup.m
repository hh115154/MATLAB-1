function varargout = Storm_ID_GUI_Setup(varargin)
% STORM_ID_GUI_SETUP MATLAB code for Storm_ID_GUI_Setup.fig
%      STORM_ID_GUI_SETUP, by itself, creates a new STORM_ID_GUI_SETUP or raises the existing
%      singleton*.
%
%      H = STORM_ID_GUI_SETUP returns the handle to a new STORM_ID_GUI_SETUP or the handle to
%      the existing singleton*.
%
%      STORM_ID_GUI_SETUP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STORM_ID_GUI_SETUP.M with the given input arguments.
%
%      STORM_ID_GUI_SETUP('Property','Value',...) creates a new STORM_ID_GUI_SETUP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Storm_ID_GUI_Setup_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Storm_ID_GUI_Setup_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Storm_ID_GUI_Setup

% Last Modified by GUIDE v2.5 24-Mar-2011 17:01:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Storm_ID_GUI_Setup_OpeningFcn, ...
                   'gui_OutputFcn',  @Storm_ID_GUI_Setup_OutputFcn, ...
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


% --- Executes just before Storm_ID_GUI_Setup is made visible.
function Storm_ID_GUI_Setup_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Storm_ID_GUI_Setup (see VARARGIN)

% Choose default command line output for Storm_ID_GUI_Setup
handles.output = hObject;

mainGuiInput = find(strcmp(varargin, 'Storm_ID_GUI_Main'));

% THIS IS WHERE IT OPNES THE MAIN GUI INDEPENDENTLY  :: FIX THIS!!!!
% ---------------------------------------------------------
% handles.MainGUI = Storm_ID_GUI_Main;  % stores handles of Main GUI
handles.MainGUI = varargin{mainGuiInput+1};

% mainHandles = guidata(handles.MainGUI);

% get main GUI position
% MainGUIPosition = get(mainHandles.figure_setup,'Position');
MainGUIPosition = getpixelposition(handles.MainGUI);
% get sub GUI position
SubGUIPosition = get(hObject,'Position');
% disp('original')
% disp(SubGUIPosition)

SubGUIPosition = [MainGUIPosition(1), MainGUIPosition(2), SubGUIPosition(3), ...
    SubGUIPosition(4)];
% SubGUIPosition = [0, 30, SubGUIPosition(3), SubGUIPosition(4)];
% disp('Main')
% disp(MainGUIPosition)
% disp('new')
% disp(SubGUIPosition)

set(hObject,'Position',SubGUIPosition);

% disp('new2')
% disp(get(hObject,'Position'))

handles.reset.edit_MinStormDur      = get(handles.edit_MinStormDur,'String');
handles.reset.edit_MinInterEventDur = get(handles.edit_MinInterEventDur,'String');
handles.reset.edit_MinStormVol      = get(handles.edit_MinStormVol,'String');
handles.reset.edit_NoPreDryDays     = get(handles.edit_NoPreDryDays,'String');
handles.reset.edit_estBaseGWI       = get(handles.edit_estBaseGWI,'String');
handles.reset.edit_TributaryArea    = get(handles.edit_TributaryArea,'String');

set(handles.uipanel6_buttongroup,'SelectionChangeFcn',@uipanel6_buttongroup_SelectionChangeFcn);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Storm_ID_GUI_Setup wait for user response (see UIRESUME)
% uiwait(handles.figure_setup);


% --- Outputs from this function are returned to the command line.
function varargout = Storm_ID_GUI_Setup_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_MinStormDur_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinStormDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinStormDur as text
%        str2double(get(hObject,'String')) returns contents of edit_MinStormDur as a double


% --- Executes during object creation, after setting all properties.
function edit_MinStormDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinStormDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MinInterEventDur_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinInterEventDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinInterEventDur as text
%        str2double(get(hObject,'String')) returns contents of edit_MinInterEventDur as a double


% --- Executes during object creation, after setting all properties.
function edit_MinInterEventDur_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinInterEventDur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_MinStormVol_Callback(hObject, eventdata, handles)
% hObject    handle to edit_MinStormVol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_MinStormVol as text
%        str2double(get(hObject,'String')) returns contents of edit_MinStormVol as a double


% --- Executes during object creation, after setting all properties.
function edit_MinStormVol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_MinStormVol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_NoPreDryDays_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NoPreDryDays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NoPreDryDays as text
%        str2double(get(hObject,'String')) returns contents of edit_NoPreDryDays as a double


% --- Executes during object creation, after setting all properties.
function edit_NoPreDryDays_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NoPreDryDays (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_TributaryArea_Callback(hObject, eventdata, handles)
% hObject    handle to edit_TributaryArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_TributaryArea as text
%        str2double(get(hObject,'String')) returns contents of edit_TributaryArea as a double


% --- Executes during object creation, after setting all properties.
function edit_TributaryArea_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_TributaryArea (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_reset.
function pushbutton_reset_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.edit_MinStormDur,'String',handles.reset.edit_MinStormDur);
set(handles.edit_MinInterEventDur,'String',handles.reset.edit_MinInterEventDur);
set(handles.edit_MinStormVol,'String',handles.reset.edit_MinStormVol);
set(handles.edit_NoPreDryDays,'String',handles.reset.edit_NoPreDryDays);
set(handles.edit_estBaseGWI,'String',handles.reset.edit_estBaseGWI);
set(handles.edit_TributaryArea,'String',handles.reset.edit_TributaryArea);


% --- Executes on button press in pushbutton_Input.
function pushbutton_Input_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% % get the main GUI handle
% MainGUIhandles = Storm_ID_GUI_Main;

% get the data from Main handle
main = handles.MainGUI;

if ishandle(main)
    mainHandles = guidata(handles.MainGUI);
end
handles.Input.GUI_storm_duration = str2num(get(handles.edit_MinStormDur,'String'));
handles.Input.GUI_inter_event = str2num(get(handles.edit_MinInterEventDur,'String'));
handles.Input.GUI_storm_volume = str2num(get(handles.edit_MinStormVol,'String'));
handles.Input.GUI_iInterfaceDaysSinceRain = str2num(get(handles.edit_NoPreDryDays,'String'));
handles.Input.GUI_estBaseGWI = str2num(get(handles.edit_estBaseGWI,'String'));
handles.Input.GUI_Area = str2num(get(handles.edit_TributaryArea,'String'));

% define the BSF period upon pressing 'update' button
period_ind = [get(handles.radiobutton_BSF1,'value') get(handles.radiobutton_BSF2,'value') ...
    get(handles.radiobutton_BSF3,'value')];
period_sel = find(period_ind);  % find which period is selected
switch period_sel
    case 1
        set(handles.edit_BSF_start,'String','All')
        set(handles.edit_BSF_end,'String','All')
        
    case 2
        set(handles.edit_BSF_start,'String',datestr([2010 7 1 0 0 0]))
        set(handles.edit_BSF_end,'String',datestr([2010 10 1 0 0 0]))
        
    otherwise
%         set(handles.edit_BSF_start,'String',datestr([2010 12 31 0 0 0],'mm-dd-yyyy'))
%         set(handles.edit_BSF_end,'String',datestr([2011 5 30 0 0 0],'mm-dd-yyyy'))

end

% custom period for BSF



handles.Input.BSF_period = {get(handles.edit_BSF_start,'String')  get(handles.edit_BSF_end,'String')};

% disp(datestr(get(handles.edit_BSF_start,'String')))
% disp(datestr(get(handles.edit_BSF_end,'String')))
% This [mainHandles] is [handles] in main GUI!
% main GUI's handles is automatically updated by these lines below.
% mainHandles.test = 'sjb';
mainHandles.InputSetup = handles.Input;

% test change Main Window Value
% save back to Main GUI
guidata(Storm_ID_GUI_Main, mainHandles);

if isempty(handles.Input.GUI_Area)
    errordlg('Area not defined')
end

guidata(hObject, handles);




% --- Executes on button press in pushbutton_SelectData.
function pushbutton_SelectData_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_SelectData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mainHandles = guidata(handles.MainGUI);

% reset the table in Main GUI
set(mainHandles.uitable_FM_UpStrm, 'Data', mainHandles.EmptyTable3);

handles.Input = Select_Data_File;

% update filename in Main GUI
set(mainHandles.FileLocation,'String',[handles.Input.PathName handles.Input.FileNameDATA]);

% show upstream info

show_upstream_info = false;

if show_upstream_info
    
    
    
    % ---- Read Flow Meters schematic excel sheet
    small_areas = {'Paalaa kai','Kahuku','Waimanalo'};
    
    if any(strcmp(small_areas,handles.Input.st_name))
        sewershed_name = 'PK,KH,WM';
    else
        sewershed_name = handles.Input.st_name;
    end
    
    FM_selected = handles.Input.st_num;
    
    FM_schematic_file = '..\Flow_Meter_Schematics.xlsx';
    
    if exist(FM_schematic_file,'file') ~= 0  % if exist
        [FM_all,~,~] = xlsread(FM_schematic_file,sewershed_name);
    else
        
        % if not exist in the default location, have a user select the file
        
        [FM_schematic_file, FM_schematic_path]=uigetfile('*.xlsx','Select the Flow meter schematic info file ...');
        [FM_all,~,~] = xlsread(fullfile(FM_schematic_path,FM_schematic_file),sewershed_name);
    end
    
    
    FM_selected_id = find(FM_all(:,1) == str2double(FM_selected));  % find the row from the list
    upstream_FM_row = FM_all(FM_selected_id,2:end);
    
    if ~all(isnan(upstream_FM_row))  % if any upstream FM exist
        [~,~,upstream_FM_num]=find(upstream_FM_row(~isnan(upstream_FM_row)));  % find upstream meter numbers
        
        % ------ update upstream info in Main GUI window
        upstrm_FM = get(mainHandles.uitable_FM_UpStrm,'Data');
        
        upstrm_FM{1,1} = str2double(FM_selected);
        for q = 1:length(upstream_FM_num)
            upstrm_FM{q,2} = upstream_FM_num(q);  % update upstream FM table
            
            S = dir(sprintf('export\\*%d*.xlsx',upstream_FM_num(q))); % find the existing excel file
            
            if ~isempty(S)
                cd('export')
                export_excel_file = S(length(S)).name;
                [num,~,~]=xlsread(export_excel_file,'Diurnal','F1:F2'); % F1 or num(1): AvgGWI, F2 or num(2): AvgDSF
                cd('..')
                upstrm_FM{q,3} = num(q);
                upstrm_FM{q,4} = false;
            end
        end
        
        % ------ find the output excel files from the upstream meters
        % ****** use dir and choose the most recently created output excel
        
        
        %     export_excel_file = 'export/Table_BDSF_Storm_Honouliuli_491227_Mar07_1454.xlsx';
        %     [num,~,~]=xlsread(export_excel_file,'Diurnal','F1:F2'); % F1: AvgGWI, F2: AvgDSF
        
    else
        upstrm_FM{1,1} = FM_selected;
        upstrm_FM{1,2} = 'N/A';
        
        
        
    end
    
    set(mainHandles.uitable_FM_UpStrm,'Data',upstrm_FM);
end

% update Sewershed name and Flow meter number in Sub GUI
set(handles.edit_meter_name,'String',[handles.Input.st_name ' -- ' handles.Input.st_num]);

guidata(hObject, handles);


function edit_estBaseGWI_Callback(hObject, eventdata, handles)
% hObject    handle to edit_estBaseGWI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_estBaseGWI as text
%        str2double(get(hObject,'String')) returns contents of edit_estBaseGWI as a double


% --- Executes during object creation, after setting all properties.
function edit_estBaseGWI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_estBaseGWI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Input = Select_Data_File
[FileNameDATA,PathName] = uigetfile( ...
    {'*.csv',  'comma separated variables (*.csv)'; ...
    '*.xlsx','Excel file (*.xlsx)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Pick a DATA file');
cd(PathName)

if ispc
    st_nameId = regexp(PathName, '\\', 'split');
    Input.st_name = st_nameId{end-1};
    
    st_numId = regexp(FileNameDATA,' ','split');
    Input.st_num = st_numId{1};  % str variable
else
    st_nameId = regexp(PathName, '/', 'split');
    Input.st_name = st_nameId{end-1};
    
    st_numId = regexp(FileNameDATA,' ','split');
    Input.st_num = st_numId{1};  % str variable
end


% set(handles.FileLocation,'string',[pwd '\' FileNameDATA]);  % 'Edit Text' object

Input.PathName = PathName;
Input.FileNameDATA = FileNameDATA;



function edit_meter_name_Callback(hObject, eventdata, handles)
% hObject    handle to edit_meter_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_meter_name as text
%        str2double(get(hObject,'String')) returns contents of edit_meter_name as a double


% --- Executes during object creation, after setting all properties.
function edit_meter_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_meter_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BSF_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BSF_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BSF_start as text
%        str2double(get(hObject,'String')) returns contents of edit_BSF_start as a double


BSF_start = get(hObject,'String');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit_BSF_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BSF_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_BSF_end_Callback(hObject, eventdata, handles)
% hObject    handle to edit_BSF_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_BSF_end as text
%        str2double(get(hObject,'String')) returns contents of edit_BSF_end as a double


% --- Executes during object creation, after setting all properties.
function edit_BSF_end_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_BSF_end (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function uipanel6_buttongroup_SelectionChangeFcn(hObject,eventdata, handles)

handles = guidata(hObject);
switch get(eventdata.NewValue,'Tag') % Get Tag of selected object.
    case 'radiobutton_BSF1'
        disp('All data selected for BSF')
        
        % turn off custom field
        set(handles.edit_BSF_start,'visible','off')
        set(handles.text_tilde,'visible','off')
        set(handles.edit_BSF_end,'visible','off')
        
        % for the whole data period used
        % Code for when radiobutton1 is selected.
    case 'radiobutton_BSF2'
        disp('Summer 2010 selected for BSF')
        
        % turn off custom field
        set(handles.edit_BSF_start,'visible','off')
        set(handles.text_tilde,'visible','off')
        set(handles.edit_BSF_end,'visible','off')
        
        % Code for when radiobutton2 is selected.
        
    case 'radiobutton_BSF3'
        disp('User defined data period selected for BSF')

        set(handles.edit_BSF_start,'visible','on')
        set(handles.text_tilde,'visible','on')
        set(handles.edit_BSF_end,'visible','on')
        
        set(handles.edit_BSF_start,'String',datestr([2010 5 1 0 0 0],'mm-dd-yyyy'))
        set(handles.edit_BSF_end,'String',datestr([2010 10 31 0 0 0],'mm-dd-yyyy'))

        %
        %         disp(get(handles.edit_BSF_start,'String'))
        %         disp(get(handles.edit_BSF_end,'String'))
        % Continue with more cases as necessary.
    otherwise
        % Code for when there is no match.
end


% --------------------------------------------------------------------
function uipanel6_buttongroup_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to uipanel6_buttongroup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
disp('work?')
