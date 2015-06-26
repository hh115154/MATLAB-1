function Jflow_animation_v4_Existing_10yr
global color_Max image_name
close all

%% variables

tif_folder_S = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\UpperandFeather10yrPhase1\UpperFeather10yrInterGrids.7z';
% tif_folder_S =         'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\UpperandFeather200yrPhase1\UpperFeather200yInterGrids.7z';
ani_folder_loc = 'E:\Work\Projects\13-1009_SRV_Jflow_Ph2\Animation_new';
sce_name = 'Existing';
sce_name2= 'Ex';

% ------------- existing tiff (Maximum)
% tif_folder_E = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\UpperandFeather200yrPhase1\UpperandFeather200yrMaxandMonitor';
% tif_name_E = 'D2720002.tif';


% ------------- shp bounding boxes
shp_path = 'E:\Work\Projects\13-1009_SRV_Jflow_Ph2\Input Data';
shp_fn2 = 'ani_window2.shp';
Figure_TITLE = 'Existing - 10-year';

% ------------- shp cut lines
shp_fn = 'UpperFeatherS2XSLines_line.shp';
shp_fnY = 'LowerSacYoloS5XSLines_lines.shp';
shp_fnW = 'UpperFeatherS2XSLines_line_Whiskers.shp';
shp_fnL = 'JFLOW_levee_centerlines_merged_lines.shp';

% ------------- background image
image_name = 'E:\Work\Projects\13-1009_SRV_Jflow_Ph2\Input Data\Delta_map_600dpi_v3.jpg';

% ------------- flow paths

flow_path_S = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Scenario3\Upper10yrScenario003MaxMonitors';
% flow_path_S = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\Scenario3\Upper200yrScenario003MaxandMonitors';
flow_file_S = 'cross_section_flow.csv';

flow_path_E = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\UpperandFeather10yrPhase1\UpperandFeather10yrMaxandMonitor';
% flow_path_E = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\UpperandFeather200yrPhase1\UpperandFeather200yrMaxandMonitor';
flow_file_E = 'cross_section_flow.csv';

flow_path_SY = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Scenario3\YoloBypass\Yolo10yrScenario3MaxMonitor';
% flow_path_SY = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\Scenario3\YoloBypass\Yolo200yrScenario3MaxMonitors';
flow_file_SY = 'cross_section_flow.csv';

flow_path_EY = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Yolo Only Phase 1 Tests\Yolo10yrPhase1MaxMonitors';
% flow_path_EY = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\Yolo Only Phase 1 Tests\Yolo200yrPhase1MaxMonitor';
flow_file_EY = 'cross_section_flow.csv';

flow_path_Yolo11_12 = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Yolo Flow from supplemental excel';
% flow_path_Yolo11_12 = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\Yolo Flow from supplemental excel';
flow_file_Yolo11_12_Ex = 'YoloQ_existing.csv';
flow_file_Yolo11_12_S3 = 'YoloQ_Scenario3_10YR.csv';

% ------------- scenario features (shp file)
feat_loc = 'R:\Projects\13-1009_JFLOW_Phase2\GIS\DM_GIS\Scenario3_Features_SB';
ID15_NL_a = 'ID15_NL_a.shp'; % line
ID15_NL_b = 'ID15_NL_b.shp'; % line
ID15_weir = 'ID15_weir.shp'; % orange box

ID17_NLa = 'ID17_NLa.shp'; % line
ID17_NLb = 'ID17_NLb.shp'; % line
ID17_weir = 'ID17_weir.shp'; % orange box

ID18a_weir = 'ID18a_weir.shp'; % orange box
ID18b_OL =   'ID18b_OL.shp'; % orange box
ID18c_weir = 'ID18c_weir.shp'; % orange box

ID20a_Nweir = 'ID20a_Nweir.shp'; % orange box
ID20a_Sweir = 'ID20a_Sweir.shp'; % orange box
ID21a_NL = 'ID21a_NL_line.shp'; % line

%%
cd(tif_folder_S)
tic
%% parameters
prev_time = 0;

font_size = 9;
font_name = 'Calibri';
% font_name = 'Helvetica';

switch font_name
    case 'Calibri'
        leg_ext = 1.2;   % this can be 1.2 for Calibri font; stretches the legned box a little
    case 'Helvetica'
        leg_ext = 1;
end

%% Start VIDEO

% vidObj = VideoWriter(fullfile(ani_folder_loc,sprintf('yolo_%s_Exg_%s_%d_rev.avi',alt_type,item_name,model_year)));
vidObj = VideoWriter(fullfile(ani_folder_loc,sprintf('Jflow_%s_Existing_10yr_rev.avi',sce_name)));
vidObj.Quality = 100;
vidObj.FrameRate = 4;
open(vidObj);

%% Read shp file - animation window size
% shp_path = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data';
% shp_fn2 = 'ani_window2.shp';
Sn_w = shaperead(fullfile(shp_path,shp_fn2));


