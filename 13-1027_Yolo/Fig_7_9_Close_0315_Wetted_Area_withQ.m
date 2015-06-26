function Fig_7_9_Close_0315_Wetted_Area_withQ(WY)
close all
% if isempty(nargin)
%     WY = 2007;
% end
% wetted area time series
% 4/18/2014, sjb

HDD_loc = {'k','k'};
if WY <=2004
    HDD = HDD_loc{1};
else
    HDD = HDD_loc{2};
end

%% -------------------------------------------------- Gate close 4/1
file_name_mult = 2; % used in figure number sorting

font_size = 9;
font_name = 'Helvetica';
%% paths
% ---- tributary flows
fpath_WT = '\\CBECM11\e\Work\Projects\13-1027_YBM\LT Model\TUFLOW\bc dbase\years';
% ---- PO file (Exg)
% fpath_PO = sprintf('\\\\Cbecm11\\%s\\Work\\Projects\\13-1027_YBM\\LT_Model\\TUFLOW\\results',HDD);
fpath_PO = sprintf('\\\\Cbecm11\\%s\\Raw Results',HDD);
%% Water Year selection
% cd('C:\Work\13-1027_Yolo\LT model\G_drive')
cd('\\Cbecm11\k\Results - Post Processed')
% WY = 2007;

% D = dir(pwd);
%% setup figure size
% PaperW = 10;
% PaperH = 6;
% fig_position = [1 4 PaperW PaperH];
% paper_position = [0 0 PaperW PaperH]; % controls paper margin
% orientation = 'landscape';
% 
% h_fig = figure('PaperUnits','inches', ...
%     'PaperPosition',paper_position, ...
%     'Units','inches','Position',fig_position, ...
%     'PaperOrientation',orientation);

% axeh_axes1(1) = axes('Parent',h_fig,'Visible','off','units','normalized','Position',[0 0 1 1]);
% s1 = axes('Parent',h_fig,'Visible','on','units','normalized','position',[0.08 0.7 .9 .25]);
% s2 = axes('Parent',h_fig,'Visible','on','units','normalized','position',[0.08 0.11 .9 .55]);

%%

%% -------------------- template without text box (for MS WORD template paste)
%     bot_ax = 0.05;
%     top_ax = 0.03;
% %     rht_ax = 0.03;
%     rht_ax = 0.05;
% %     lft_ax = 0.07;
%     lft_ax = 0.12;
%     ax_width0 = 1-lft_ax-rht_ax;
%     ax_height0 = 1-top_ax-bot_ax;
%     
%     
%     sub_gap = 0.05;
%     ax_height1 = (ax_height0-sub_gap*2)/3;
%     ax_width1  = ax_width0;
%     
%     ax_height2 = ax_height1;
%     ax_width2  = ax_width0;
%     
% %     subplots = zeros(2,4);
%     subplots(3,1:4) = [lft_ax bot_ax+ax_height1*2+sub_gap*2 ax_width1 ax_height1];
%     subplots(2,1:4) = [lft_ax bot_ax+ax_height1+sub_gap ax_width1 ax_height1];
%     subplots(1,1:4) = [lft_ax bot_ax ax_width1 ax_height1];
%     
%     
lft_ax = 0.07;
bot_ax = 0.06;
subplots(2,1:4) = [lft_ax 0.65 .91-.05 .3];
subplots(1,1:4) = [lft_ax bot_ax .91-.05 .55];
orientation = 'landscape';  % 'landscape'/'portrait'
figure_type = 'Letter';    % 'Letter'/'Legal'

    
    [h_fig,h_axes1]=cbec_fig_NO_text(figure_type,orientation,subplots);







%% Read data
% for i = 1:length(D)
%     if ~isempty(strfind(D(i).name,'.'))  % excludes ./.. and files
%         continue
%     end
% end


