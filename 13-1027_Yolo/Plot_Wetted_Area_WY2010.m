function Plot_Wetted_Area_WY2010(WY)
close all
% if isempty(nargin)
%     WY = 2007;
% end
% wetted area time series
% 4/18/2014, sjb


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
path_exist = sprintf('Existing Conditions Results\\Ag Econ\\%d\\Results',WY);
path_Lg    = sprintf('FreLg01 Alternative Results\\Ag Econ\\%d\\Results',WY);
path_Med   = sprintf('FreMed01 Alternative Results\\Ag Econ\\%d\\Results',WY);
% path_Sm    = sprintf('FreSm01 Alternative Results\\Ag Econ\\%d\\Results',WY);
path_SacW  = sprintf('SacW01 Alternative Results\\Ag Econ\\%d\\Results',WY);

file_exist = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_Exg.csv',WY);
file_Lg    = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_FreLg01.csv',WY);
file_Med   = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_FreMed01.csv',WY);
% file_Sm    = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_FreSm01.csv',WY);
file_SacW  = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_SacW01.csv',WY);

%% Plotting
[~, wetA_exist] = read_wetted_table(fullfile(path_exist,file_exist));
[~, wetA_Lg] = read_wetted_table(fullfile(path_Lg,file_Lg));
[~, wetA_Med] = read_wetted_table(fullfile(path_Med,file_Med));
% [ts, wetA_Sm] = read_wetted_table(fullfile(path_Sm,file_Sm));
[ts, wetA_SacW] = read_wetted_table(fullfile(path_SacW,file_SacW));

wetA_exist = wetA_exist(1:length(wetA_Lg));
% -----------------------------------------  upper panel
% plot(s1,ts,wetA_Sm-wetA_exist,'color','r')

plot(s1,ts,wetA_Med-wetA_exist,'color','g') %previous 'y'
hold(s1,'on')
plot(s1,ts,wetA_Lg-wetA_exist,'color','b') %previous 'b'
plot(s1,ts,wetA_SacW-wetA_exist,'color','m')

grid(s1,'on')
datetick(s1,'x','mmm','keeplimits')

set(s1,'xticklabel',[])
ylabel(s1,{'Wetted Area'; 'Difference (Acres)'})

% -----------------------------------------  lower panel
plot(s2,ts,wetA_exist,'color','k')
hold(s2,'on')
% plot(s2,ts,wetA_Sm,'color','r')
plot(s2,ts,wetA_Med,'color','g') %previous 'y'
plot(s2,ts,wetA_Lg,'color','b') %previous 'g'
plot(s2,ts,wetA_SacW,'color','m')

grid(s2,'on')
legend(s2,{'Existing','FreMed','FreLrg','SacW'},'location','northwest')
datetick(s2,'x','mmm','keeplimits')
xlabel(s2,sprintf('WY %d',WY))
ylabel(s2,'Wetted Area (Acres)')


xlabel_limit = [datenum([WY-1 10 1]) datenum([WY 6 1])];
set(s1,'xlim',xlabel_limit)
set(s2,'xlim',xlabel_limit)

figure_name = sprintf('WettedArea_WY%d',WY);
% export_fig(figure_name,'-png','-nocrop','-transparent','-append',h_fig)    
export_fig(figure_name,'-pdf','-nocrop','-transparent','-append',h_fig)    
% export_fig('wetted_area_all_WY','-pdf','-nocrop','-transparent','-append',h_fig)    
   


function [date_plot, Acre_plot] = read_wetted_table(filen)
fid = fopen(filen);
WetArea = textscan(fid,'%f%s%f%f%f','delimiter',',','headerlines',1);

date_plot = datenum(WetArea{2});
Acre_plot = WetArea{end};

fclose(fid);

    
    