% === calc animation window ratio
% set(s1,'units','inches')
% win_size = get(s1,'position');
% ani_WH_ratio = win_size(4)/win_size(3);

% ------- extent: panel 1 (north 2 / south 18)

xlimN1 = Sn_w(1).BoundingBox(1:2);
ylimN1 = Sn_w(1).BoundingBox(3:4);

% extent: panel 2
xlimN2 = Sn_w(2).BoundingBox(1:2);
ylimN2 = Sn_w(2).BoundingBox(3:4)+5100;

% extent: panel 3 
xlimN3 = Sn_w(3).BoundingBox(1:2);
ylimN3 = Sn_w(3).BoundingBox(3:4);

% Width ratio
% r1 = 1;   % narrowest panel
% r2 = diff(xlimN2)/diff(xlimN1);
% r3 = diff(xlimN3)/diff(xlimN1);

% W/H ratio (from map)
WHr1 = diff(ylimN1)/diff(xlimN1);
WHr2 = diff(ylimN2)/diff(xlimN2);
WHr3 = diff(ylimN3)/diff(xlimN3);



%% Figure dimension
% hf_1 = figure('Color','w','Position',[10 200 1378 800]);
% PaperW = 15.5;
% PaperH = 9;

fig_width = 1500;
fig_height = 600;
hf_1 = figure('Color','w','Position',[10 400 fig_width fig_height]);
PaperW = 15.5;
PaperH = 9;

% margins - pixel

L_marg = 40;  % left margin
ani_gap = 30;
ani_W = 290;
ani_H = 510;
R_marg = 60;  % right margin

Gap   = 95;
Gap_colorbar = 20;

ts_H =  150;
ts_M =  (ani_H -3*ts_H)/2;
% ts_W =  fig_width - (L_marg+ani_W*3+ani_gap*2+Gap) - R_marg;

bot_5 = 40;
bot_4 = bot_5+ts_H+ts_M;
bot_3 = bot_4+ts_H+ts_M;

% ----- variable panel size (sum of three windows = 290*3 pixels)
% 290*3 = w1 + w2 + w3;
% 290*3 = d1 + d2*d1 + d3*d1 = d1*(1+d2+d3);

% ani_W1 = 290*3/(r1+r2+r3);
% ani_W2 = ani_W1*r2;
% ani_W3 = ani_W1*r3;

ani_W1 = ani_H/WHr1;
ani_W2 = ani_H/WHr2;
ani_W3 = ani_H/WHr3;

ts_W =  fig_width - (L_marg+ani_W1+ani_W2+ani_W3+ani_gap*2+Gap) - R_marg;


% ----- windows sizes 
subplots(1,1:4) = [L_marg bot_5 ani_W1 ani_H];
subplots(2,1:4) = [L_marg+ani_W1+ani_gap bot_5 ani_W2 ani_H];
subplots(3,1:4) = [L_marg+ani_W1+ani_W2+ani_gap*2 bot_5 ani_W3 ani_H];

ts_L =  L_marg+ani_W1+ani_W2+ani_W3+ani_gap*2+Gap;

subplots(4,1:4) = [ts_L bot_3 ts_W ts_H];
subplots(5,1:4) = [ts_L bot_4 ts_W ts_H];
subplots(6,1:4) = [ts_L bot_5 ts_W ts_H];

%{
% these are margins  - normalized
ani_L = 0.5/PaperW;
ani_M = 0.4/PaperW;
ani_W = 2.3/PaperW;
ani_H = 7.9146/PaperH;
Gap   = 0.5/PaperW;
Gap_colorbar = 0.2/PaperH;

ts_L =  ani_L+ani_W*3+ani_M*2+Gap;
ts_M =  0.5/PaperH;
ts_W =  (15-0.5)/PaperW - ts_L;
ts_H =  2.3/PaperH;

bot_5 = 0.6/PaperH;
bot_4 = bot_5+ts_H+ts_M;
bot_3 = bot_4+ts_H+ts_M;


subplots(1,1:4) = [ani_L bot_5 ani_W ani_H];
subplots(2,1:4) = [ani_L+ani_W+ani_M bot_5 ani_W ani_H];
subplots(3,1:4) = [ani_L+(ani_W+ani_M)*2 bot_5 ani_W ani_H];

subplots(4,1:4) = [ts_L bot_3 ts_W ts_H];
subplots(5,1:4) = [ts_L bot_4 ts_W ts_H];
subplots(6,1:4) = [ts_L bot_5 ts_W ts_H];
%}

% s6 = axes('position',subplots(6,:));
% s5 = axes('position',subplots(5,:));
% s4 = axes('position',subplots(4,:));
% 
% s3 = axes('position',subplots(3,:));
% s2 = axes('position',subplots(2,:));
% s1 = axes('position',subplots(1,:));

for i = 1:6
    eval(sprintf('s%d=axes(''units'',''pixels'',''position'',subplots(%d,:));',i,i))
end



%% Path