%% path name - file name
% path_exist = sprintf('H:\\Existing Conditions Results\\Ag Econ\\%d\\Results',WY);
path_exist = sprintf('Ag Econ\\%d\\Results',WY);
path_Lg    = sprintf('Ag Econ\\%d\\Results',WY);
path_Med   = sprintf('Ag Econ\\%d\\Results',WY);
path_Sm    = sprintf('Ag Econ\\%d\\Results',WY);
path_SacW  = sprintf('Ag Econ\\%d\\Results',WY);

file_exist = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_Exg.csv',WY);
file_Lg    = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_FreLg01_Mar15.csv',WY);
file_Med   = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_FreMed01_Mar15.csv',WY);
file_Sm    = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_FreSm01_Mar15.csv',WY);
file_SacW  = sprintf('WetAreaTabulation_yolo_200ft_Exg_TS6_____%d_{NearBypass}_SacW01_Mar15.csv',WY);

[hour_select, ts_exist, wetA_exist] = read_wetted_table(fullfile(path_exist,file_exist));
[~,ts_Lg, wetA_Lg] = read_wetted_table(fullfile(path_Lg,file_Lg));
[~,ts_Med, wetA_Med] = read_wetted_table(fullfile(path_Med,file_Med));
[~,ts_Sm, wetA_Sm] = read_wetted_table(fullfile(path_Sm,file_Sm));
[~,ts_SacW, wetA_SacW] = read_wetted_table(fullfile(path_SacW,file_SacW));

% wetA_exist = wetA_exist(1:length(wetA_Sm));

TS_start = hour_select(1);
TS_end = hour_select(end);


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




%%
% -------------------------- Fremont Weir


% fpath_PO = '..\..';
fname_PO = sprintf('yolo_200ft_Exg_TS6_____%d_PO.csv',WY);
% if WY == 1997
%     fpath = sprintf('%s\\%da',fpath_PO,WY);
% else
    fpath = sprintf('%s\\%d',fpath_PO,WY);
% end

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

% -------------------------- tributary
Trib_int = cell2mat(trib_data);
Trib_Sum = sum(Trib_int(:,2:end),2);

% -------------------------- Gate flows

GateSm  = read_Gate_flow_scenario('FreSm',WY);
GateMed = read_Gate_flow_scenario('FreMed',WY);
GateLg  = read_Gate_flow_scenario('FreLg',WY);
GateSacW = read_Gate_flow_scenario('SacW',WY);


% fname_1D_Q = sprintf('yolo_200ft_%s01_TS6_____%d_1d_Q.csv',alt_type,WY);
% fname_1D_h = sprintf('yolo_200ft_%s01_TS6_____%d_1d_H.csv',alt_type,WY);



% -----------------------------------------  upper panel

set(gcf,'CurrentAxes',h_axes1(1))


% WY 2009, negative Trib_Sum is found. For now, we'll Nan those numbers
Trib_flow_total = Trib_Sum(TS_ind);
Trib_flow_total(Trib_flow_total<0) = NaN;
[AX,H1,H2] = plotyy(TS_PO_time,Data_FreQ,TS_trib_time,Trib_flow_total);

% Gate_ts = TS_PO_time(1:6:end);
% Gate_TS = Gate_ts(1:length(GateSm));

%axes(AX(2))  % this will fix the axis ranges (xlim, ylim)
set(gcf,'CurrentAxes',AX(2))
set(AX(2),'YLimMode','auto')
hold on
H3 = plot(AX(2),GateSm(:,1),GateSm(:,2),'r');
set(H1,'color','k')
set(H2,'color','k','linestyle',':')
set(AX,{'ycolor'},{'k';'k'})

H4 = plot(AX(2),GateMed(:,1),GateMed(:,2),'g');
H5 = plot(AX(2),GateLg(:,1),GateLg(:,2),'b');
H6 = plot(AX(2),GateSacW(:,1),GateSacW(:,2),'m');

