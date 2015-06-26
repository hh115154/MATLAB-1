clear all
close all

% convert FLT to xyz for plotting

cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\results\NearBypass\grids')
flt_path = pwd;

filen = 'yolo_200ft_Exg_TS6_____2008_{NearBypass}_d_102216.flt';
hdrn  = 'yolo_200ft_Exg_TS6_____2008_{NearBypass}_d_102216.hdr';

fid = fopen(fullfile(flt_path,hdrn));

% open output file
fidw = fopen(sprintf('%s.xyz',filen(1:end-4)),'wt');
%% read header
S = textscan(fid,'%*s %f',6);
ncols = S{1}(1);
nrows = S{1}(2);
xcor = S{1}(3);
ycor = S{1}(4);
dxy = S{1}(5);
NoData = S{1}(6);

% %% unit
% elevation_unit = 'meter';

%% read raster data

GRID = readmtx(fullfile(flt_path,filen),nrows,ncols,'float32',[1 nrows],[1 ncols],'ieee-le');


%{
xmini = 1;
xmaxi = round((xmax-xcor)/dxy);

ymini = round((ymin-ycor)/dxy);
ymidi = round((ymid-ycor)/dxy);
ymaxi = round((ymax-ycor)/dxy);

GRID_N = GRID(ymidi:ymaxi,xmini:xmaxi);
GRID_S = GRID(ymini:ymidi,xmini:xmaxi);
%}
%% non-loop script
GRID(GRID==NoData) = NaN;
[ii,jj,v] = find(~isnan(GRID));

xcoord = xcor + jj.*dxy - dxy/2;
ycoord = (ycor + nrows*dxy) - ii*dxy + dxy/2;
zcoord = GRID(~isnan(GRID));

%% boundary (hardwired)
xmin = min(xcoord);
xmax = 2.04755958e6;

ymin = 1.391499203e7;
ymax = 1.409063861e7;
% ymid = 1.399924803e7;
ymid = (ymax+ymin)/2;

xcoordN = xcoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);
ycoordN = ycoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);
zcoordN = zcoord(xcoord>xmin & xcoord<xmax & ycoord>ymid & ycoord<ymax);

xcoordS = xcoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);
ycoordS = ycoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);
zcoordS = zcoord(xcoord>xmin & xcoord<xmax & ycoord>ymin & ycoord<ymid);

%{
% loop script
for n = nrows:-1:1
    
    
    %     C = textscan(fid,ffmt,1);
    temp = GRID(n,:);
    %     temp = cell2mat(C);
    
    id = find(temp~=NoData);
    if isempty(id)
        continue
    end
    xcoord = id.*dxy - dxy/2 + xcor;
    ycoord = zeros(1,length(xcoord)) + dxy*n - dxy/2 + ycor;
    zcoord = temp(id);
    
    switch elevation_unit
        case 'feet'
            zcoord = zcoord.*1200/3937;
        case 'meter'
            %            zcoord = zcoord;
    end
    
    fprintf(fidw,'%.1f %.1f %.2f\n',[xcoord' ycoord' zcoord']');
    clear temp
    
    if mod(n,10) ==0
        if ~isempty(id)
            display(sprintf('%3.2f %% Done - %d points extracted',(nrows-n)/nrows*100,length(id)))
        else
            display(sprintf('%3.2f %% Done',(nrows-n)/nrows*100))
        end
    end
    
end

fclose('all');

%% read xyz
fidx = fopen(sprintf('%s.xyz',filen(1:end-4)));
xyz_ = textscan(fidx,'%f%f%f');
xyz = cell2mat(xyz_);
x = xyz(:,1); y = xyz(:,2); z = xyz(:,3);

figure('Position',[200 50 300 950])
scatter(x,y,5,z,'s','filled')
fclose(fidx);
%}

%% load image
% image_name = 'C:\Work\13-1028_Liberty_Island_LM\Liberty_Island_Bing_Map_600dpi.jpg';
image_name = 'C:\Work\13-1027_Yolo\LT model\TUFLOW\results\NearBypass\1D_Bypass3.jpg';
img = imread(image_name);
% 
% image([601080 631950],[4249950 4221240],img)

%% North region
cell_size = 2;

hf_1 = figure('Position',[200 50 900 950]);

%   ------------------ NORTH
subplot(1,2,1)

image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
hold on

axis equal
axis tight
set(gca,'ydir','normal')
set(gca,'xlim',[xmin xmax])
set(gca,'ylim',[ymid ymax])

scatter(xcoordN,ycoordN,cell_size,zcoordN,'s','filled')
% set(gca,'xticklabel',[])
% set(gca,'yticklabel',[])
set(gca,'xtick',[])
set(gca,'ytick',[])

% hf_2 = figure('Position',[250 50 450 950]);

%   ------------------ SOUTH
subplot(1,2,2)

image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
hold on

axis equal
axis tight
set(gca,'ydir','normal')
set(gca,'xlim',[xmin xmax])
set(gca,'ylim',[ymin ymid])

set(gca,'xtick',[])
set(gca,'ytick',[])

scatter(xcoordS,ycoordS,cell_size,zcoordS,'s','filled')


% export_fig('sample_fig','-pdf','-nocrop','-transparent','-append',hf_1)
% print(hf_1,'-dpdf','sample2')