% ----- NORTH area
% pn = 'C:\Work\13-1009_SRV_Jflow_Ph2\Scenario 3';
pn = tif_folder_S;

D_sce = dir(fullfile(pn,'*.tif'));
tStamp = zeros(length(D_sce),1);

% ----- Yolo area
% pn_y = 'C:\Work\13-1009_SRV_Jflow_Ph2\Scenario 3\YoloBypass';
pn_y = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Yolo Only Phase 1 Tests\Yolo10yrPhase1InterGrids.7z';

D_sceY = dir(fullfile(pn_y,'*.tif'));
tStampY = zeros(length(D_sceY),1);

%% Read shp file - cut lines
% shp_path = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data';
% shp_fn = 'UpperFeatherS2XSLines_line.shp';
Sn = shaperead(fullfile(shp_path,shp_fn));
SnY = shaperead(fullfile(shp_path,shp_fnY));
SnW = shaperead(fullfile(shp_path,shp_fnW));
SnL = shaperead(fullfile(shp_path,shp_fnL));

%% Reading data file (1D flow)
color_lines = {'b','r','g','y','k','c','m'};
type_lines = {'-','--'};


%% NORTH
% --- Scenario
fidf = fopen(fullfile(flow_path_S,flow_file_S));
fmt = repmat('%f',1,63);
QS = textscan(fidf,fmt,'headerlines',1,'delimiter',',');  % all data
fclose(fidf); clear fidf;

% --- Existing
fidf = fopen(fullfile(flow_path_E,flow_file_E));

QE = textscan(fidf,fmt,'headerlines',1,'delimiter',',');  % all data
fclose(fidf); clear fidf;


tsS = round(QS{1});
tsE = round(QE{1});

QScms = cell2mat(QS(2:end));
QScfs = QScms.*(3937/1200)^3;

QEcms = cell2mat(QE(2:end));
QEcfs = QEcms.*(3937/1200)^3;

%% YOLO
% --- Scenario
fidf = fopen(fullfile(flow_path_SY,flow_file_S));
fmt = repmat('%f',1,63);
QSY = textscan(fidf,fmt,'headerlines',1,'delimiter',',');  % all data
fclose(fidf); clear fidf;

% --- Existing
fidf = fopen(fullfile(flow_path_EY,flow_file_E));

QEY = textscan(fidf,fmt,'headerlines',1,'delimiter',',');  % all data
fclose(fidf); clear fidf;


tsSY = round(QSY{1});
tsEY = round(QEY{1});

QScmsY = cell2mat(QSY(2:end));
QScfsY = QScmsY.*(3937/1200)^3;

QEcmsY = cell2mat(QEY(2:end));
QEcfsY = QEcmsY.*(3937/1200)^3;

% --- Curve 11 and 12/12 stage
fidf = fopen(fullfile(flow_path_Yolo11_12,flow_file_Yolo11_12_Ex));
fmt_sup = '%f%f%f%f%f';
QEY_sup = textscan(fidf,fmt_sup,'headerlines',1,'delimiter',',');  % all data
fclose(fidf); clear fidf;

fidf = fopen(fullfile(flow_path_Yolo11_12,flow_file_Yolo11_12_S3));
%fmt_sup = '%f%f%f%f%f';
QSY_sup = textscan(fidf,fmt_sup,'headerlines',1,'delimiter',',');  % all data
fclose(fidf); clear fidf;


%% --------------------------------------------------------------------- plot time series (scenarios)
%% --------------------------------------------------------------------- TOP panel
p_ind1 = [7 8 16 17 18];
leg_item1 = cell(2*length(p_ind1),1);
L1 = zeros(length(p_ind1),1);

for p = 1:length(p_ind1)
    if p_ind1(p) == 7 || p_ind1(p) == 17
        L1(p) = plot(s4,tsE,QEcfs(:,p_ind1(p))+19300,[color_lines{p} type_lines{1}]);
        hold(s4,'on')
        % plot(s4,tsS,QScfs(:,p_ind1(p))+14300,[color_lines{p} type_lines{2}])
    else
        L1(p) = plot(s4,tsE,QEcfs(:,p_ind1(p)),[color_lines{p} type_lines{1}]);
        hold(s4,'on')
        % plot(s4,tsS,QScfs(:,p_ind1(p)),[color_lines{p} type_lines{2}])
        
    end
    
    % leg_item1{2*p-1} = sprintf('%s %s',num2str(p_ind1(p)),'Ex');
    leg_item1{2*p-1} = sprintf('%s',num2str(p_ind1(p)));
    leg_item1{2*p} = sprintf('%s %s',num2str(p_ind1(p)),sce_name2);
    
end
set(s4,'xlim',[tsE(1) tsE(end)])
set(s4,'ylim',[0 200000])
y_lim1 = get(s4,'ylim');
% set(s4,'ytick',[0:100000:300000 350000])
set(s4,'fontsize',font_size,'fontname',font_name)
set(s4,'xticklabel',[]);
title(s4,{Figure_TITLE;'Butte Basin'})
ylabel(s4,'Flow (cfs)')
grid(s4,'on')
set(gcf,'CurrentAxes',s4)