for xn = 1:length(AX)
    set(AX(xn),'xlim',[datenum([WY-1 11 1]) datenum([WY 6 1])])
    set(AX(xn),'fontsize',font_size,'fontname',font_name)
    datetick(AX(xn),'x','mmm','keeplimits')
    set(AX(xn),'xticklabel',[]);
end

leg_s3 = legend([H1,H2,H3,H4,H5,H6], ...
    'Fremont Weir Existing','Westside Tribs','Gate FreSm', ...
    'Gate FreMed','Gate FreLg','Gate SacW','location','northwest');

y_lim = get(AX(1),'ylim');
y_lim2 = get(AX(2),'ylim');

y_tick = get(AX(1),'ytick');
y_tick2= get(AX(2),'ytick');

set(AX(2),'YLimMode','manual')

% ytick reconstruct
if length(y_tick2) <= 3
    if WY == 1998 && 2001
        new_tick_numbers = 6;
    else
        new_tick_numbers = 5;
    end
    
    new_y_tick1 = linspace(y_lim(1),y_lim(2),new_tick_numbers);
    new_y_tick2 = linspace(y_lim2(1),y_lim2(2),new_tick_numbers);
    
    set(AX(1),'ytick',new_y_tick1)
    set(AX(2),'ytick',new_y_tick2)
    
    if y_tick2(end)~=y_lim2(end)
        set(AX(2),'ytick',linspace(y_lim2(1),y_lim2(2),length(new_y_tick1)))
    end
    
elseif length(y_tick2) > 7
    new_tick_numbers = 5;
    new_y_tick1 = linspace(y_lim(1),y_lim(2),new_tick_numbers);
    new_y_tick2 = linspace(y_lim2(1),y_lim2(2),new_tick_numbers);
    
    set(AX(1),'ytick',new_y_tick1)
    set(AX(2),'ytick',new_y_tick2)
    
    if y_tick2(end)~=y_lim2(end)
        set(AX(2),'ytick',linspace(y_lim2(1),y_lim2(2),length(new_y_tick1)))
    end

else
    
    % this is necessary when tick is not equi-distant in y-direction (right y-axis)
    if y_tick2(end)~=y_lim2(end)
        set(AX(2),'ytick',linspace(y_lim2(1),y_lim2(2),length(y_tick2)))
    end
    
end



% plot(h_axes1(1),TS_PO_time,Data_FreQ,'k')
% hold(h_axes1(1),'on')
% plot(h_axes1(1),TS_trib_time,Trib_Sum(TS_ind),'k:')

% Gate_ts = TS_PO_time(1:6:end);
% Gate_TS = Gate_ts(1:length(GateSm));
% plot(h_axes1(1),Gate_TS,GateSm,'r')
% plot(h_axes1(1),Gate_TS,GateMed,'g')
% plot(h_axes1(1),Gate_TS,GateLg,'b')
% plot(h_axes1(1),Gate_TS,GateSacW,'m')
grid(h_axes1(1),'on')
% legend(h_axes1(1),{'Fremont Weir Existing','Westside Tribs','Gate FreSm', ...
%     'Gate FreMed','Gate FreLg','Gate SacW'},'location','northwest')

if any(Data_FreQ) == 0
    % l3 = line([cur_date cur_date],[y_lim2(1) y_lim2(2)],'color','k');
    set(AX(1),'ylim',y_lim2)
    set(AX(1),'ytick',get(AX(2),'ytick'))
    plot(AX(2),TS_PO_time,Data_FreQ)    % TO MAKE ZERO line visible
    % set(AX(1),'yticklabel',get(AX(2),'yticklabel'))
else
    y_lim_max = max(y_lim(2),y_lim2(2));
    % l3 = line([cur_date cur_date],[y_lim(1) y_lim_max],'color','k');
end


datetick(h_axes1(1),'x','mmm','keeplimits')

set(h_axes1(1),'xticklabel',[])

