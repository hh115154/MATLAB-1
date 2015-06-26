function Jflow_animation
close all

tic
%% parameters
font_size = 8;
font_name = 'Calibri';
% font_name = 'Helvetica';

switch font_name
    case 'Calibri'
        leg_ext = 1.2;   % this can be 1.2 for Calibri font; stretches the legned box a little
    case 'Helvetica'
        leg_ext = 1;
end


%% Figure dimension
% hf_1 = figure('Color','w','Position',[10 200 1378 800]);
% PaperW = 15.5;
% PaperH = 9;

fig_width = 1500;
fig_height = 580;
hf_1 = figure('Color','w','Position',[10 420 fig_width fig_height]);
PaperW = 15.5;
PaperH = 9;

% margins - pixel

L_marg = 40;  % left margin
ani_gap = 30;
ani_W = 290;
ani_H = 510;
R_marg = 60;  % right margin

Gap   = 95;
Gap_colorbar = 27.5;

ts_L =  L_marg+ani_W*3+ani_gap*2+Gap;

ts_H =  150;
ts_M =  (ani_H -3*ts_H)/2;
ts_W =  fig_width - (L_marg+ani_W*3+ani_gap*2+Gap) - R_marg;

bot_5 = 40;
bot_4 = bot_5+ts_H+ts_M;
bot_3 = bot_4+ts_H+ts_M;


subplots(1,1:4) = [L_marg bot_5 ani_W ani_H];
subplots(2,1:4) = [L_marg+ani_W+ani_gap bot_5 ani_W ani_H];
subplots(3,1:4) = [L_marg+(ani_W+ani_gap)*2 bot_5 ani_W ani_H];

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
pn = 'C:\Work\13-1009_SRV_Jflow_Ph2\Scenario 3';
cd(pn)

D_sce = dir('*.tif');
tStamp = zeros(length(D_sce),1);

%% Read shp file - cut lines
shp_path = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data';
shp_fn = 'UpperFeatherS2XSLines_line.shp';
Sn = shaperead(fullfile(shp_path,shp_fn));

%% Read shp file - animation window size
shp_path = 'C:\Work\13-1009_SRV_Jflow_Ph2\Input Data';
shp_fn2 = 'ani_window1.shp';
Sn_w = shaperead(fullfile(shp_path,shp_fn2));


% === calc animation window ratio
% set(s1,'units','inches')
win_size = get(s1,'position');
ani_WH_ratio = win_size(4)/win_size(3);

% ------- extent: panel 1 (north 2 / south 18)

xlimN1 = Sn_w(3).BoundingBox(1:2);
ylimN1 = Sn_w(3).BoundingBox(3:4);

% extent: panel 2
xlimN2 = Sn_w(1).BoundingBox(1:2);
ylimN2 = Sn_w(1).BoundingBox(3:4)+5100;

% extent: panel 3 
xlimN3 = Sn_w(2).BoundingBox(1:2);
ylimN3 = Sn_w(2).BoundingBox(3:4);

%% Reading data file

% sort data file in ascending time
for j = 1:length(D_sce)
    % hour
    in1 = regexp(D_sce(j).name,'_');
    in2 = regexp(D_sce(j).name,'\.');
    
    tStamp(j) = str2double(D_sce(j).name(in1(2)+1:in2(1)-1));
end

[t_hour, t_hour_i] = sort(tStamp);


% for k = 1:length(D_sce)
    
k = 6;
    % sorted by hour
    fn = D_sce(t_hour_i(k)).name;
    
    % 1st panel
    plot_tiff(fn,s1,xlimN1,ylimN1)
    
    % 2nd panel
    plot_tiff(fn,s2,xlimN2,ylimN2)
    
    % 3rd panel - Yolo
%     plot_tiff(fn,s3,xlimN3,ylimN3)
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
% end


toc

function plot_tiff(fn,ax_h,xLim,yLim)
%% Color definition
load('YoloColormapsBlue','mycmap')
new_cmap = mycmap(1:3:end,:);
cdivs = length(new_cmap);
% cdivs = length(mycmap);
% cdivs = 32;
color_Max = 10;
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

% figure
% hold on

% cmap = jet(cdivs);
cmap = new_cmap;

for ii=1:cdivs
    idx = bink==ii;
    plot(ax_h,xcoord(idx),ycoord(idx),'.','MarkerSize',dot_size,'Color',cmap(ii,:));
    hold(ax_h,'on')
end
axis(ax_h,'equal')

% set(ax_h,'xlim',I.SpatialRef.XLimWorld)
% set(ax_h,'ylim',I.SpatialRef.YLimWorld)
set(ax_h,'xlim',xLim)
set(ax_h,'ylim',yLim)
set(ax_h,'xtick',[])
set(ax_h,'ytick',[])
set(ax_h,'box','on')

colormap(cmap);
% clear edges idx bink
% caxis(s1,[0 30])
% caxis([min(zcoord) max(zcoord)])
caxis(ax_h,[0 color_Max])
% colorbar




















