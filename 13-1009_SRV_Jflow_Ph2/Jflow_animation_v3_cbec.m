function Jflow_animation_v3_cbec
global color_Max image_name
close all

%% variables

tif_folder_S = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Scenario3\Upper200yrScenario3InterDepthGrids.7z';
ani_folder_loc = 'E:\Work\Projects\13-1009_SRV_Jflow_Ph2\Animation';
sce_name = 'scenario_3';
sce_name2= 'Sce 3';

% ------------- shp bounding boxes
shp_path = 'E:\Work\Projects\13-1009_SRV_Jflow_Ph2\Input Data';
shp_fn2 = 'ani_window2.shp';

% ------------- shp cut lines
shp_fn = 'UpperFeatherS2XSLines_line.shp';
shp_fnY = 'LowerSacYoloS5XSLines_lines.shp';

% ------------- background image
image_name = 'E:\Work\Projects\13-1009_SRV_Jflow_Ph2\Input Data\Delta_map_600dpi_v3.jpg';

% ------------- flow paths

flow_path_S = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Scenario3\Upper200yrScenario003MaxandMonitors';
flow_file_S = 'cross_section_flow.csv';

flow_path_E = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\UpperandFeather200yrPhase1\UpperandFeather200yrMaxandMonitor';
flow_file_E = 'cross_section_flow.csv';

flow_path_SY = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Scenario3\YoloBypass\Yolo200yrScenario3MaxMonitors';
flow_file_SY = 'cross_section_flow.csv';

flow_path_EY = 'J:\M2_EdriveCopy\Work\13-1009_SRV_Jflow_Ph2\Yolo Only Phase 1 Tests\Yolo200yrPhase1MaxMonitor';
flow_file_EY = 'cross_section_flow.csv';

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
vidObj = VideoWriter(fullfile(ani_folder_loc,sprintf('Jflow_%s.avi',sce_name)));
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
pn_y = '..\YoloBypass\Yolo200yrScenario3InterDepthGrids';

D_sceY = dir(fullfile(pn_y,'*.tif'));
tStampY = zeros(length(D_sceY),1);

%% Read shp file - cut lines
% shp_path = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data';
% shp_fn = 'UpperFeatherS2XSLines_line.shp';
Sn = shaperead(fullfile(shp_path,shp_fn));
SnY = shaperead(fullfile(shp_path,shp_fnY));

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




%% --------------------------------------------------------------------- plot time series (scenarios)
%% --------------------------------------------------------------------- TOP panel
p_ind1 = [7 8 16 17 18];
leg_item1 = cell(2*length(p_ind1),1);
L1 = zeros(length(p_ind1),1);

for p = 1:length(p_ind1)
    if p_ind1(p) == 7 || p_ind1(p) == 17
        L1(p) = plot(s4,tsE,QEcfs(:,p_ind1(p))+19300,[color_lines{p} type_lines{1}]);
        hold(s4,'on')
        plot(s4,tsS,QScfs(:,p_ind1(p))+14300,[color_lines{p} type_lines{2}])
    else
        L1(p) = plot(s4,tsE,QEcfs(:,p_ind1(p)),[color_lines{p} type_lines{1}]);
        hold(s4,'on')
        plot(s4,tsS,QScfs(:,p_ind1(p)),[color_lines{p} type_lines{2}])
        
    end
    
    % leg_item1{2*p-1} = sprintf('%s %s',num2str(p_ind1(p)),'Ex');
    leg_item1{2*p-1} = sprintf('%s',num2str(p_ind1(p)));
    leg_item1{2*p} = sprintf('%s %s',num2str(p_ind1(p)),sce_name2);
    
end
set(s4,'xlim',[tsE(1) tsE(end)])
y_lim1 = get(s4,'ylim');
set(s4,'ylim',[0 y_lim1(2)])

set(s4,'fontsize',font_size,'fontname',font_name)
set(s4,'xticklabel',[]);
title(s4,'Butte Basin')
ylabel(s4,'Flow (cfs)')
grid(s4,'on')
set(gcf,'CurrentAxes',s4)

legend(s4,L1,leg_item1(1:2:end),'location','northwest')
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
        plot(s5,tsS,QScfs(:,p_ind2(p))+14300,[color_lines{p} type_lines{2}])
    else
        
        L2(p) = plot(s5,tsE,QEcfs(:,p_ind2(p)),[color_lines{p} type_lines{1}]);
        hold(s5,'on')
        plot(s5,tsS,QScfs(:,p_ind2(p)),[color_lines{p} type_lines{2}])
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

legend(s5,L2,leg_item2(1:2:end),'location','northwest')
% columnlegend(length(p_ind2),leg_item2,'NorthWest','boxoff');

change_ytick_withComma(s5,font_name)

