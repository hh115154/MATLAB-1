clear all; close all
% profile on
tic
cd('C:\Work\13-1009_SRV_Jflow_Ph2\Scenario 3')

%%
fn = 'depth_27200301_351.004h.tif';
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


%% Plot
% plot(xcoord,ycoord,'.')
% axis equal
% profile viewer



%% scatter alternative
hf_1 = figure('Color','w','Position',[10 200 600 800]);

load('YoloColormapsBlue','mycmap')

new_cmap = mycmap(1:3:end,:);
cdivs = length(new_cmap);
% cdivs = length(mycmap);
% cdivs = 32;
color_Max = 10;
dot_size = 4;

edges = [-Inf linspace(0,color_Max,cdivs-1) Inf];
% [~, edges] = hist(zcoord,cdivs-1);
% edges = [-Inf edges Inf];
[~, bink] = histc(zcoord,edges);

% figure
% hold on

% cmap = jet(cdivs);
cmap = new_cmap;

for ii=1:cdivs
    idx = bink==ii;
    plot(xcoord(idx),ycoord(idx),'.','MarkerSize',dot_size,'Color',cmap(ii,:));
    hold on
end
set(gca,'xlim',I.SpatialRef.XLimWorld)
set(gca,'ylim',I.SpatialRef.YLimWorld)

colormap(cmap);
% clear edges idx bink
% caxis(s1,[0 30])
% caxis([min(zcoord) max(zcoord)])
caxis([0 color_Max])
axis equal
colorbar


toc