% -----------------------------------------  lower panel
plot(h_axes1(2),ts_exist,wetA_exist,'color','k')
hold(h_axes1(2),'on')
plot(h_axes1(2),ts_Sm,wetA_Sm,'color','r')
plot(h_axes1(2),ts_Med,wetA_Med,'color','g') %previous 'y'
plot(h_axes1(2),ts_Lg,wetA_Lg,'color','b') %previous 'g'
plot(h_axes1(2),ts_SacW,wetA_SacW,'color','m')

grid(h_axes1(2),'on')
legend(h_axes1(2),{'Existing','FreSm','FreMed','FreLg','SacW'},'location','northwest')
datetick(h_axes1(2),'x','mmm','keeplimits')
xlabel(h_axes1(2),sprintf('WY %d',WY),'fontsize',8)


% if x_label_max < datenum([WY 6 1])
%     xlabel_limit = [datenum([WY-1 10 1]) datenum([WY 6 1])];
% else
%     xlabel_limit = [datenum([WY-1 10 1]) x_label_max];
% end

xlabel_limit = [datenum([WY-1 11 1]) datenum([WY 6 1])];

set(h_axes1(1),'xlim',xlabel_limit)
set(h_axes1(2),'xlim',xlabel_limit)

set(h_axes1(1),'fontsize',8)
set(h_axes1(2),'fontsize',8)


%% change Y-axis number with non-scientific
numtick = get(h_axes1(1),'ytick')';
strtick = cell(length(numtick),1);

for kk = 1:length(strtick)
    strtick{kk} = commaint(numtick(kk));
end

set(h_axes1(1),'yticklabel',strtick)

clear strtick numtick

% -------------------------- second y-axis

numtick = get(AX(2),'ytick')';
strtick = cell(length(numtick),1);

for mm = 1:length(strtick)
    strtick{mm} = commaint(numtick(mm));
end

set(AX(2),'yticklabel',strtick,'fontname',font_name,'fontsize',font_size)

clear strtick numtick
% set(leg_s3,'position',[leg3_pos(1:2) leg3_pos(3)*leg_ext leg3_pos(4)])











%% change X-axis number with non-scientific
numtick = get(h_axes1(2),'ytick')';
strtick = cell(length(numtick),1);

for jj = 1:length(strtick)
    strtick{jj} = commaint(numtick(jj));
end

set(h_axes1(2),'yticklabel',strtick)
clear strtick numtick

% align ylabel location
ylabel(AX(1),'Fremont Weir Flow (cfs)','fontname',font_name,'fontsize',font_size)
ylabel(AX(2),'Non-Fremont Flow (cfs)','fontname',font_name,'fontsize',font_size)

ylabel(h_axes1(2),'Wetted Area (Acres)','fontname',font_name,'fontsize',font_size)

% Y1 = get(y1,'position');
% Y2 = get(y2,'position');

% set(y2,'position',[Y1(1) Y2(2:end)]);
x_label_max = max([ts_Lg(end) ts_exist(end) ts_SacW(end) ts_Med(end) ts_Sm(end)]);


%%

figure_name = sprintf('WettedArea_WY_and_Q_%d__',WY);
% export_fig(fullfile('\\CBECM11\i\QC\Wetted Acres Plots',figure_name),'-pdf','-nocrop','-transparent','-append',h_fig)    
% export_fig('wetted_area_all_WY','-pdf','-nocrop','-transparent','-append',h_fig)    
   
% print(h_fig,'-dpng','Fig_7-9_Fremont_Q')
fig_num = (WY-1997+1)+16*file_name_mult;
% fig_num = WY-1996;

print(h_fig,'-djpeg','-r300',sprintf('Fig_A7-%d_FreQ_WetA_Mar15',fig_num))
%close(h_fig)


function [hourly_stamps, date_plot, Acre_plot] = read_wetted_table(filen)
fid = fopen(filen);
WetArea = textscan(fid,'%f%s%f%f%f','delimiter',',','headerlines',1);

hourly_stamps = datenum(WetArea{1});
date_plot = datenum(WetArea{2});
Acre_plot = WetArea{end};