%% --------------------------------------------------------------------- BOTTOM panel
%  p_ind3_xsec = [37 58 2 1 35];
p_ind3 = [1 28];

leg_item3 = cell(2*length(p_ind3),1);
L3 = zeros(length(p_ind3),1);

for p = 1:length(p_ind3)
    L3(p) = plot(s6,tsEY,QEcfsY(:,p_ind3(p)),[color_lines{p} type_lines{1}]);
    hold(s6,'on')
    plot(s6,tsSY,QScfsY(:,p_ind3(p)),[color_lines{p} type_lines{2}])
        
    % leg_item3{2*p-1} = sprintf('%s %s',num2str(p_ind3(p)),'Ex');
    leg_item3{2*p-1} = sprintf('%s',num2str(p_ind3(p)));
    leg_item3{2*p} = sprintf('%s %s',num2str(p_ind3(p)),sce_name2);
end
set(s6,'xlim',[tsEY(1) tsEY(end)])
y_lim3 = get(s6,'ylim');
set(s6,'ylim',[0 y_lim3(2)])

set(s6,'fontsize',font_size,'fontname',font_name)
% set(s6,'xticklabel',[]);
title(s6,'Yolo Bypass')
set(gcf,'CurrentAxes',s6)
xlabel(s6,'Time (hours)')
ylabel(s6,'Flow (cfs)')
grid(s6,'on')
legend(s6,L3,leg_item3(1:2:end),'location','northwest')
% columnlegend(length(p_ind3),leg_item3,'NorthWest','boxoff');

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

[t_hour, t_hour_iY] = sort(tStampY);

for k = 1:length(D_sce)
% for k = 1:5    
    % k = 3;
    % sorted by hour
    fn = D_sce(t_hour_i(k)).name;
    fnY = D_sceY(t_hour_iY(k)).name;

    color_Max = 15.24;

    % 1st/2nd panel (same tiff)
    plot_tiff_1(fullfile(pn,fn),s1,xlimN1,ylimN1,s2,xlimN2,ylimN2)
    
    
    % 3rd panel - Yolo
    plot_tiff_1(fullfile(pn_y,fnY),s3,xlimN3,ylimN3)
    xlabel(s3,sprintf('Time: %d hours',round(t_hour(k))),'fontsize',font_size,'fontname',font_name)
    

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
    
    %%

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
    
    
        set(gcf,'CurrentAxes',s4)
        % y_lim_max = max(y_lim(2),y_lim2(2));
        l4 = line([round(t_hour(k)) round(t_hour(k))],y_lim1,'color','k');
        
        set(gcf,'CurrentAxes',s5)
        % y_lim_max = max(y_lim(2),y_lim2(2));
        l5 = line([round(t_hour(k)) round(t_hour(k))],y_lim2,'color','k');
        
        
        set(gcf,'CurrentAxes',s6)
        % y_lim_max = max(y_lim(2),y_lim2(2));
        l6 = line([round(t_hour(k)) round(t_hour(k))],y_lim3,'color','k');
        
    
    
    
    
    
    
    
    
    
    
    
    
    
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

img = imread(image_name);
set(gcf,'CurrentAxes',ax_h1)
image([576890.838662679 634122.416086125],[4405739.39989204 4221527.07998005],img)


% aerial
% if nargin > 4
%     image_name = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data\Delta_map_panel1_800dpi.jpg';
%     img = imread(image_name);
%     set(gcf,'CurrentAxes',ax_h1)
%     image([576880 605400],[4405750 4336660],img)
% else
%     image_name = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data\Delta_map_panel3_800dpi.jpg';
%     img = imread(image_name);
%     set(gcf,'CurrentAxes',ax_h1)
%     image([1945501.542346085 2170501.542346085],[14173136.709339706 13846886.709339706],img)
% end
axis(ax_h1,'equal')
set(ax_h1,'ydir','normal')
% set(ax_h1,'xlim',[xmin xmax])
% set(ax_h1,'ylim',[ymid ymax])
set(ax_h1,'xlim',xLim1)
set(ax_h1,'ylim',yLim1)


for ii=1:cdivs
    idx = bink==ii;
    plot(ax_h1,xcoord(idx),ycoord(idx),'.','MarkerSize',dot_size,'Color',cmap(ii,:));
    hold(ax_h1,'on')
end
axis(ax_h1,'equal')

% set(ax_h,'xlim',I.SpatialRef.XLimWorld)
% set(ax_h,'ylim',I.SpatialRef.YLimWorld)
set(ax_h1,'xlim',xLim1)
set(ax_h1,'ylim',yLim1)
set(ax_h1,'xtick',[])
set(ax_h1,'ytick',[])
set(ax_h1,'box','on')

colormap(cmap);
% clear edges idx bink
% caxis(s1,[0 30])
% caxis([min(zcoord) max(zcoord)])
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


















