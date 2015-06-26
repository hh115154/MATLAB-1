function Plot_Wetted_Area_allWY_GateClose(WY,alt_type)
close all
% if isempty(nargin)
%     WY = 2007;
% end
% wetted area time series
% 4/18/2014, sjb

HDD_loc = {'i','j'};
if WY <=2004
    HDD = HDD_loc{1};
else
    HDD = HDD_loc{2};
end

%% paths
% ---- tributary flows
fpath_WT = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\bc dbase\years';
% ---- PO file (Exg)
fpath_PO = sprintf('\\\\Cbecm11\\%s\\Work\\Projects\\13-1027_YBM\\LT_Model\\TUFLOW\\results',HDD);
fpath_Area = ...
    sprintf('\\\\Cbecm11\\i\\Work\\Projects\\13-1027_YBM\\LT_Model\\TUFLOW\\results\\Post_Processed_2014\\AgEcon\\%d\\Results',WY);


%% Water Year selection
% cd('C:\Work\13-1027_Yolo\LT model\G_drive')
cd('G:\')
% WY = 2007;

% D = dir(pwd);
%% setup figure size
PaperW = 10;
PaperH = 6;
fig_position = [1 4 PaperW PaperH];
paper_position = [0 0 PaperW PaperH]; % controls paper margin
orientation = 'landscape';

h_fig = figure('PaperUnits','inches', ...
    'PaperPosition',paper_position, ...
    'Units','inches','Position',fig_position, ...
    'PaperOrientation',orientation);

% axes1 = axes('Parent',h_fig,'Visible','off','units','normalized','Position',[0 0 1 1]);
s1 = axes('Parent',h_fig,'Visible','on','units','normalized','position',[0.08 0.7 .9 .25]);
s2 = axes('Parent',h_fig,'Visible','on','units','normalized','position',[0.08 0.11 .9 .55]);

%% Read data
% for i = 1:length(D)
%     if ~isempty(strfind(D(i).name,'.'))  % excludes ./.. and files
%         continue
%     end
% end


%% path name - file name

%% Wet area tabulation 
path_exist = sprintf('Existing Conditions Results\\Ag Econ\\%d\\Results',WY);
file_exist = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_Exg.csv',WY);

% path_alt = sprintf('%s01 Alternative Results\\Ag Econ\\%d\\Results',alt_type,WY);
% file_alt =  sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_%s01.csv',alt_type,WY);

[hour_select, ts, wetA_exist] = read_wetted_table(fullfile(path_exist,file_exist));
% [~          ,  ~, wetA_alt]   = read_wetted_table(fullfile(path_alt,file_alt));


TS_start = hour_select(1);
TS_end = hour_select(end);




% TS: Area time series   ----- alternatives

% AD = dir(fullfile(fpath_Area,'*.csv'));
fpath_Area = path_alt;
AD = dir(fullfile(fpath_Area,'*.csv'));

% AreaAcre{1,length(AD)} = [];
for k = 1:length(AD)
    if ~isempty(strfind(AD(k).name,'Exg.'))  % existing condition
        [TS_Ex, Area_Ex] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01.',alt_type))) 
        [TS_0430, Area_0430] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Feb15.',alt_type)))  
        [TS_0215, Area_0215] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Mar1.',alt_type)))  
        [TS_0301, Area_0301] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Mar15.',alt_type))) 
        [TS_0315, Area_0315] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    elseif ~isempty(strfind(AD(k).name,sprintf('%s01_Apr1.',alt_type)))  
        [TS_0401, Area_0401] = Read_AREA_csv(fullfile(fpath_Area,AD(k).name));
    else
        continue
    end
end
    
% in case exist data length is different (when longer)
wetA_exist = wetA_exist(1:length(Area_0430));











%% Tributary Flows
fname_WT = sprintf('%d_hourly.csv',WY);
fidwt = fopen(fullfile(fpath_WT,fname_WT));
trib_data = textscan(fidwt,'%f%*f%f%f%*f%*f%*f%*f%*f%*f%f%*f%*f%f%*f%*f%*f%*f%f%*f%*f%*f%*f', ...
    'delimiter',',','headerlines',1);
fclose(fidwt);

TS_trib = trib_data{1};
TS_ind = find(TS_trib>=TS_start & TS_trib<=TS_end);
TS_tribWY = TS_trib(TS_ind);
% Data_trib = trib_data{2}(TS_trib>=TS_start & TS_trib<=TS_end);

dTS_trib = TS_tribWY - TS_tribWY(1);
TS_trib_time = addtodate(datenum([1996 10 2 0 0 0]),TS_tribWY(1),'hour') + dTS_trib./24;




%% -------------------------- Fremont Weir

% --------------------------------------------------------------------
%                                        ------ existing
% fpath_PO = '..\..';
fname_PO = sprintf('yolo_200ft_Exg_TS6_____%d_PO.csv',WY);
fpath = sprintf('%s\\%d',fpath_PO,WY);

fidPO = fopen(fullfile(fpath,fname_PO));
readfmt = ['%*s%f' repmat('%*f',1,23) '%f%*f%f%*f%*f%f'];
PO_Model_data = textscan(fidPO,readfmt,'delimiter',',','headerlines',2);
fclose(fidPO);

TS_PO_hr = PO_Model_data{1};
TS_PO = TS_PO_hr(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);

% Data_FreWSE_w = PO_Model_data{2}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
% Data_FreWSE_e = PO_Model_data{3}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);
Data_FreQ = PO_Model_data{4}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);

dTS_PO = TS_PO - TS_PO(1);   % time(hour) differences from the 1st entry

% in real time (datenum)
TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),TS_PO(1),'hour') + dTS_PO./24;