% legend(s4,L1,leg_item1(1:2:end),'location','northwest')
legend(s4,L1,{'1','2','3','4','5'},'location','northwest')
% columnlegend(length(p_ind1),leg_item1,'NorthWest','boxoff');
change_ytick_withComma(s4,font_name)


%% --------------------------------------------------------------------- MIDDLE panel
p_ind2 = [22 33 27 36 35];
leg_item2 = cell(2*length(p_ind2),1);
L2 = zeros(length(p_ind2),1);

for p = 1:length(p_ind2)
    if p_ind2(p) == 33 || p_ind2(p) == 36
        L2(p) = plot(s5,tsE,QEcfs(:,p_ind2(p))+19300,[color_lines{p} type_lines{1}]);
        hold(s5,'on')
        % plot(s5,tsS,QScfs(:,p_ind2(p))+14300,[color_lines{p} type_lines{2}])
    else
        
        L2(p) = plot(s5,tsE,QEcfs(:,p_ind2(p)),[color_lines{p} type_lines{1}]);
        hold(s5,'on')
        % plot(s5,tsS,QScfs(:,p_ind2(p)),[color_lines{p} type_lines{2}])
    end
    % leg_item2{2*p-1} = sprintf('%s %s',num2str(p_ind2(p)),'Ex');
    leg_item2{2*p-1} = sprintf('%s',num2str(p_ind2(p)));
    leg_item2{2*p} = sprintf('%s %s',num2str(p_ind2(p)),sce_name2);
        
end
set(s5,'xlim',[tsE(1) tsE(end)])
y_lim2 = get(s5,'ylim');
set(s5,'ylim',[0 y_lim2(2)])

set(s5,'fontsize',font_size,'fontname',font_name)
set(s5,'xticklabel',[]);
title(s5,'Sutter Bypass')
ylabel(s5,'Flow (cfs)')
grid(s5,'on')
set(gcf,'CurrentAxes',s5)

% legend(s5,L2,leg_item2(1:2:end),'location','northwest')
legend(s5,L2,{'6','7','8','9','10'},'location','northwest')
% columnlegend(length(p_ind2),leg_item2,'NorthWest','boxoff');

change_ytick_withComma(s5,font_name)

%% --------------------------------------------------------------------- BOTTOM panel
%  p_ind3_xsec = [37 58 2 1 35];
p_ind3 = [1 28];

% leg_item3 = cell(2*length(p_ind3),1);
L3 = zeros(length(p_ind3+2),1);


% -------------- from supplemental data 11, 12 and 12 stage
% Yolo Q
set(gcf,'CurrentAxes',s6)
[AX,H1,H3] = plotyy(QEY_sup{1},QEY_sup{3},QEY_sup{1},QEY_sup{5}); % Yolo Q / Verona H: Existing

% axes(AX(1))
hold(AX(1),'on')
% plot(QSY_sup{1},QSY_sup{4},[color_lines{2} type_lines{2}]); % Verona Q: Scenario
H2 = plot(QEY_sup{1},QEY_sup{4},[color_lines{2} type_lines{1}]); % Verona Q: Existing
hold on
% plot(QSY_sup{1},QSY_sup{3},[color_lines{1} type_lines{2}]); % Yolo Q: Scenario

for p = 1:length(p_ind3)
    L3(p) = plot(tsEY,QEcfsY(:,p_ind3(p)),[color_lines{p+3} type_lines{1}]);
    % plot(tsSY,QScfsY(:,p_ind3(p)),[color_lines{p+3} type_lines{2}])
        
    % leg_item3{2*p-1} = sprintf('%s %s',num2str(p_ind3(p)),'Ex');
    % leg_item3{2*p-1} = sprintf('%s',num2str(p_ind3(p)));
    % leg_item3{2*p} = sprintf('%s %s',num2str(p_ind3(p)),sce_name2);
end

axes(AX(2))
hold on
% plot(QSY_sup{1},QSY_sup{5},[color_lines{3} type_lines{2}]); % Verona H: Scenario

set(H1,'color',color_lines{1})
set(H3,'color',color_lines{3})

set(AX,{'ycolor'},{'k';'k'})
set(AX(1),'ylim',[0 700000])
set(AX(2),'ylim',[10 40])


for xn = 1:length(AX)
    set(AX(xn),'xlim',[tsEY(1) tsEY(end)])
    set(AX(xn),'fontsize',font_size,'fontname',font_name)

end
% y_lim3 = get(s6,'ylim');
y_lim3 = get(AX(1),'ylim');
% set(s6,'ylim',[0 y_lim3(2)])

%set(s6,'fontsize',font_size,'fontname',font_name)
% set(s6,'xticklabel',[]);
title(s6,'Yolo Bypass')
set(gcf,'CurrentAxes',s6)
xlabel(s6,'Time (hours)')
ylabel(AX(1),'Flow (cfs)')
ylabel(AX(2),'Stage (ft)')