fclose(fid);

function Gate_totalQ = read_Gate_flow_scenario(alt_type,WY)
HDD_loc = {'k','k'};
if WY <=2004
    HDD = HDD_loc{1};
else
    HDD = HDD_loc{2};
end

% --------------------------------------------- Existing
% if WY == 1997
%     fpath_1D_ex = sprintf('\\\\Cbecm11\\k\\Raw Results\\%da\\csv',WY);
% else
    fpath_1D_ex = sprintf('\\\\Cbecm11\\k\\Raw Results\\%d\\csv',WY);
% end
% alt_type = {'FreSm';'FreMed';'FreLg';'SacW'}; % sample Alt type
fname_1D_Gate_ex = sprintf('yolo_200ft_%s01_TS6_____%d_1d_O.csv',alt_type,WY);

% Gate Sim flows
fid_GQ  = fopen(fullfile(fpath_1D_ex,fname_1D_Gate_ex));

switch alt_type
    case 'FreSm'
        readfmtGQ = ['%*f%f%*s%*f%*f%*f' '%f' '%*s%*f%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f' '%f' '%*[^\n]' ];
    case 'SacW'
        % readfmtGQ = '%*f%*f%*s%*f%*f%*f%f%*[^\n]';
        readfmtGQ = ['%*f%f%*s%*f%*f%*f%*f%*s%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f%*f%f' repmat('%*s%*f%*f%*f%f',1,4)];
    otherwise
        readfmtGQ = ['%*f%f%*s%*f%*f%*f' '%f' '%*s%*f' ...
            repmat('%*f%*f%*f%f%*s',1,5) '%*[^\n]' ];

end

GateQ_ex  = textscan(fid_GQ,readfmtGQ,'delimiter',',','headerlines',1);
GateQ_ex_mat = cell2mat(GateQ_ex);
fclose(fid_GQ);
% --------------------------------------------  Scenarios
% if WY == 1997
%     fpath_1D = sprintf('\\\\Cbecm11\\k\\Raw Results\\%da\\Mar15\\csv',WY);
% else
    fpath_1D = sprintf('\\\\Cbecm11\\k\\Raw Results\\%d\\Mar15\\csv',WY);
% end
% alt_type = {'FreSm';'FreMed';'FreLg';'SacW'}; % sample Alt type

% filename convertions are found to be two kinds.
group1 = [1997 1998 2005 2006 2009:2012];
group2 = [1999:2001 2002:2004 2007:2008];

if isempty(intersect(WY,group2))
    fname_1D_Gate = sprintf('yolo_200ft_%s01_TS6___Mar15_%d_1d_O.csv',alt_type,WY);
elseif isempty(intersect(WY,group1))
    fname_1D_Gate = sprintf('yolo_200ft_%s01_TS6_Mar15___%d_1d_O.csv',alt_type,WY);
end
% Gate Sim flows
fid_GQ  = fopen(fullfile(fpath_1D,fname_1D_Gate));

switch alt_type
    case 'FreSm'
        readfmtGQ = ['%*f%f%*s%*f%*f%*f' '%f' '%*s%*f%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f' '%f' '%*[^\n]' ];
    case 'SacW'
        % readfmtGQ = '%*f%*f%*s%*f%*f%*f%f%*[^\n]';
        readfmtGQ = ['%*f%f%*s%*f%*f%*f%*f%*s%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f%*f%f' repmat('%*s%*f%*f%*f%f',1,4)];
    otherwise
        readfmtGQ = ['%*f%f%*s%*f%*f%*f' '%f' '%*s%*f' ...
            repmat('%*f%*f%*f%f%*s',1,5) '%*[^\n]' ];

end
            

GateQ_sce  = textscan(fid_GQ,readfmtGQ,'delimiter',',','headerlines',1);
GateQ_sce_mat = cell2mat(GateQ_sce);

%% stitching gate scenario data to original