% --------------------------------------------------------------------
%                                        ------ alternative
fname_PO_FreSim_alt = sprintf('yolo_200ft_%s01_TS6_____%d_PO.csv',alt_type,model_year);

fidPO_FreSim_alt = fopen(fullfile(fpath,fname_PO_FreSim_alt));
readfmt = ['%*s%f' repmat('%*f',1,23) '%f%*f%f%*f%*f%f'];
PO_Model_data_ALT = textscan(fidPO_FreSim_alt,readfmt,'delimiter',',','headerlines',2);
fclose(fidPO_FreSim_alt);

Data_FreQ_alt = PO_Model_data_ALT{4}(TS_PO_hr>=TS_start & TS_PO_hr<=TS_end);







%% -------------------------- tributary
Trib_int = cell2mat(trib_data);
Trib_Sum = sum(Trib_int(:,2:end),2);






%% -------------------------- Gate flows

GateSm  = read_Gate_flow('FreSm',WY);
GateMed = read_Gate_flow('FreMed',WY);
GateLg  = read_Gate_flow('FreLg',WY);
GateSacW = read_Gate_flow('SacW',WY);


% fname_1D_Q = sprintf('yolo_200ft_%s01_TS6_____%d_1d_Q.csv',alt_type,WY);
% fname_1D_h = sprintf('yolo_200ft_%s01_TS6_____%d_1d_H.csv',alt_type,WY);






% -----------------------------------------  upper panel

plot(s1,TS_PO_time,Data_FreQ_alt,'k')
hold(s1,'on')
plot(s1,TS_trib_time,Trib_Sum(TS_ind),'k:')

plot(s1,TS_PO_time(1:6:end),GateSm,'r')
plot(s1,TS_PO_time(1:6:end),GateMed,'g')
plot(s1,TS_PO_time(1:6:end),GateLg,'b')
plot(s1,TS_PO_time(1:6:end),GateSacW,'m')
grid(s1,'on')
legend(s1,{'Fremont Weir','Westside Trib (sum all)','Gate FreSm', ...
    'Gate FreMed','Gate FreLrg','Gate SacW'},'location','northwest')



datetick(s1,'x','mmm','keeplimits')

set(s1,'xticklabel',[])
ylabel(s1,'Flow (cfs)')

% -----------------------------------------  lower panel
plot(s2,TS_Ex,Area_Ex,2)
hold(s2,'on')
plot(s2,TS_0215,Area_0215,'r')
plot(s2,TS_0301,Area_0301,'y')
plot(s2,TS_0315,Area_0315,'g')
plot(s2,TS_0401,Area_0401,'b')
plot(s2,TS_0430,Area_0430,'color',[255 0 127]./255)

grid(s2,'on')
legend(s2,{'Existing','Close 2/15','Close 3/1','Close 3/15','Close 4/1','Close 4/30'}, ...
    'location','northwest')
datetick(s2,'x','mmm','keeplimits')
xlabel(s2,sprintf('WY %d, %s',WY,alt_type))
ylabel(s2,'Wetted Area (Acres)')


xlabel_limit = [datenum([WY-1 10 1]) datenum([WY 6 1])];
set(s1,'xlim',xlabel_limit)
set(s2,'xlim',xlabel_limit)

figure_name = sprintf('WettedArea_WY_and_Q_%s_Gate_%d',alt_type,WY);
export_fig(figure_name,'-pdf','-nocrop','-transparent','-append',h_fig)    
% export_fig('wetted_area_all_WY','-pdf','-nocrop','-transparent','-append',h_fig)    
   


function [hourly_stamps, date_plot, Acre_plot] = read_wetted_table(filen)
fid = fopen(filen);
WetArea = textscan(fid,'%f%s%f%f%f','delimiter',',','headerlines',1);

hourly_stamps = datenum(WetArea{1});
date_plot = datenum(WetArea{2});
Acre_plot = WetArea{end};

fclose(fid);

function Gate_totalQ = read_Gate_flow(alt_type,WY)
fpath_1D = ...
    sprintf('\\\\Cbecm11\\i\\Work\\Projects\\13-1027_YBM\\LT_Model\\TUFLOW\\results\\%d\\csv',WY);

% alt_type = {'FreSm';'FreMed';'FreLg';'SacW'}; % sample Alt type
fname_1D_Gate = sprintf('yolo_200ft_%s01_TS6_____%d_1d_O.csv',alt_type,WY);

% Gate Sim flows
fid_GQ  = fopen(fullfile(fpath_1D,fname_1D_Gate));

switch alt_type
    case 'FreSm'
        readfmtGQ = ['%*f%*f%*s%*f%*f%*f' '%f' '%*s%*f%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f' '%f' '%*[^\n]' ];
    case 'SacW'
        readfmtGQ = '%*f%*f%*s%*f%*f%*f%f%*[^\n]';
    otherwise
        readfmtGQ = ['%*f%*f%*s%*f%*f%*f' '%f' '%*s%*f' ...
            repmat('%*f%*f%*f%f%*s',1,5) '%*[^\n]' ];

end
            

GateQ  = textscan(fid_GQ,readfmtGQ,'delimiter',',','headerlines',1);

Gate_totalQ = sum(cell2mat(GateQ),2);

fclose(fid_GQ);

function [date_plot, AreaAcre] = Read_AREA_csv(fname_A)
fid = fopen(fname_A);
WetArea = textscan(fid,'%f%s%f%f%f','delimiter',',','headerlines',1);
% AreaData = WetArea;
fclose(fid);

date_number = datenum(WetArea{2});

date_diff = date_number - date_number(1); % each year's increment of date
% if ii == 1
Oct2_WY = datenum(WetArea{2}(1));
% end

date_plot = Oct2_WY + date_diff;

AreaAcre = WetArea{end};

        