grid(s6,'on')
% legend(s6,L3,leg_item3(1:2:end),'location','northwest')
legend(s6,[H1,H2,H3,L3(1),L3(2)],{'11','12','12 Stage','13','14'},'location','northwest')
% columnlegend(length(p_ind3),leg_item3,'NorthWest','boxoff');
set(s6,'ytick',[0 200000 400000 600000 700000])
set(AX(2),'ytick',[10 20 30 40])

change_ytick_withComma(s6,font_name)

%% ------------------------------------------------------------Reading data file (2D animation)

% sort data file in ascending time
for j = 1:length(D_sce)
    % hour
    in1 = regexp(D_sce(j).name,'_');
    % in2 = regexp(D_sce(j).name,'\.');
    in2 = regexp(D_sce(j).name,'h');
    tStamp(j) = str2double(D_sce(j).name(in1(2)+1:in2(2)-1));
end

[t_hour, t_hour_i] = sort(tStamp);

% sort data file in ascending time (Yolo)
for j = 1:length(D_sceY)
    % hour
    in1 = regexp(D_sceY(j).name,'_');
    % in2 = regexp(D_sceY(j).name,'\.');
    in2 = regexp(D_sceY(j).name,'h');
    
    tStampY(j) = str2double(D_sceY(j).name(in1(2)+1:in2(2)-1));
end

[t_hourY, t_hour_iY] = sort(tStampY);



























%% ======================================================================= TIFF time series

% draw existing maximum



for k = 1:length(D_sceY)
    if rem(round(t_hourY(k)),3) ~= 0
        % timecheck = toc;
        continue
    end
% for k = 31:33    
    % k = 3;
    % sorted by hour
    fn = D_sce(t_hour_i(k/3)).name;
    fnY = D_sceY(t_hour_iY(k)).name;

    color_Max = 15.24;

    % 1st/2nd panel (same tiff)
    plot_tiff_1(fullfile(pn,fn),s1,xlimN1,ylimN1,s2,xlimN2,ylimN2)
    
    
    % 3rd panel - Yolo
    plot_tiff_1(fullfile(pn_y,fnY),s3,xlimN3,ylimN3)
    xlabel(s3,sprintf('Time: %d hours',round(t_hourY(k))),'fontsize',font_size,'fontname',font_name)
    

    %% Colorbar
    
    cbar_axes = colorbar('north','peer',s1);
    % set(cbar_axes,'position',[0.1 0.93 0.46 0.01]);
    % set(cbar_axes,'position',[L_marg bot_5+ani_H+Gap_colorbar L_marg+ani_W1+ani_W2+ani_W3+ani_gap 5],'units','pixel');
    set(cbar_axes,'units','pixels');
    set(cbar_axes,'position',[L_marg bot_5+ani_H+Gap_colorbar L_marg+ani_W1+ani_W2+ani_W3+ani_gap*0.6 5]);
    % set(cbar_axes,'position',[L_marg bot_5+ani_H+Gap_colorbar L_marg+ani_W1+ani_W2+ani_W3+ani_gap 5],'units','pixel');
    
    cbar_xlim = get(cbar_axes,'xlim');
    set(cbar_axes,'xtick',linspace(cbar_xlim(1),cbar_xlim(2),11))
    set(cbar_axes,'xticklabel',0:5:round(color_Max*3937/1200))   % depth color in feet
    item_name = 'Depth';
    title(cbar_axes,sprintf('%s (ft)',item_name),'fontsize',font_size,'fontname',font_name);
    set(cbar_axes,'fontsize',font_size,'fontname',font_name);
    set(cbar_axes,'fontsize',font_size,'fontname',font_name);
    


%% ------------------------------------------------------------- LEVEE center lines
    for kk = 1:length(SnL)
        plot(s1,SnL(kk).X,SnL(kk).Y,'k','linewidth',0.5)
        hold(s1,'on')
        plot(s2,SnL(kk).X,SnL(kk).Y,'k','linewidth',0.5)
        hold(s2,'on')
        plot(s3,SnL(kk).X,SnL(kk).Y,'k','linewidth',0.5)
        hold(s3,'on')
        
    end
    
    
    
    
%% Scenario Features

% 1st panel
% draw_scenario_features(s1,feat_loc,ID15_NL_a);
% draw_scenario_features(s1,feat_loc,ID15_NL_b);
% draw_scenario_features(s1,feat_loc,ID15_weir);
% draw_scenario_features(s1,feat_loc,ID18a_weir);
% draw_scenario_features(s1,feat_loc,ID18b_OL);
% 
% % both panels
% draw_scenario_features(s1,feat_loc,ID18c_weir);
% draw_scenario_features(s2,feat_loc,ID18c_weir);
% 
% % 2nd panel
% draw_scenario_features(s2,feat_loc,ID17_NLa);
% draw_scenario_features(s2,feat_loc,ID17_NLb);
% draw_scenario_features(s2,feat_loc,ID17_weir);
% draw_scenario_features(s2,feat_loc,ID20a_Nweir);
% draw_scenario_features(s2,feat_loc,ID20a_Sweir);
% draw_scenario_features(s2,feat_loc,ID21a_NL,'meter');

















