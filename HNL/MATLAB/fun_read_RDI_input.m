function Input = fun_read_RDI_input(FileName,PathName)
%% Read input file
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
    
end
