clear all
close all

% convert FLT to xyz for plotting

cd('C:\Work\13-1027_Yolo\LT model\TUFLOW\results\1999\NearBypass\grids')
flt_path = pwd;

% cur_path = pwd;
% D = dir('*.mat');
D = dir('yolo*Exg*d*.flt');
tic

nFrames = length(D)-1;   % exclude FLT with max values
% Preallocate movie structure.
mov(1:nFrames) = struct('cdata', [],...
                        'colormap', []);

hf_1 = figure('Position',[20 90 1200 900]);

for i = 1:length(D)
    
    if ~isempty(findstr(D(i).name,'Max'))
        continue
    end
    
    % eval(sprintf('%s = load(D(i).name);',D(i).name(1:end-4)))
    
    filen = D(i).name;
    hdrn = sprintf('%s.hdr',filen(1:end-4));
    

    hour_passed = str2double(filen(end-9:end-4));
    cur_date = addtodate(datenum([1996 10 2 0 0 0]),96408,'hour');
    
    % plot item
    switch filen(end-11)
        case 'd'
            p_item = 'Depth';
        case 'h'
            p_item = 'WSE';
        case 'V'
            p_item = 'Velocity';
    end
    
    % filen = 'yolo_200ft_Exg_TS6_____2008_NearBypass_d_102216.flt';
    % hdrn  = 'yolo_200ft_Exg_TS6_____2008_NearBypass_d_102216.hdr';
    
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
    
    fclose(fid);
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
    
    %   ------------------ NORTH
    subplot(3,3,[1 4 7])
    image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
    hold on
    
    axis equal
    axis tight
    set(gca,'ydir','normal')
    set(gca,'xlim',[xmin xmax])
    set(gca,'ylim',[ymid ymax])
    
    scatter(xcoordN,ycoordN,cell_size,zcoordN,'s','filled')
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    
%     colorbar('location','Northoutside')
    caxis([0 30])
    
    %   ------------------ SOUTH
    subplot(3,3,[2 5 8])
    
    image([1795815.49709008  2266061.54453419],[14137059.14882920 13844931.08527370],img)
    hold on
    
    axis equal
    axis tight
    set(gca,'ydir','normal')
    set(gca,'xlim',[xmin xmax])
    set(gca,'ylim',[ymin ymid])
    
    
    scatter(xcoordS,ycoordS,cell_size,zcoordS,'s','filled')
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    
    
%     colorbar('location','Northoutside')

    caxis([0 30])
    
    mov(i) = getframe(gcf);
    
    set(gca,'nextplot','replacechildren');

    
    
%     subplot(3,3,3)
%     
%     
%     subplot(3,3,6)
%     
%     subplot(3,3,9)
        % plot title
    xlabel(sprintf('%s: %s',p_item,datestr(cur_date,'mmm dd, yyyy HH:MM')))

    toc
    
end

% export_fig('sample_fig','-pdf','-nocrop','-transparent','-append',hf_1)
% print(hf_1,'-dpdf','sample2')

% Create AVI file.
movie2avi(mov, 'mySample.avi', 'compression', 'none','fps',1);