%% ------------------------------------------------------------- CUT LINES    
    for kk = 1:length(Sn)
        if isempty(intersect(union(p_ind2,p_ind1),kk))
            if kk ~= 37 && kk ~= 58
                % fprintf(1,'%d\n',kk)
                continue
            end
        end
        plot(s1,Sn(kk).X,Sn(kk).Y,'r')
        hold(s1,'on')
        plot(s2,Sn(kk).X,Sn(kk).Y,'r')
        hold(s2,'on')
        plot(s3,Sn(kk).X,Sn(kk).Y,'r')
        hold(s3,'on')
        
    end
    
    for kk = 1:length(SnY)
        if isempty(intersect(p_ind3,kk))
            continue
        end
        plot(s3,SnY(kk).X,SnY(kk).Y,'r')
        hold(s3,'on')
    end
%                                  -------------------------------- whiskers    
    for kk = 1:length(SnW)
        plot(s1,SnW(kk).X,SnW(kk).Y,'r')
        hold(s1,'on')
        plot(s2,SnW(kk).X,SnW(kk).Y,'r')
        hold(s2,'on')
        plot(s3,SnW(kk).X,SnW(kk).Y,'r')
        hold(s3,'on')

    end
    
    
    % --------------- shp labeling
    
    set(gcf,'CurrentAxes',s1)
    
    xT1 = [5.823882392515214; 6.031561970315927; 5.871390792665704; ...
        5.853744815466951; 5.963692827243799].*10^5;
    yT1 = [4.368285126532420; 4.369778247680008; 4.345481094460186; ...
        4.340051563014415; 4.341408945875858].*10^6;
    
    text(xT1,yT1,{'1';'2';'3';'4';'5'},'color','r','fontsize',font_size,'fontname',font_name)
    
    
    set(gcf,'CurrentAxes',s2)
    
    xT2 = [5.964649590508281; 6.018823551618118; 5.961940892452790; ...
         6.03507573995;  6.1488410582817; 6.197597623280577; ...
        6.196243274252830; 6.22603895286324].*10^5;
    yT2 = [4.342427529918660; 4.335520349877156; 4.320080770960852; ...
        4.322247729405246; 4.295160748850328; 4.296650532780848; ...
        4.291774876280964; 4.293535530017033].*10^6;
    
    text(xT2,yT2,{'5';'6';'7';'8';'9';'10';'11';'12'},'color','r','fontsize',font_size,'fontname',font_name)
    
    set(gcf,'CurrentAxes',s3)
    
    xT3 = [6.140962056204987; 6.246601280369170; 6.185655574120602].*10^5;
    yT3 = [4.290058243850522; 4.260220825629014; 4.240853634532247].*10^6;
    
    text(xT3,yT3,{'11';'13';'14'},'color','r','fontsize',font_size,'fontname',font_name)
    
    set(gcf,'CurrentAxes',s4)
    % y_lim_max = max(y_lim(2),y_lim2(2));
    l4 = line([round(t_hourY(k)) round(t_hourY(k))],y_lim1,'color','k');
