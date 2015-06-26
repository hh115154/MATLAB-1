%% This is an alternative to scatter which is very slow and sluggish
close all

% N = 100000;
x = xcoordN;
y = ycoordN;
C = zcoordN;

tic
load('YoloColormapsBlue','mycmap')
cdivs = length(mycmap);

[~, edges] = hist(C,cdivs-1);
edges = [-Inf edges Inf]; % to include all points
[Nk, bink] = histc(C,edges);

figure;
hold on;
cmap = jet(cdivs);
% cmap = mycmap;
for ii=1:cdivs
    idx = bink==ii;
    plot(x(idx),y(idx),'.','MarkerSize',4,'Color',cmap(ii,:));
end

colormap(cmap)
% caxis([min(C) max(C)])
% caxis([0 100])
caxis([0 max(C)])
colorbar
toc