[~,iex,isce] = intersect(GateQ_ex_mat(:,1),GateQ_sce_mat(:,1));

%  ------------- when time strings are not matched; off by a few hours
if isempty(iex)
    sce_start = GateQ_sce_mat(1,1);
    sce_end   = GateQ_sce_mat(end,1);
    iex = find(GateQ_ex_mat(:,1)> sce_start & GateQ_ex_mat(:,1)<sce_end);
    % GateQ_ex_mat_new = GateQ_ex_mat;
    %GateQ_ex_mat_new(iex,:) = GateQ_sce_mat(:,:);
    GateQ_ex_mat_new = [GateQ_ex_mat(1:iex-1,:); GateQ_sce_mat; ...
        GateQ_ex_mat(iex(end)+1:end,:)];
    Gate_TS = GateQ_ex_mat_new(:,1);
    
    dTS_Gate = Gate_TS - Gate_TS(1);   % time(hour) differences from the 1st entry
    
    % in real time (datenum)
    TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),Gate_TS(1),'hour') + dTS_Gate./24;
else
    GateQ_ex_mat(iex,2:end) = GateQ_sce_mat(isce,2:end);
    GateQ_ex_mat_new = GateQ_ex_mat;
    Gate_TS = GateQ_ex_mat_new(:,1);
    dTS_Gate = Gate_TS - Gate_TS(1);   % time(hour) differences from the 1st entry
    
    % in real time (datenum)
    TS_PO_time = addtodate(datenum([1996 10 2 0 0 0]),Gate_TS(1),'hour') + dTS_Gate./24;

end

% this is to force ZERO after gate closure time
GateQ_ex_mat_new(iex(end)+1:end,2:end) = 0; 

% GateQ_ex_mat2(GateQ_sce_mat(:,1),2:end) = GateQ_sce_mat(:,2:end);


%% summing up all gate flows

% Gate_totalQ = sum(cell2mat(GateQ),2);
Gate_totalQ = [TS_PO_time sum((GateQ_ex_mat_new(:,2:end)),2)];

fclose(fid_GQ);

function Gate_totalQ = read_Gate_flow(alt_type,WY)
HDD_loc = {'k','k'};
if WY <=2004
    HDD = HDD_loc{1};
else
    HDD = HDD_loc{2};
end

%fpath_1D = ...
%    sprintf('\\\\Cbecm11\\%s\\Work\\Projects\\13-1027_YBM\\LT_Model\\TUFLOW\\results\\%d\\csv',HDD,WY);
fpath_1D = sprintf('\\\\Cbecm11\\k\\Raw Results\\%d\\Mar15\\csv',WY);
% alt_type = {'FreSm';'FreMed';'FreLg';'SacW'}; % sample Alt type
fname_1D_Gate = sprintf('yolo_200ft_%s01_TS6___Mar15%d_1d_O.csv',alt_type,WY);

% Gate Sim flows
fid_GQ  = fopen(fullfile(fpath_1D,fname_1D_Gate));

switch alt_type
    case 'FreSm'
        readfmtGQ = ['%*f%*s%*s%*f%*f%*f' '%f' '%*s%*f%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f' '%f' '%*[^\n]' ];
    case 'SacW'
        % readfmtGQ = '%*f%*f%*s%*f%*f%*f%f%*[^\n]';
        readfmtGQ = ['%*f%*s%*s%*f%*f%*f%*f%*s%*f%*f%*f' '%f' ...
            '%*s%*f%*f%*f%*f%f' repmat('%*s%*f%*f%*f%f',1,4)];
    otherwise
        readfmtGQ = ['%*f%*s%*s%*f%*f%*f' '%f' '%*s%*f' ...
            repmat('%*f%*f%*f%f%*s',1,5) '%*[^\n]' ];

end
            

GateQ  = textscan(fid_GQ,readfmtGQ,'delimiter',',','headerlines',1);

Gate_totalQ = sum(cell2mat(GateQ),2);

fclose(fid_GQ);

    