%     text(75,325000,{'Solid = Existing';'Dashed = Scenario'}, ...
%         'verticalalignment','top','backgroundcolor','w', ...
%         'fontsize',font_size,'fontname',font_name)
    set(gcf,'CurrentAxes',s5)
    % y_lim_max = max(y_lim(2),y_lim2(2));
    l5 = line([round(t_hourY(k)) round(t_hourY(k))],y_lim2,'color','k');
    
    
    set(gcf,'CurrentAxes',s6)
    % y_lim_max = max(y_lim(2),y_lim2(2));
    l6 = line([round(t_hourY(k)) round(t_hourY(k))],y_lim3,'color','k');
    
    %% ================= legend for existing grey dots
    x_legend = [586500 603300];
    y_legend = [4290270 4293270];
    
    
    set(gcf,'CurrentAxes',s2)
    
    
    p1 = patch([x_legend(1) x_legend(2) x_legend(2) x_legend(1)], ...
        [y_legend(1) y_legend(1) y_legend(2) y_legend(2)],'w');
    
    
    x_text = x_legend(1)+4000;
    y_text = y_legend(1) + 1500;
    y_text = y_text';
    y_text = flipud(y_text);
    
    text(x_text,y_text,'Monitoring Line','fontsize',font_size,'fontname',font_name)
    
    % red line
    qqq = 200;
    line([x_text(1)-3000-qqq x_text(1)-500-qqq],repmat(y_text(1),1,2),'linewidth',1,'color','r')
    % red whiskers
    line([x_text(1)-3000-qqq x_text(1)-3000-qqq],[y_text(1)-250 y_text(1)+250],'linewidth',1,'color','r')
    line([x_text(1)-500-qqq x_text(1)-500-qqq],[y_text(1)-250 y_text(1)+250],'linewidth',1,'color','r')
    
    % line([x_text(2)-3000-qqq x_text(2)-500-qqq],repmat(y_text(2),1,2),'linewidth',2,'color','k')
    
    %p_orange = patch([x_text(3)-3000-qqq x_text(3)-500-qqq x_text(3)-500-qqq x_text(3)-3000-qqq], ...
    %    [y_text(3)-750 y_text(3)-750 y_text(3)+700 y_text(3)+700],[255 165 0]./255);
    %    set(p_orange,'edgecolor','none')
    
    %   p_grey = patch([x_text(4)-3000-qqq x_text(4)-500-qqq x_text(4)-500-qqq x_text(4)-3000-qqq], ...
    %    [y_text(4)-750 y_text(4)-750 y_text(4)+700 y_text(4)+700],[.7 .7 .7]);
    %    set(p_grey,'edgecolor','none')
 
    %% disclaimer
    
    set(gcf,'CurrentAxes',s1)
    XLogoLeft = 5.7682296951e5;
    XLogoRight = 5.844243135e5;
    YLogo = [4.33394334013e6 4.33394334013e6];
    
    text(XLogoLeft(1),YLogo(1),'Privileged and Confidential - Not for Distribution', ...
        'fontsize',font_size,'fontname',font_name)

    %% Write VIDEO
    writeVideo(vidObj,getframe(hf_1));
    
    timecheck = toc;
    fprintf(1,'Fig %d:Elapsed time = %.1f sec, total = %.1f min\n',k,timecheck-prev_time,timecheck/60)
    prev_time = timecheck;

    delete(cbar_axes);
    
    delete(l4);
    delete(l5);
    delete(l6);
%     close(hf_1)
        set(s1,'nextplot','replacechildren');
    set(s2,'nextplot','replacechildren');
    set(s3,'nextplot','replacechildren');

end
fprintf(1,'\nTotal time = %.1f min\n',timecheck/60)
close(vidObj);
close all


function plot_tiff_1(fn,ax_h1,xLim1,yLim1,ax_h2,xLim2,yLim2)
global color_Max image_name
%% Color definition
load('YoloColormapsBlue','mycmap')

new_cmap = mycmap(1:3:end,:);
cdivs = length(new_cmap);
% cdivs = length(mycmap);
% cdivs = 32;

dot_size = 1;

edges = [-Inf linspace(0,color_Max,cdivs-1) Inf];
cmap = new_cmap;


% fprintf(1,'sorted file = %s\n',fn)
GRID_sce3 = imread(fn);
I = geotiffinfo(fn);

%% extract points from tiff

ncols = I.SpatialRef.RasterSize(2);
nrows = I.SpatialRef.RasterSize(1);
xcor = I.SpatialRef.XLimWorld(1);
ycor = I.SpatialRef.YLimWorld(1);
dxy = I.SpatialRef.DeltaX;
NoData = -9999;



GRID_sce3(GRID_sce3==NoData) = NaN;
[ii,jj,v] = find(~isnan(GRID_sce3));

xcoord = xcor + jj.*dxy - dxy/2;
ycoord = (ycor + nrows*dxy) - ii*dxy + dxy/2;
zcoord = GRID_sce3(~isnan(GRID_sce3));

[~, bink] = histc(zcoord,edges);

cmap = new_cmap;

%% 1st panel

%% --------------------------------------- map image
img = imread(image_name);
set(gcf,'CurrentAxes',ax_h1)
image([576890.838662679 634122.416086125],[4405739.39989204 4221527.07998005],img)


axis(ax_h1,'equal')
set(ax_h1,'ydir','normal')
set(ax_h1,'xlim',xLim1)
set(ax_h1,'ylim',yLim1)

hold(ax_h1,'on')


%% --------------------------------------- max inundation extent (exiting)
% if yLim1(1) < 4.23e6
%     fn = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\Yolo Only Phase 1 Tests\Yolo200yrPhase1MaxMonitor\D25200101.tif';
% else
%     fn = 'C:\Work\13-1009_SRV_Jflow_Ph2\J_drive\UpperandFeather200yrPhase1\UpperandFeather200yrMaxandMonitor\D2720002.tif';
% end
% GRID_ex = imread(fn);
% Iex = geotiffinfo(fn);
% 
% % extract points from tiff
% 
% ncols = Iex.SpatialRef.RasterSize(2);
% nrows = Iex.SpatialRef.RasterSize(1);
% xcor = Iex.SpatialRef.XLimWorld(1);
% ycor = Iex.SpatialRef.YLimWorld(1);
% dxy = Iex.SpatialRef.DeltaX;
% NoData = -9999;
% 
% 
% 
% GRID_ex(GRID_ex==NoData) = NaN;
% [ii,jj,v] = find(~isnan(GRID_ex));
% 
% xcoord_ex = xcor + jj.*dxy - dxy/2;
% ycoord_ex = (ycor + nrows*dxy) - ii*dxy + dxy/2;
% zcoord_ex = GRID_ex(~isnan(GRID_ex));
% 
% plot(ax_h1,xcoord_ex,ycoord_ex,'.','Markersize',dot_size,'Color',[.7 .7 .7])





%% ------------------------------------------- scenario depth time series (2D)

for ii=1:cdivs
    idx = bink==ii;
    plot(ax_h1,xcoord(idx),ycoord(idx),'.','MarkerSize',dot_size,'Color',cmap(ii,:));
    hold(ax_h1,'on')
end
axis(ax_h1,'equal')

set(ax_h1,'xlim',xLim1)
set(ax_h1,'ylim',yLim1)
set(ax_h1,'xtick',[])
set(ax_h1,'ytick',[])
set(ax_h1,'box','on')

colormap(cmap);
caxis(ax_h1,[0 color_Max])

%% 2nd panel

if nargin > 4
    %image_name = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data\Delta_map_panel1_800dpi.jpg';
    img = imread(image_name);
    set(gcf,'CurrentAxes',ax_h2)
    image([576890.838662679 634122.416086125],[4405739.39989204 4221527.07998005],img)
    axis(ax_h2,'equal')
    set(ax_h2,'ydir','normal')
    % set(ax_h1,'xlim',[xmin xmax])
    % set(ax_h1,'ylim',[ymid ymax])
    set(ax_h2,'xlim',xLim2)
    set(ax_h2,'ylim',yLim2)

    hold(ax_h2,'on')

    % ---------------------------------------------- existing max inundation extent
    % plot(ax_h2,xcoord_ex,ycoord_ex,'.','Markersize',dot_size,'Color',[.7 .7 .7])

    
    % ----------------------------------------------
    for ii=1:cdivs
        idx = bink==ii;
        plot(ax_h2,xcoord(idx),ycoord(idx),'.','MarkerSize',dot_size,'Color',cmap(ii,:));
        hold(ax_h2,'on')
    end
    axis(ax_h2,'equal')
    
    % set(ax_h,'xlim',I.SpatialRef.XLimWorld)
    % set(ax_h,'ylim',I.SpatialRef.YLimWorld)
    set(ax_h2,'xlim',xLim2)
    set(ax_h2,'ylim',yLim2)
    set(ax_h2,'xtick',[])
    set(ax_h2,'ytick',[])
    set(ax_h2,'box','on')
    
    colormap(cmap);
    % clear edges idx bink
    % caxis(s1,[0 30])
    % caxis([min(zcoord) max(zcoord)])
    caxis(ax_h2,[0 color_Max])
    
    
    
    
    %% ================= legend for existing grey dots
    
    
%     x_legend = [5.9876735239e5 6.03643008897e5];
%     y_legend = [4.2975985771e6 4.300171840252e6];
%     
%     p1 = patch([x_legend(1) x_legend(2) x_legend(2) x_legend(1)], ...
%         [y_legend(1) y_legend(1) y_legend(2) y_legend(2)],'w');
%     set(p1,'edgecolor','none')
%     
%     x_grey = [2.0129349e6 2.0151465e6];
%     y_grey = [1.40003452e7 1.3998588e7];
%     
%     p2 = patch([x_grey(1) x_grey(2) x_grey(2) x_grey(1)], ...
%         [y_grey(1) y_grey(1) y_grey(2) y_grey(2)],[.7 .7 .7]);
%     set(p2,'edgecolor','none')
%     
%     text(2.0158376e6, 1.39995768e7,'Existing')
    
end

function change_ytick_withComma(ax_h,font_name)

% change Y-axis number with non-scientific
numtick = get(ax_h,'ytick')';
strtick = cell(length(numtick),1);

for mm = 1:length(strtick)
    strtick{mm} = commaint(numtick(mm));
end

set(ax_h,'yticklabel',strtick,'fontname',font_name)

clear strtick numtick

function draw_scenario_features(ax_h,pn,fn,unit)
    if nargin < 4
        unit = 'feet';
    end
    switch unit
        case 'feet'
            factor = 1200/3937;
        case 'meter'
            factor = 1;
    end
    S = shaperead(fullfile(pn,fn));
    
    switch S.Geometry
        case 'Line'
            for q = 1:length(S)
                p1 = plot(ax_h,S(q).X(1:end-1).*factor,S(q).Y(1:end-1).*factor);
                set(p1,'linewidth',2,'color','k')
                hold(ax_h,'on')
                
            end
            
            
        case 'Polygon'
            set(gcf,'CurrentAxes',ax_h)
            for q = 1:length(S)
                p1 = patch(S(q).X(1:end-1).*factor,S(q).Y(1:end-1).*factor,[255 165 0]./255);
                set(p1,'edgecolor','none')
                
            end
            
            
    end
















